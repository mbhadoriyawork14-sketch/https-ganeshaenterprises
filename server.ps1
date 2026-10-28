param(
    [int]$port = 8080
)

$root = (Get-Location).Path

$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".htm"  = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".svg"  = "image/svg+xml"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".webp" = "image/webp"
    ".gif"  = "image/gif"
    ".ico"  = "image/x-icon"
    ".mp4"  = "video/mp4"
    ".woff" = "font/woff"
    ".woff2"= "font/woff2"
    ".ttf"  = "font/ttf"
}

$listener = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Any, $port)

try {
    $listener.Start()
} catch {
    Write-Host "Error binding to port ${port}: $_"
    exit 1
}

Write-Host "=========================================================="
Write-Host "  GANESHA ENTERPRISES WEB SERVER RUNNING"
Write-Host "  URL: http://localhost:$port/"
Write-Host "  Root: $root"
Write-Host "=========================================================="

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $stream = $client.GetStream()
            
            # Read request headers with timeout
            $client.ReceiveTimeout = 3000
            $client.SendTimeout = 5000

            $headerBytes = New-Object System.Collections.Generic.List[byte]
            $matched = 0
            while ($true) {
                $b = $stream.ReadByte()
                if ($b -eq -1) { break }
                $headerBytes.Add([byte]$b)
                
                # Check for \r\n\r\n
                $cnt = $headerBytes.Count
                if ($cnt -ge 4) {
                    if ($headerBytes[$cnt-4] -eq 13 -and $headerBytes[$cnt-3] -eq 10 -and $headerBytes[$cnt-2] -eq 13 -and $headerBytes[$cnt-1] -eq 10) {
                        break
                    }
                }
            }

            if ($headerBytes.Count -eq 0) {
                $client.Close()
                continue
            }

            $headerText = [System.Text.Encoding]::ASCII.GetString($headerBytes.ToArray())
            $lines = $headerText -split "\r?\n"
            if ($lines.Length -eq 0 -or [string]::IsNullOrEmpty($lines[0])) {
                $client.Close()
                continue
            }

            $tokens = $lines[0] -split " "
            if ($tokens.Length -lt 2) {
                $client.Close()
                continue
            }

            $method = $tokens[0]
            $rawUrl = $tokens[1]
            $urlPath = ($rawUrl -split "\?")[0]
            $urlPath = [System.Uri]::UnescapeDataString($urlPath)

            if ($urlPath -eq "/" -or [string]::IsNullOrEmpty($urlPath)) {
                $urlPath = "/index.html"
            }

            # Normalize path
            $relPath = $urlPath.TrimStart('/').Replace('/', [System.IO.Path]::DirectorySeparatorChar)
            $localPath = [System.IO.Path]::Combine($root, $relPath)
            $publicPath = [System.IO.Path]::Combine($root, "public", $relPath)

            if (!(Test-Path -LiteralPath $localPath -PathType Leaf) -and (Test-Path -LiteralPath $publicPath -PathType Leaf)) {
                $localPath = $publicPath
            }

            # Parse Range header if present
            $rangeStart = -1
            $rangeEnd = -1
            foreach ($line in $lines) {
                if ($line -match "^Range:\s*bytes=(\d+)-(\d*)") {
                    $rangeStart = [long]$matches[1]
                    if (![string]::IsNullOrEmpty($matches[2])) {
                        $rangeEnd = [long]$matches[2]
                    }
                    break
                }
            }

            if (Test-Path -LiteralPath $localPath -PathType Leaf) {
                $fileItem = Get-Item -LiteralPath $localPath
                $fileLen = $fileItem.Length
                $ext = [System.IO.Path]::GetExtension($localPath).ToLower()
                $mime = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }

                if ($rangeStart -ge 0) {
                    if ($rangeEnd -lt 0 -or $rangeEnd -ge $fileLen) { $rangeEnd = $fileLen - 1 }
                    $chunkSize = $rangeEnd - $rangeStart + 1

                    $respHeader = "HTTP/1.1 206 Partial Content`r`n" +
                                  "Content-Type: $mime`r`n" +
                                  "Content-Range: bytes $rangeStart-$rangeEnd/$fileLen`r`n" +
                                  "Content-Length: $chunkSize`r`n" +
                                  "Accept-Ranges: bytes`r`n" +
                                  "Access-Control-Allow-Origin: *`r`n" +
                                  "Connection: close`r`n`r`n"

                    $hBytes = [System.Text.Encoding]::ASCII.GetBytes($respHeader)
                    $stream.Write($hBytes, 0, $hBytes.Length)

                    $fs = [System.IO.File]::OpenRead($localPath)
                    $fs.Seek($rangeStart, [System.IO.SeekOrigin]::Begin) | Out-Null
                    $buf = New-Object byte[] 65536
                    $rem = $chunkSize
                    while ($rem -gt 0) {
                        $toRead = [Math]::Min($rem, [long]$buf.Length)
                        $read = $fs.Read($buf, 0, [int]$toRead)
                        if ($read -le 0) { break }
                        $stream.Write($buf, 0, $read)
                        $rem -= $read
                    }
                    $fs.Close()
                } else {
                    $respHeader = "HTTP/1.1 200 OK`r`n" +
                                  "Content-Type: $mime`r`n" +
                                  "Content-Length: $fileLen`r`n" +
                                  "Accept-Ranges: bytes`r`n" +
                                  "Access-Control-Allow-Origin: *`r`n" +
                                  "Connection: close`r`n`r`n"

                    $hBytes = [System.Text.Encoding]::ASCII.GetBytes($respHeader)
                    $stream.Write($hBytes, 0, $hBytes.Length)

                    $fs = [System.IO.File]::OpenRead($localPath)
                    $buf = New-Object byte[] 65536
                    while ($true) {
                        $read = $fs.Read($buf, 0, $buf.Length)
                        if ($read -le 0) { break }
                        $stream.Write($buf, 0, $read)
                    }
                    $fs.Close()
                }
            } else {
                $errBody = "404 Not Found: $urlPath"
                $errBytes = [System.Text.Encoding]::UTF8.GetBytes($errBody)
                $respHeader = "HTTP/1.1 404 Not Found`r`n" +
                              "Content-Type: text/plain; charset=utf-8`r`n" +
                              "Content-Length: $($errBytes.Length)`r`n" +
                              "Connection: close`r`n`r`n"
                $hBytes = [System.Text.Encoding]::ASCII.GetBytes($respHeader)
                $stream.Write($hBytes, 0, $hBytes.Length)
                $stream.Write($errBytes, 0, $errBytes.Length)
            }
            $stream.Flush()
        } catch {
            # Client disconnect
        } finally {
            $client.Close()
        }
    }
} finally {
    $listener.Stop()
}
