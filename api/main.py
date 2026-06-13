from fastapi import FastAPI
from pydantic import BaseModel
import joblib
import pandas as pd
from datetime import datetime

app = FastAPI()

# Load model
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

model_path = BASE_DIR / "models" / "original_model.pkl"

model = joblib.load(model_path)


class MachineData(BaseModel):
    Type: int
    Air_temperature: float
    Process_temperature: float
    Rotational_speed: float
    Torque: float
    Tool_wear: float


@app.get("/", tags=["Health Check"])
def home():
    return {"message": "Predictive Maintenance API Running"}


@app.post("/predict", tags=["Prediction"])
def predict(data: MachineData):

    features = pd.DataFrame([{
        "Type": data.Type,
        "Air temperature [K]": data.Air_temperature,
        "Process temperature [K]": data.Process_temperature,
        "Rotational speed [rpm]": data.Rotational_speed,
        "Torque [Nm]": data.Torque,
        "Tool wear [min]": data.Tool_wear
    }])

    prediction = model.predict(features)[0]
    probability = float(model.predict_proba(features)[0][1])

    status = "Failure Risk" if int(prediction) == 1 else "Healthy"

    return {
        "status": status,
        "prediction": int(prediction),
        "failure_probability": float(round(probability * 100, 2)),
        "maintenance_required": bool(prediction == 1),
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    }

@app.get("/model-info")
def model_info():
    return {
        "model": "Random Forest",
        "dataset": "AI4I Predictive Maintenance Dataset",
        "features": 6,
        "target": "Machine Failure"
    }