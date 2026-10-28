$urls = @(
    "http://localhost:8080/index.html",
    "http://localhost:8080/about.html",
    "http://localhost:8080/services.html",
    "http://localhost:8080/products.html",
    "http://localhost:8080/portfolio.html",
    "http://localhost:8080/blog.html",
    "http://localhost:8080/contact.html",
    "http://localhost:8080/privacy-policy.html",
    "http://localhost:8080/terms-and-conditions.html",
    "http://localhost:8080/services/corporate-office-printing.html",
    "http://localhost:8080/services/marketing-promotional-printing.html",
    "http://localhost:8080/services/customized-merchandise.html",
    "http://localhost:8080/services/packaging-labels.html",
    "http://localhost:8080/services/large-format-event-printing.html",
    "http://localhost:8080/services/books-photo-products.html",
    "http://localhost:8080/services/premium-finishing.html",
    "http://localhost:8080/services/digital-personalized-printing.html",
    "http://localhost:8080/blog/why-custom-printing-is-the-secret-weapon.html",
    "http://localhost:8080/blog/t-shirts-to-tumblers-top-10-custom-products.html",
    "http://localhost:8080/css/style.css",
    "http://localhost:8080/js/main.js"
)

$wc = New-Object System.Net.WebClient
$success = 0
$failed = 0

foreach ($u in $urls) {
    try {
        $res = $wc.DownloadString($u)
        Write-Output "[200 OK] $u ($($res.Length) bytes)"
        $success++
    } catch {
        Write-Output "[ERROR] $u - $_"
        $failed++
    }
}

Write-Output "Summary: $success successful, $failed failed."
