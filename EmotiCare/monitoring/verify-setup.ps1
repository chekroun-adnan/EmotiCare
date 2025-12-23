# Quick verification script for JMeter + Prometheus + Grafana setup

Write-Host "`n=== JMeter + Prometheus + Grafana Setup Verification ===" -ForegroundColor Cyan
Write-Host ""

# Check if plugin is installed
$pluginPath = "$env:USERPROFILE\AppData\Roaming\JetBrains\IntelliJIdea2025.2\apache-jmeter-5.6.3\lib\ext\jmeter-prometheus-plugin-0.6.0.jar"
if (Test-Path $pluginPath) {
    Write-Host "✅ Prometheus plugin installed" -ForegroundColor Green
} else {
    Write-Host "❌ Prometheus plugin NOT installed" -ForegroundColor Red
    Write-Host "   Download from: https://github.com/johrstrom/jmeter-prometheus-plugin/releases" -ForegroundColor Yellow
    Write-Host "   Copy to: $pluginPath" -ForegroundColor Yellow
}

Write-Host ""

# Check Docker services
Write-Host "Checking Docker services..." -ForegroundColor Cyan
$prometheus = docker ps --filter "name=prometheus" --format "{{.Names}}" 2>$null
$grafana = docker ps --filter "name=grafana" --format "{{.Names}}" 2>$null

if ($prometheus) {
    Write-Host "✅ Prometheus is running" -ForegroundColor Green
} else {
    Write-Host "❌ Prometheus is NOT running" -ForegroundColor Red
    Write-Host "   Run: docker-compose up -d" -ForegroundColor Yellow
}

if ($grafana) {
    Write-Host "✅ Grafana is running" -ForegroundColor Green
} else {
    Write-Host "❌ Grafana is NOT running" -ForegroundColor Red
    Write-Host "   Run: docker-compose up -d" -ForegroundColor Yellow
}

Write-Host ""

# Check if metrics endpoint is accessible
Write-Host "Checking JMeter metrics endpoint..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:9270/metrics" -TimeoutSec 2 -UseBasicParsing -ErrorAction Stop
    Write-Host "✅ JMeter metrics endpoint is accessible" -ForegroundColor Green
    Write-Host "   Metrics available at: http://localhost:9270/metrics" -ForegroundColor White
} catch {
    Write-Host "⚠️  JMeter metrics endpoint not accessible" -ForegroundColor Yellow
    Write-Host "   This is normal if you haven't run a test yet" -ForegroundColor White
    Write-Host "   Run a JMeter test to start exposing metrics" -ForegroundColor White
}

Write-Host ""
Write-Host "=== Access URLs ===" -ForegroundColor Cyan
Write-Host "Prometheus: http://localhost:9090" -ForegroundColor White
Write-Host "Grafana:    http://localhost:3000 (admin/admin)" -ForegroundColor White
Write-Host "JMeter Metrics: http://localhost:9270/metrics" -ForegroundColor White
Write-Host ""

