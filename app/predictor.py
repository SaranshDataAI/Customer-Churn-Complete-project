import joblib
import pandas as pd
import os

# 🔥 dynamic path (works on local + render)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL_PATH = os.path.join(BASE_DIR, "ml", "pipeline.pkl")

model = joblib.load(MODEL_PATH)

def predict(data: dict):
    df = pd.DataFrame([data])
    prediction = model.predict(df)[0]
    probability = model.predict_proba(df)[0][1]

    return prediction, probability