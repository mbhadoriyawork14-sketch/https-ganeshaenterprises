param(
    [int]$port = 8080
)

# 1. Start server in background job if port not listening
$serverJob = $null
$active = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
if (!$active) {
    Write-Host "Starting server job on port $port..."
    $serverJob = Start-Job -ScriptBlock {
        param($p, $dir)
        Set-Location $dir
        powershell -ExecutionPolicy Bypass -File "server.ps1"
    } -ArgumentList $port, (Get-Location).Path
    Start-Sleep -Seconds 2
}

$userDataDir = [System.IO.Path]::Combine($env:TEMP, "chrome_cdp_cards_" + [System.Guid]::NewGuid().ToString())
New-Item -ItemType Directory -Path $userDataDir -Force | Out-Null

$chromeArgs = @(
    "--remote-debugging-port=9224",
    "--headless=new",
    "--disable-gpu",
    "--no-sandbox",
    "--window-size=1440,900",
    "--user-data-dir=$userDataDir",
    "http://localhost:$port/index.html"
)

$proc = Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList $chromeArgs -PassThru
Start-Sleep -Seconds 3

try {
    $wc = New-Object System.Net.WebClient
    $jsonStr = $wc.DownloadString("http://localhost:9224/json")
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

    # A. Capture Process Cards on Homepage
    Write-Host "Scrolling to Process Cards..."
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.querySelector('.steps-grid').scrollIntoView({behavior: 'instant', block: 'center'});" }
    Start-Sleep -Seconds 1
    $shot = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shot.result.data) {
        [System.IO.File]::WriteAllBytes("render_index_process_cards.png", [System.Convert]::FromBase64String($shot.result.data))
        Write-Host "Captured render_index_process_cards.png"
    }

    # B. Capture Services Grid on Homepage
    Write-Host "Scrolling to Services Grid..."
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.querySelector('.services-grid').scrollIntoView({behavior: 'instant', block: 'center'});" }
    Start-Sleep -Seconds 1
    $shot = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shot.result.data) {
        [System.IO.File]::WriteAllBytes("render_index_services_grid.png", [System.Convert]::FromBase64String($shot.result.data))
        Write-Host "Captured render_index_services_grid.png"
    }

    # C. Navigate to services.html
    Write-Host "Navigating to services.html..."
    $null = Send-CdpCommand "Page.navigate" @{ url = "http://localhost:$port/services.html" }
    Start-Sleep -Seconds 3

    # Scroll to services hub grid
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.querySelector('.services-hub-grid').scrollIntoView({behavior: 'instant', block: 'start'});" }
    Start-Sleep -Seconds 1
    $shot = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shot.result.data) {
        [System.IO.File]::WriteAllBytes("render_services_hub_grid.png", [System.Convert]::FromBase64String($shot.result.data))
        Write-Host "Captured render_services_hub_grid.png"
    }

    # Scroll to Process section on services.html
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.querySelector('.steps-grid').scrollIntoView({behavior: 'instant', block: 'center'});" }
    Start-Sleep -Seconds 1
    $shot = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shot.result.data) {
        [System.IO.File]::WriteAllBytes("render_services_process_section.png", [System.Convert]::FromBase64String($shot.result.data))
        Write-Host "Captured render_services_process_section.png"
    }

    # D. Mobile Viewport Test (375 x 812)
    Write-Host "Testing mobile viewport on services.html..."
    $null = Send-CdpCommand "Emulation.setDeviceMetricsOverride" @{ width = 375; height = 812; deviceScaleFactor = 2; mobile = $true }
    Start-Sleep -Seconds 1
    $null = Send-CdpCommand "Runtime.evaluate" @{ expression = "document.querySelector('.service-card').scrollIntoView({behavior: 'instant', block: 'center'});" }
    Start-Sleep -Seconds 1
    $shot = Send-CdpCommand "Page.captureScreenshot" @{ format = "png" }
    if ($shot.result.data) {
        [System.IO.File]::WriteAllBytes("render_mobile_service_card.png", [System.Convert]::FromBase64String($shot.result.data))
        Write-Host "Captured render_mobile_service_card.png"
    }

    $ws.CloseAsync([System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure, "Done", $cts.Token).Wait()
} finally {
    Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $userDataDir -Recurse -Force -ErrorAction SilentlyContinue
    if ($serverJob) {
        Stop-Job $serverJob
        Remove-Job $serverJob
    }
}

