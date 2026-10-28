$userDataDir = [System.IO.Path]::Combine($env:TEMP, "chrome_cdp_rawvideo")
New-Item -ItemType Directory -Path $userDataDir -Force | Out-Null

$chromeArgs = @(
    "--remote-debugging-port=9223",
    "--headless=new",
    "--disable-gpu",
    "--no-sandbox",
    "--window-size=1280,720",
    "--user-data-dir=$userDataDir",
    "http://localhost:8080/videos/hero-background.mp4"
)

$proc = Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList $chromeArgs -PassThru
Start-Sleep -Seconds 3

try {
    $wc = New-Object System.Net.WebClient
    $jsonStr = $wc.DownloadString("http://localhost:9223/json")
    $pages = $jsonStr | ConvertFrom-Json
    $targetPage = $pages | Where-Object { $_.type -eq "page" } | Select-Object -First 1

    $wsUrl = $targetPage.webSocketDebuggerUrl
    $ws = New-Object System.Net.WebSockets.ClientWebSocket
    $cts = New-Object System.Threading.CancellationTokenSource
    $ws.ConnectAsync([System.Uri]::new($wsUrl), $cts.Token).Wait(5000)

    function Send-Cmd($method, $params = @{}) {
        $msg = @{ id = 1; method = $method; params = $params } | ConvertTo-Json -Compress
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
    $shot = Send-Cmd "Page.captureScreenshot" @{ format = "png" }
    if ($shot.result.data) {
        [System.IO.File]::WriteAllBytes("raw_video_frame.png", [System.Convert]::FromBase64String($shot.result.data))
        Write-Host "Captured raw_video_frame.png ($( (Get-Item 'raw_video_frame.png').Length ) bytes)"
    }
} finally {
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $userDataDir -Recurse -Force -ErrorAction SilentlyContinue
}
