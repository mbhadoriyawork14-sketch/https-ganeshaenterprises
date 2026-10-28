$rootDir = Resolve-Path (Join-Path $PSScriptRoot "..")
$distDir = Join-Path $rootDir "dist"

Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  Ganesha Enterprises - Local Build Script (PowerShell)" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "[build-dist] Source: $rootDir"
Write-Host "[build-dist] Target: $distDir"

if (Test-Path $distDir) {
    Write-Host "[build-dist] Clearing existing dist directory..."
    Remove-Item -Path $distDir -Recurse -Force
}
New-Item -Path $distDir -ItemType Directory -Force | Out-Null

$htmlAndMeta = Get-ChildItem -Path $rootDir -File | Where-Object {
    $_.Extension -eq ".html" -or $_.Name -in @("robots.txt", "sitemap.xml", "favicon.ico", "favicon.svg", "manifest.json", ".env.example")
}

$fileCount = 0
foreach ($file in $htmlAndMeta) {
    Copy-Item -Path $file.FullName -Destination (Join-Path $distDir $file.Name) -Force
    $fileCount++
}
Write-Host "[build-dist] Copied $fileCount root HTML and metadata files."

$dirsToCopy = @("assets", "css", "js", "services", "blog", "content", "public", "videos")
$dirCount = 0

foreach ($dir in $dirsToCopy) {
    $src = Join-Path $rootDir $dir
    $dest = Join-Path $distDir $dir
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dest -Recurse -Force
        $dirCount++
        Write-Host "[build-dist] Copied directory: $dir/"
    }
}

$indexPath = Join-Path $distDir "index.html"
if (-not (Test-Path $indexPath) -or (Get-Item $indexPath).Length -eq 0) {
    Write-Error "[build-dist] ERROR: dist/index.html was not generated or is empty!"
    exit 1
}

Write-Host "====================================================" -ForegroundColor Green
Write-Host "[build-dist] SUCCESS: dist populated with $fileCount files and $dirCount directories." -ForegroundColor Green
Write-Host "====================================================" -ForegroundColor Green
