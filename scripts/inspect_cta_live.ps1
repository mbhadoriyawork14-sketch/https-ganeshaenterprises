param(
    [string]$url = "http://localhost:8080/index.html",
    [string]$outputScreenshot = "cta_actual_render.png"
)

$userDataDir = [System.IO.Path]::Combine($env:TEMP, "chrome_cdp_" + [System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $userDataDir -Force | Out-Null

$chromeArgs = @(
    "--remote-debugging-port=9223",
    "--headless=new",
    "--disable-gpu",
    "--no-sandbox",
    "--window-size=1440,900",
    "--user-data-dir=$userDataDir",
    $url
)

$proc = Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList $chromeArgs -PassThru
Start-Sleep -Seconds 3

try {
    $wc = New-Object System.Net.WebClient
    $jsonStr = $wc.DownloadString("http://localhost:9223/json")
    $pages = $jsonStr | ConvertFrom-Json
    $targetPage = $pages | Where-Object { $_.type -eq "page" -and $_.url -like "*localhost:8080*" } | Select-Object -First 1

    if (!$targetPage) {
        $targetPage = $pages | Where-Object { $_.type -eq "page" } | Select-Object -First 1
    }

    $wsUrl = $targetPage.webSocketDebuggerUrl
    Write-Host "Connecting to CDP WebSocket: $wsUrl"

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

    Start-Sleep -Seconds 2

    # Scroll CTA into view
    $scrollJs = "document.querySelector('.dark-cta-section').scrollIntoView({behavior: 'instant', block: 'center'});"
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = $scrollJs }
    Start-Sleep -Seconds 1

    # Capture screenshot
    $shotRes = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shotRes.result.data) {
        $imgBytes = [System.Convert]::FromBase64String($shotRes.result.data)
        [System.IO.File]::WriteAllBytes($outputScreenshot, $imgBytes)
        Write-Host "Screenshot captured successfully: $outputScreenshot"
    } else {
        Write-Host "Failed to capture screenshot"
    }

    $ws.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "Done", $cts.Token).Wait()
} finally {
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $userDataDir -Recurse -Force -ErrorAction SilentlyContinue
}
