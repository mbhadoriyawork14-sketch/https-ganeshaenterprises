param(
    [int]$port = 8080
)

$userDataDir = [System.IO.Path]::Combine($env:TEMP, "chrome_cdp_showcase_" + [System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $userDataDir -Force | Out-Null

$chromeArgs = @(
    "--remote-debugging-port=9225",
    "--headless=new",
    "--disable-gpu",
    "--no-sandbox",
    "--window-size=1440,960",
    "--user-data-dir=$userDataDir",
    "http://localhost:$port/index.html"
)

$proc = Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList $chromeArgs -PassThru
Start-Sleep -Seconds 3

try {
    $wc = New-Object System.Net.WebClient
    $jsonStr = $wc.DownloadString("http://localhost:9225/json")
    $pages = $jsonStr | ConvertFrom-Json
    $targetPage = $pages | Where-Object { $_.type -eq "page" -and $_.url -like "*localhost:$port*" } | Select-Object -First 1

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

    # 1. Scroll to Product Showcase Section on Homepage
    Write-Host "Scrolling to #productShowcase..."
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.getElementById('productShowcase').scrollIntoView({behavior: 'instant', block: 'center'});" }
    Start-Sleep -Seconds 1
    
    # Ensure reveal class is applied
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.getElementById('productShowcase').classList.add('is-revealed');" }
    Start-Sleep -Seconds 1

    # Capture Desktop Showcase Grid
    $shot = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shot.result.data) {
        [System.IO.File]::WriteAllBytes("render_showcase_desktop.png", [System.Convert]::FromBase64String($shot.result.data))
        Write-Host "Captured render_showcase_desktop.png"
    }

    # 2. Open Modal by clicking Tile 3 (NTPC Cap)
    Write-Host "Clicking Tile 3 to test interactive lightbox modal..."
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.querySelectorAll('.showcase-tile')[2].click();" }
    Start-Sleep -Seconds 1

    $shotModal = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shotModal.result.data) {
        [System.IO.File]::WriteAllBytes("render_showcase_modal_open.png", [System.Convert]::FromBase64String($shotModal.result.data))
        Write-Host "Captured render_showcase_modal_open.png"
    }

    # 3. Test Next Button in Modal
    Write-Host "Clicking next button in modal..."
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.querySelector('.showcase-modal-nav.next').click();" }
    Start-Sleep -Seconds 1

    $shotNext = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shotNext.result.data) {
        [System.IO.File]::WriteAllBytes("render_showcase_modal_next.png", [System.Convert]::FromBase64String($shotNext.result.data))
        Write-Host "Captured render_showcase_modal_next.png"
    }

    # 4. Close Modal
    Write-Host "Closing modal..."
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.querySelector('.showcase-modal-close').click();" }
    Start-Sleep -Seconds 1

    # 5. Mobile Viewport Test (390 x 844)
    Write-Host "Testing mobile viewport (390 x 844)..."
    $null = Send-CdpCommand "Emulation.setDeviceMetricsOverride" @{ width = 390; height = 844; deviceScaleFactor = 2; mobile = $true }
    Start-Sleep -Seconds 1
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.getElementById('productShowcase').scrollIntoView({behavior: 'instant', block: 'start'});" }
    Start-Sleep -Seconds 1

    $shotMobile = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shotMobile.result.data) {
        [System.IO.File]::WriteAllBytes("render_showcase_mobile.png", [System.Convert]::FromBase64String($shotMobile.result.data))
        Write-Host "Captured render_showcase_mobile.png"
    }

    Write-Host "All showcase live tests completed successfully!"
    $ws.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "Done", $cts.Token).Wait()
} finally {
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $userDataDir -Recurse -Force -ErrorAction SilentlyContinue
}

