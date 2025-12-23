# JMeter Prometheus Plugin Download Script
# Run this script from PowerShell

$jmeterExtPath = "$env:USERPROFILE\AppData\Roaming\JetBrains\IntelliJIdea2025.2\apache-jmeter-5.6.3\lib\ext"
$pluginUrl = "https://github.com/johrstrom/jmeter-prometheus-plugin/releases/download/v0.6.0/jmeter-prometheus-plugin-0.6.0.jar"
$outputFile = Join-Path $jmeterExtPath "jmeter-prometheus-plugin-0.6.0.jar"

Write-Host "JMeter Prometheus Plugin Downloader" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check if directory exists
if (-not (Test-Path $jmeterExtPath)) {
    Write-Host "ERROR: JMeter lib/ext directory not found at:" -ForegroundColor Red
    Write-Host $jmeterExtPath -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please update the path in this script to match your JMeter installation." -ForegroundColor Yellow
    exit 1
}

Write-Host "Target directory: $jmeterExtPath" -ForegroundColor Green
Write-Host "Download URL: $pluginUrl" -ForegroundColor Green
Write-Host ""

# Check if file already exists
if (Test-Path $outputFile) {
    Write-Host "Plugin already exists at: $outputFile" -ForegroundColor Yellow
    $overwrite = Read-Host "Do you want to overwrite it? (y/n)"
    if ($overwrite -ne "y" -and $overwrite -ne "Y") {
        Write-Host "Download cancelled." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host "Downloading plugin..." -ForegroundColor Cyan

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $ProgressPreference = 'SilentlyContinue'
    
    Invoke-WebRequest -Uri $pluginUrl -OutFile $outputFile -UseBasicParsing -ErrorAction Stop
    
    if (Test-Path $outputFile) {
        $fileSize = (Get-Item $outputFile).Length
        Write-Host ""
        Write-Host "SUCCESS! Plugin downloaded successfully." -ForegroundColor Green
        Write-Host "File location: $outputFile" -ForegroundColor Green
        Write-Host "File size: $([math]::Round($fileSize/1KB, 2)) KB" -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Restart JMeter if it's currently running" -ForegroundColor White
        Write-Host "2. Open your test plan: Jmeter\EmotiCare_Full_API_Test.jmx" -ForegroundColor White
        Write-Host "3. Run the test - metrics will be available at http://localhost:9270/metrics" -ForegroundColor White
    } else {
        Write-Host "ERROR: Download completed but file not found." -ForegroundColor Red
    }
} catch {
    Write-Host ""
    Write-Host "ERROR: Automatic download failed." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Please download manually:" -ForegroundColor Yellow
    Write-Host "1. Open: https://github.com/johrstrom/jmeter-prometheus-plugin/releases" -ForegroundColor White
    Write-Host "2. Download: jmeter-prometheus-plugin-0.6.0.jar" -ForegroundColor White
    Write-Host "3. Copy to: $jmeterExtPath" -ForegroundColor White
    Write-Host ""
    Write-Host "Or open this direct link in your browser:" -ForegroundColor Yellow
    Write-Host $pluginUrl -ForegroundColor Cyan
    exit 1
}

