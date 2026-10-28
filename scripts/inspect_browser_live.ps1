param(
    [string]$url = "http://localhost:8080/index.html",
    [string]$outputScreenshot = "hero_actual_render.png"
)

# 1. Start Chrome with remote debugging
$userDataDir = [System.IO.Path]::Combine($env:TEMP, "chrome_cdp_" + [System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $userDataDir -Force | Out-Null

$chromeArgs = @(
    "--remote-debugging-port=9222",
    "--headless=new",
    "--disable-gpu",
    "--no-sandbox",
    "--window-size=1440,960",
    "--user-data-dir=$userDataDir",
    $url
)

$proc = Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList $chromeArgs -PassThru
Start-Sleep -Seconds 3

try {
    # 2. Get WebSocket Debugger URL
    $wc = New-Object System.Net.WebClient
    $jsonStr = $wc.DownloadString("http://localhost:9222/json")
    $pages = $jsonStr | ConvertFrom-Json
    $targetPage = $pages | Where-Object { $_.type -eq "page" -and $_.url -like "*localhost:8080*" } | Select-Object -First 1

    if (!$targetPage) {
        $targetPage = $pages | Where-Object { $_.type -eq "page" } | Select-Object -First 1
    }

    if (!$targetPage) {
        Write-Error "No page found in Chrome CDP"
        return
    }

    $wsUrl = $targetPage.webSocketDebuggerUrl
    Write-Host "Connecting to CDP WebSocket: $wsUrl"

    # 3. Connect via ClientWebSocket
    $ws = New-Object System.Net.WebSockets.ClientWebSocket
    $cts = New-Object System.Threading.CancellationTokenSource
    $task = $ws.ConnectAsync([System.Uri]::new($wsUrl), $cts.Token)
    $task.Wait(5000)

    function Send-CdpCommand($method, $params = @{}) {
        $id = Get-Random -Minimum 1000 -Maximum 99999
        $msg = @{ id = $id; method = $method; params = $params } | ConvertTo-Json -Compress
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($msg)
        $segment = [System.ArraySegment[byte]]::new($bytes)
        $ws.SendAsync($segment, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, $cts.Token).Wait()

        $buffer = New-Object byte[] (1024 * 1024 * 5)
        $builder = New-Object System.Text.StringBuilder

        do {
            $recvSegment = [System.ArraySegment[byte]]::new($buffer)
            $res = $ws.ReceiveAsync($recvSegment, $cts.Token)
            $res.Wait()
            $builder.Append([System.Text.Encoding]::UTF8.GetString($buffer, 0, $res.Result.Count))
        } while (!$res.Result.EndOfMessage)

        return $builder.ToString() | ConvertFrom-Json
    }

    # Give page time to load and start video
    Start-Sleep -Seconds 2

    # Evaluate video state
    $jsVideoState = @'
(() => {
  const v = document.querySelector('.hero-background-video');
  const o = document.querySelector('.hero-video-overlay');
  const c = document.querySelector('.hero-content-wrap');
  const s = document.querySelector('.hero-section');
  if (!v) return { error: 'No video element' };
  
  const vStyle = window.getComputedStyle(v);
  const oStyle = o ? window.getComputedStyle(o) : null;
  const cStyle = c ? window.getComputedStyle(c) : null;
  const sStyle = s ? window.getComputedStyle(s) : null;
  
  return {
    video: {
      paused: v.paused,
      currentTime: v.currentTime,
      duration: v.duration,
      readyState: v.readyState,
      videoWidth: v.videoWidth,
      videoHeight: v.videoHeight,
      opacity: vStyle.opacity,
      zIndex: vStyle.zIndex,
      objectFit: vStyle.objectFit,
      objectPosition: vStyle.objectPosition,
      display: vStyle.display,
      visibility: vStyle.visibility
    },
    overlay: oStyle ? {
      zIndex: oStyle.zIndex,
      background: oStyle.background,
      opacity: oStyle.opacity,
      display: oStyle.display
    } : null,
    content: cStyle ? {
      zIndex: cStyle.zIndex,
      opacity: cStyle.opacity,
      display: cStyle.display
    } : null,
    section: sStyle ? {
      background: sStyle.background,
      backgroundColor: sStyle.backgroundColor,
      isolation: sStyle.isolation
    } : null
  };
})()
'@

    $evalRes = Send-CdpCommand "Runtime.evaluate" @{ expression = $jsVideoState; returnByValue = $true }
    $val = if ($evalRes.result.result.value) { $evalRes.result.result.value } else { $evalRes.result.value }
    Write-Host "--- COMPUTED STYLES & VIDEO STATE ---"
    $val | ConvertTo-Json -Depth 5 | Write-Host

    # 4. Capture screenshot
    $shotRes = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shotRes.result.data) {
        $imgBytes = [System.Convert]::FromBase64String($shotRes.result.data)
        [System.IO.File]::WriteAllBytes($outputScreenshot, $imgBytes)
        Write-Host "Screenshot captured successfully: $outputScreenshot ($( (Get-Item $outputScreenshot).Length ) bytes)"
    } else {
        Write-Host "Failed to capture screenshot: $($shotRes | ConvertTo-Json -Compress)"
    }

    $ws.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "Done", $cts.Token).Wait()
} finally {
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $userDataDir -Recurse -Force -ErrorAction SilentlyContinue
}
