# custom_exporter.py
import os, time, threading, requests
from prometheus_client import start_http_server, Gauge, Counter

API_KEY = os.getenv("OPENWEATHER_API_KEY")
CITIES  = os.getenv("OW_CITIES", "Astana,Almaty,London").split(",")

INTERVAL = int(os.getenv("OW_INTERVAL_SEC", "20"))
UNITS    = os.getenv("OW_UNITS", "metric")  # metric = °C, m/s; imperial = °F, mph

# --- metrics ---
REQ_OK = Counter("ow_requests_ok_total", "Successful OpenWeather requests", ["city","endpoint"])
REQ_ERR = Counter("ow_requests_error_total", "Errored OpenWeather requests", ["city","endpoint","reason"])

T = Gauge("weather_temperature_c", "Air temperature", ["city"])
FEELS = Gauge("weather_feels_like_c", "Feels like", ["city"])
P = Gauge("weather_pressure_hpa", "Pressure", ["city"])
H = Gauge("weather_humidity_pct", "Humidity", ["city"])
WIND_S = Gauge("weather_wind_speed_ms", "Wind speed", ["city"])
WIND_D = Gauge("weather_wind_deg", "Wind direction deg", ["city"])
CLOUDS = Gauge("weather_clouds_pct", "Cloudiness", ["city"])
VIS = Gauge("weather_visibility_m", "Visibility", ["city"])
RAIN = Gauge("weather_rain_1h_mm", "Rain last 1h mm", ["city"])
SNOW = Gauge("weather_snow_1h_mm", "Snow last 1h mm", ["city"])
SUNRISE = Gauge("weather_sunrise_unix", "Sunrise unix", ["city"])
SUNSET = Gauge("weather_sunset_unix", "Sunset unix", ["city"])

def pull_city(city: str):
    url = "https://api.openweathermap.org/data/2.5/weather"
    p = {"q": city, "appid": API_KEY, "units": UNITS}
    ep = "current"
    try:
        r = requests.get(url, params=p, timeout=10)
        if r.status_code != 200:
            REQ_ERR.labels(city, ep, f"http_{r.status_code}").inc()
            return
        d = r.json()
        REQ_OK.labels(city, ep).inc()

        main = d.get("main", {})
        wind = d.get("wind", {})
        clouds = d.get("clouds", {})
        sys = d.get("sys", {})
        rain = d.get("rain", {})
        snow = d.get("snow", {})

        # set metrics (use get with defaults so exporter never crashes)
        if UNITS == "metric":
            T.labels(city).set(main.get("temp", float("nan")))
            FEELS.labels(city).set(main.get("feels_like", float("nan")))
            WIND_S.labels(city).set(wind.get("speed", float("nan")))
        else:
            # if вдруг imperial — конвертни в метрическую, чтобы имена метрик оставались *_c и *_ms
            T.labels(city).set((main.get("temp", float("nan")) - 32.0) * 5/9)
            FEELS.labels(city).set((main.get("feels_like", float("nan")) - 32.0) * 5/9)
            WIND_S.labels(city).set(wind.get("speed", float("nan")) * 0.44704)

        P.labels(city).set(main.get("pressure", float("nan")))
        H.labels(city).set(main.get("humidity", float("nan")))
        WIND_D.labels(city).set(wind.get("deg", float("nan")))
        CLOUDS.labels(city).set(clouds.get("all", float("nan")))
        VIS.labels(city).set(d.get("visibility", float("nan")))
        RAIN.labels(city).set(rain.get("1h", 0.0))
        SNOW.labels(city).set(snow.get("1h", 0.0))
        SUNRISE.labels(city).set(sys.get("sunrise", float("nan")))
        SUNSET.labels(city).set(sys.get("sunset", float("nan")))

    except requests.exceptions.RequestException as e:
        REQ_ERR.labels(city, ep, type(e).__name__).inc()

def loop():
    while True:
        for c in CITIES:
            pull_city(c.strip())
            time.sleep(1)  # микро-пауза, чтобы не ударять API пакетно
        time.sleep(INTERVAL)

if __name__ == "__main__":
    if not API_KEY:
        raise SystemExit("Set OPENWEATHER_API_KEY env var!")
    start_http_server(int(os.getenv("PORT","8000")))
    threading.Thread(target=loop, daemon=True).start()
    while True:
        time.sleep(3600)
