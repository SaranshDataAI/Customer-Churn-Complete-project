from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from app import models, schemas, database
from app.predictor import predict
from fastapi.middleware.cors import CORSMiddleware
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# Dependency
def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.post("/predict")
def predict_churn(data: schemas.CustomerInput, db: Session = Depends(get_db)):

    # 1. Save customer data
    customer = models.Customer(**data.dict())
    db.add(customer)
    db.commit()
    db.refresh(customer)

    # 2. Predict
    pred, prob = predict(data.dict())

    # 3. Save prediction
    prediction = models.Prediction(
    customer_id=customer.id,
    churn_prediction=int(pred),      # 🔥 FIX
    probability=float(prob)          # 🔥 FIX
)
    db.add(prediction)
    db.commit()

    # 4. Return result
    return {
    "prediction": int(pred),
    "probability": float(prob)
}