import uvicorn
from fastapi import FastAPI, HTTPException
import requests
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

app = FastAPI()

API_KEY = os.getenv("OPENWEATHERMAP_API_KEY")
BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

@app.get("/weather/{city}")
async def get_weather(city: str):
    params = {
        "q": city,
        "appid": API_KEY,
        "units": "metric",  # Fetch temperature in Celsius
    }
    response = requests.get(BASE_URL, params=params)
    data = response.json()

    if response.status_code != 200:
        raise HTTPException(
            status_code=response.status_code,
            detail=data.get("message", "Error fetching weather data"),
        )

    weather = {
        "city": data["name"],
        "temperature": data["main"]["temp"],
        "description": data["weather"][0]["description"],
        "humidity": data["main"]["humidity"],
        "wind_speed": data["wind"]["speed"],
        "sunrise": data.get("sys", {}).get("sunrise"),
        "sunset": data.get("sys", {}).get("sunset"),
        "feels_like": data["main"]["feels_like"],
    }

    return weather

# Mangum adapter to handle Lambda events
# handler = Magnum(app)

if __name__ == "__main__":
    config = uvicorn.Config("main:app", host="0.0.0.0", port=8000, log_level="info", reload=True)
    server = uvicorn.Server(config)
    server.run()
