import pandas as pd
from sqlalchemy import create_engine
import joblib

from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.linear_model import LogisticRegression

import os
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

# Connect to DB
engine = create_engine(DATABASE_URL)

# 🔥 STEP 1: Load data from DB
query = """
SELECT c.*, p.churn_prediction
FROM customers c
JOIN predictions p
ON c.id = p.customer_id
"""

df = pd.read_sql(query, engine)

# Rename target
df = df.rename(columns={"churn_prediction": "Churn"})

# Drop ID
df = df.drop(columns=["id"])

# 🔥 STEP 2: Split features/target
X = df.drop(columns=["Churn"])
y = df["Churn"]

# Identify columns
categorical_cols = X.select_dtypes(include=["object"]).columns.tolist()
numerical_cols = X.select_dtypes(exclude=["object"]).columns.tolist()

# Pipelines
num_pipeline = Pipeline([
    ("scaler", StandardScaler())
])

cat_pipeline = Pipeline([
    ("encoder", OneHotEncoder(handle_unknown='ignore'))
])

preprocessor = ColumnTransformer([
    ("num", num_pipeline, numerical_cols),
    ("cat", cat_pipeline, categorical_cols)
])

# Model
pipeline = Pipeline([
    ("preprocessor", preprocessor),
    ("model", LogisticRegression(max_iter=1000, class_weight='balanced'))
])

# Train
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

pipeline.fit(X_train, y_train)

# 🔥 STEP 3: Save updated model
joblib.dump(pipeline, "ml/pipeline.pkl")

print("✅ Model retrained and updated!")