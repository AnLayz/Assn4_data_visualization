# 🧠 Assignment #4 — Prometheus & Grafana Monitoring

## 🎯 Goal
This project demonstrates real-time system and data monitoring using **Prometheus** and **Grafana**.  
Three dashboards were built to collect and visualize metrics from:
1. **PostgreSQL Database Exporter**
2. **Windows Node Exporter**
3. **Custom Python Exporter (OpenWeather API)**

---

## 🧩 Project Structure
prometheus-monitoring/
│
├── docker-compose.yml # All containers (Prometheus, Grafana, Exporters)
├── prometheus.yml # Prometheus scrape configuration
│
├── custom_exporter.py # Custom weather exporter (OpenWeather API)
│
├── grafana_dashboards/
│ ├── database_exporter.json # Dashboard #1 (PostgreSQL)
│ ├── windows_exporter.json # Dashboard #2 (System Metrics)
│ └── custom_weather.json # Dashboard #3 (OpenWeather)
│
└── README.md # Documentation (this file)

yaml
Копировать код

---

## ⚙️ How to Run

### 1️⃣ Start all services
```bash
docker-compose up -d
2️⃣ Check service status
Service	URL	Default Port
Prometheus	http://localhost:9090	9090
Grafana	http://localhost:3000	3000
Postgres Exporter	http://localhost:9187/metrics	9187
Windows Exporter	http://host.docker.internal:9182/metrics	9182
Custom Exporter (Weather)	http://localhost:8000/metrics	8000

🧮 Dashboards Overview
🗄️ 1. Database Exporter (PostgreSQL)
Purpose: Monitor database activity and performance.

Metric	Description
pg_up	Database status (1 = up)
pg_database_size_bytes	Database size (bytes / GB)
pg_stat_activity_count	Number of active connections
pg_uptime_seconds	Database uptime
pg_stat_io_read/write	Read and write rate
pg_stat_statements_total	Query execution count
pg_table_total	Total tables per database
pg_user_roles	User count by role
pg_xact_commit_total	Commits per second
pg_xact_rollback_total	Rollbacks per second

💻 2. Windows Exporter (System Monitoring)
Purpose: Visualize system-level metrics from host machine.

Metric	Description
CPU Usage %	100 - idle CPU time
CPU Usage per Core	Load per logical core
Memory Usage %	Used vs available RAM
Disk Free Space (GB)	Available space by volume
Disk Read/Write Speed	I/O throughput
Network In/Out Speed	Bytes sent/received per NIC
Active Services	Count of active Windows services
Commit Pressure %	Memory commit ratio
Alerts	e.g., CPU > 90%

Global Variables:
$instance, $volume, $nic

🌦️ 3. Custom Exporter (OpenWeather API)
Purpose: Collect external API metrics (real-time weather).
Source: OpenWeather API

Metrics collected:

Metric	Unit	Description
weather_temperature_c	°C	Air temperature
weather_feels_like_c	°C	Feels-like temperature
weather_pressure_hpa	hPa	Atmospheric pressure
weather_humidity_pct	%	Humidity
weather_wind_speed_ms	m/s	Wind speed
weather_wind_deg	°	Wind direction
weather_clouds_pct	%	Cloud coverage
weather_visibility_m	m	Visibility
weather_rain_1h_mm	mm	Rain (last 1 hour)
weather_snow_1h_mm	mm	Snow (last 1 hour)

Global variable:
$city — allows dynamic city selection in Grafana.

PromQL examples:

promql
Копировать код
weather_temperature_c{city=~"$city"}
avg_over_time(weather_temperature_c{city=~"$city"}[6h])
stddev_over_time(weather_wind_speed_ms{city=~"$city"}[30m])
clamp_min(weather_rain_1h_mm{city=~"$city"}, 0)
🚨 Alerts Example (Grafana-managed)
High Wind Speed Alert

promql
Копировать код
weather_wind_speed_ms{city=~"$city"} > 12
Summary:
High wind speed detected in {{ $labels.city }} (>12 m/s).
Evaluation: every 1 minute, pending 2 minutes.
Severity: warning

📦 Exporter — Python Code (custom_exporter.py)
python
Копировать код
from prometheus_client import start_http_server, Gauge
import requests, time, os

API_KEY = os.getenv("OPENWEATHER_API_KEY", "YOUR_API_KEY")
CITY = os.getenv("CITY", "Astana")

METRICS = {
    "temp": Gauge("weather_temperature_c", "Air temperature", ["city"]),
    "feels_like": Gauge("weather_feels_like_c", "Feels like", ["city"]),
    "pressure": Gauge("weather_pressure_hpa", "Pressure", ["city"]),
    "humidity": Gauge("weather_humidity_pct", "Humidity", ["city"]),
    "wind_speed": Gauge("weather_wind_speed_ms", "Wind speed", ["city"]),
    "wind_deg": Gauge("weather_wind_deg", "Wind direction deg", ["city"]),
    "clouds": Gauge("weather_clouds_pct", "Cloudiness", ["city"]),
    "visibility": Gauge("weather_visibility_m", "Visibility", ["city"]),
    "rain": Gauge("weather_rain_1h_mm", "Rain last 1h mm", ["city"]),
    "snow": Gauge("weather_snow_1h_mm", "Snow last 1h mm", ["city"]),
}

def get_weather(city):
    url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric"
    data = requests.get(url).json()
    return {
        "temp": data["main"]["temp"],
        "feels_like": data["main"]["feels_like"],
        "pressure": data["main"]["pressure"],
        "humidity": data["main"]["humidity"],
        "wind_speed": data["wind"]["speed"],
        "wind_deg": data["wind"]["deg"],
        "clouds": data["clouds"]["all"],
        "visibility": data.get("visibility", 0),
        "rain": data.get("rain", {}).get("1h", 0),
        "snow": data.get("snow", {}).get("1h", 0),
    }

if __name__ == "__main__":
    start_http_server(8000)
    while True:
        for city in ["Astana", "Almaty", "London"]:
            try:
                w = get_weather(city)
                for k, v in w.items():
                    METRICS[k].labels(city=city).set(v)
                print(f"Updated weather for {city}: {w['temp']}°C")
            except Exception as e:
                print("Error:", e)
        time.sleep(20)
📊 Requirements Checklist
№	Requirement	Status
1	Prometheus & Grafana running and connected	✅
2	All exporters running (PostgreSQL / Windows / Custom)	✅
3	≥10 PromQL queries per dashboard	✅
4	≥60% queries with functions / grouping	✅
5	All queries verified in Prometheus	✅
6	Metrics collected for 1–5 hours	✅
7	≥10 panels, ≥4 visualization types	✅
8	Global dashboard variable	✅ ($instance, $volume, $city)
9	Real-time data refresh works	✅
10	At least one alert (wind speed)	✅
11	Dashboard JSONs + configs in GitHub	✅
12	Live demo: Targets “UP”, Grafana working	✅

📸 Example Targets (Status: UP)
Exporter	Endpoint	Status
PostgreSQL Exporter	http://postgres_exporter:9187/metrics	✅ UP
Windows Exporter	http://host.docker.internal:9182/metrics	✅ UP
Custom Exporter	http://custom_exporter:8000/metrics	✅ UP

👨‍💻 Author
Anuar Totin
IT-2306 | Astana IT University
Course: Data Visualization & Monitoring
Assignment #4 — Prometheus & Grafana
November 2025

✅ All dashboards verified and visualized in Grafana (real-time updates every 20 seconds).

yaml
Копировать код

---

Хочешь, я добавлю к этому README красивый ASCII-баннер в начале (например, `# 🚀 PROMETHEUS MONITORING STACK`) и вставлю инструкции по установке зависимостей Python для custom_exporter?









