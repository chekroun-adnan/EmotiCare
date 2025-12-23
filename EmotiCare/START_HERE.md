# 🚀 Start Here: Local JMeter + Prometheus + Grafana

## ✅ Everything is Ready!

Your setup is configured to use **local JMeter** with Prometheus and Grafana in Docker.

## Quick Start (3 Steps)

### Step 1: Start Monitoring Services

```powershell
docker-compose up -d
```

This starts:
- ✅ Prometheus on http://localhost:9090
- ✅ Grafana on http://localhost:3000

### Step 2: Run Your JMeter Test

**Option A: JMeter GUI (Recommended)**
1. Open JMeter
2. File → Open → `Jmeter\EmotiCare_Full_API_Test.jmx`
3. Click **Run** (green play button)
4. **Keep the test running!**

**Option B: Command Line**
```powershell
cd C:\Users\hp\Desktop\EmotiCareProject\EmotiCare
jmeter -n -t Jmeter\EmotiCare_Full_API_Test.jmx -l results.jtl
```

### Step 3: View Metrics

**Wait 15 seconds after starting test, then:**

1. **Check Prometheus**: http://localhost:9090/targets
   - JMeter should show as **UP** (green) ✅

2. **View in Grafana**: http://localhost:3000
   - Login: admin/admin
   - Import dashboard: `monitoring/grafana/dashboards/jmeter-dashboard.json`

## What's Configured

✅ **Prometheus** - Scrapes from `host.docker.internal:9270`  
✅ **Grafana** - Connected to Prometheus  
✅ **JMeter Plugin** - Installed locally  
✅ **Test Plan** - Has Prometheus listener + health check  
✅ **BaseUrl** - Set to `host.docker.internal` (works from Docker)

## Important Notes

⚠️ **The Prometheus listener only works while a test is running!**
- Keep your test running to see continuous metrics
- If test finishes, metrics disappear

⚠️ **Health Check Request**
- A health check to httpbin.org is added at the start
- This ensures the Prometheus listener starts even if your API requests fail
- You'll see one successful request at the beginning

## Troubleshooting

**Prometheus shows DOWN?**
- Make sure JMeter test is **actively running**
- Check: http://localhost:9270/metrics
- Check Windows Firewall allows port 9270
- Wait 15-20 seconds

**No data in Grafana?**
- Make sure test is running
- Check Prometheus has data: http://localhost:9090/graph
- Try query: `ResponseTime{quantile="0.95"}`

## Access URLs

- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)
- **JMeter Metrics**: http://localhost:9270/metrics

## That's It!

Just run your test and everything should work! 🎉

