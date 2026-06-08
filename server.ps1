# ISRASKI Local Server
# Run as Administrator for phone access on same WiFi
# Double-click -> "Run with PowerShell" or right-click -> "Run as Administrator"

$port     = 8080
$rootPath = Split-Path -Parent $MyInvocation.MyCommand.Path

$localIP = (Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.InterfaceAlias -notlike '*Loopback*' -and $_.IPAddress -notlike '169.*' } |
    Select-Object -First 1).IPAddress

$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://+:$port/")

try {
    $listener.Start()
} catch {
    Write-Host "`nERROR: Run this script as Administrator (right-click -> Run as Administrator)" -ForegroundColor Red
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

$mimeTypes = @{
    ".html"  = "text/html; charset=utf-8"
    ".css"   = "text/css; charset=utf-8"
    ".js"    = "application/javascript"
    ".json"  = "application/json"
    ".png"   = "image/png"
    ".jpg"   = "image/jpeg"
    ".jpeg"  = "image/jpeg"
    ".webp"  = "image/webp"
    ".gif"   = "image/gif"
    ".svg"   = "image/svg+xml"
    ".ico"   = "image/x-icon"
    ".woff"  = "font/woff"
    ".woff2" = "font/woff2"
    ".ttf"   = "font/ttf"
    ".mp4"   = "video/mp4"
}

Write-Host ""
Write-Host "  ╔══════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║       ISRASKI Local Server           ║" -ForegroundColor Cyan
Write-Host "  ╠══════════════════════════════════════╣" -ForegroundColor Cyan
Write-Host "  ║  Computer: http://localhost:$port     ║" -ForegroundColor Cyan
Write-Host "  ║  Phone:    http://${localIP}:$port    ║" -ForegroundColor Green
Write-Host "  ╚══════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Connect your phone to the same WiFi and open the Phone URL." -ForegroundColor Yellow
Write-Host "  Press Ctrl+C to stop the server." -ForegroundColor Gray
Write-Host ""

try {
    while ($listener.IsListening) {
        $contextTask = $listener.GetContextAsync()
        while (-not $contextTask.IsCompleted) { Start-Sleep -Milliseconds 50 }
        $context  = $contextTask.Result
        $request  = $context.Request
        $response = $context.Response

        $urlPath = $request.Url.LocalPath
        if ($urlPath -eq "/" -or $urlPath -eq "") { $urlPath = "/index.html" }

        # Decode URL (handles Hebrew characters in paths)
        $urlPath   = [Uri]::UnescapeDataString($urlPath)
        $filePath  = Join-Path $rootPath ($urlPath.TrimStart("/").Replace("/", "\"))

        Write-Host "  $($request.HttpMethod) $urlPath" -ForegroundColor DarkGray

        if (Test-Path $filePath -PathType Leaf) {
            $ext  = [IO.Path]::GetExtension($filePath).ToLower()
            $mime = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }

            $bytes = [IO.File]::ReadAllBytes($filePath)
            $response.StatusCode      = 200
            $response.ContentType     = $mime
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $body  = [Text.Encoding]::UTF8.GetBytes("404 - Not Found: $urlPath")
            $response.StatusCode      = 404
            $response.ContentType     = "text/plain"
            $response.ContentLength64 = $body.Length
            $response.OutputStream.Write($body, 0, $body.Length)
        }

        $response.OutputStream.Close()
    }
} finally {
    $listener.Stop()
    Write-Host "Server stopped." -ForegroundColor Gray
}
