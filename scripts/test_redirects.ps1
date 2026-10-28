$redirects = @(
    "http://localhost:8080/about_us.html",
    "http://localhost:8080/service.html",
    "http://localhost:8080/shop.html",
    "http://localhost:8080/shop _Business_Essentials.html",
    "http://localhost:8080/shop _Love_Your_New_Look.html",
    "http://localhost:8080/shop_Made_by_You.html",
    "http://localhost:8080/shop_Home_&_Gifts.html",
    "http://localhost:8080/blog_grid.html",
    "http://localhost:8080/blog_1.html",
    "http://localhost:8080/blog_2.html",
    "http://localhost:8080/service_Corporate_Office_Printing.html",
    "http://localhost:8080/service_Marketing_&_Promotional_Printing.html",
    "http://localhost:8080/service_Customized_Merchandise.html",
    "http://localhost:8080/service_Packaging_&_Labels.html",
    "http://localhost:8080/service_Large_Format_&_Event_Printing.html",
    "http://localhost:8080/service_Books_&_Photo_Products.html",
    "http://localhost:8080/service_Premium_Finishing.html",
    "http://localhost:8080/service_Digital_&_Personalized_Printing.html"
)

$wc = New-Object System.Net.WebClient
$success = 0
$failed = 0

foreach ($u in $redirects) {
    try {
        $res = $wc.DownloadString($u)
        Write-Output "[200 OK Redirect] $u"
        $success++
    } catch {
        Write-Output "[FAIL Redirect] $u : $_"
        $failed++
    }
}
Write-Output "Legacy Redirects Summary: $success passed, $failed failed."
