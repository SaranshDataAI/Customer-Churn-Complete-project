# 🚀 Customer Churn Prediction System (Production-Ready ML App)

> An end-to-end **machine learning product** that predicts customer churn, provides actionable insights, and stores real-time predictions using a full-stack architecture.

---

## 🌐 Live Demo

* 🔗 **Live App (Frontend)**: https://curious-duckanoo-2e6d7d.netlify.app
* 🔗 **API (Backend)**: https://chrun-api.onrender.com

---

## 🎯 Why This Project?

Customer churn is a critical business problem. This system goes beyond prediction and delivers:

* 📊 **Risk scoring**
* 🧠 **Explainable insights**
* 🎯 **Actionable recommendations**

👉 Built as a **real-world ML product**, not just a model.

---

## 🧠 Key Features

* 🔮 Real-time churn prediction via deployed API
* 📊 Probability-based risk classification (Low / Medium / High)
* 🧠 Key risk factors identification
* 🎯 Recommendation engine for customer retention
* 🕘 Prediction history stored in PostgreSQL (Neon)
* 🌐 Fully deployed system (Frontend + Backend + Database)
* 🔄 Retraining pipeline using production data

---

## 🏗️ System Architecture

```text
Flutter (Web + Mobile)
        ↓
     FastAPI
        ↓
  ML Pipeline (Sklearn)
        ↓
PostgreSQL (Neon Cloud)
```

---

## 📸 App Screenshots

### 📊 Prediction Result


<img width="1087" height="574" alt="Screenshot 2026-03-19 100429" src="https://github.com/user-attachments/assets/89391b7c-8873-4084-93a2-623f52b46d02" />

<img width="1916" height="912" alt="Screenshot 2026-03-19 100203" src="https://github.com/user-attachments/assets/d93450e3-cd28-4eac-b428-70e40d65b161" />

<img width="1914" height="910" alt="Screenshot 2026-03-19 100219" src="https://github.com/user-attachments/assets/2a380309-7b65-4fe5-b803-f0dec14b4428" />

### 🧠 Insights & Recommendations


<img width="1913" height="906" alt="Screenshot 2026-03-19 100345" src="https://github.com/user-attachments/assets/c8ad0e93-2662-4ab1-9a13-878ac1fdfbb9" />

### 🕘 Prediction History



---<img width="1915" height="709" alt="Screenshot 2026-03-19 100401" src="https://github.com/user-attachments/assets/f2305f52-e531-435d-9a2a-4b85b65b7a0e" />


## 🧪 API Example

### Request

```json
{
  "gender": "Male",
  "tenure": 5,
  "MonthlyCharges": 95.0,
  "TotalCharges": 500.0
}
```

### Response

```json
{
  "prediction": 1,
  "probability": 0.64
}
```

---

## ⚙️ Tech Stack

* **Frontend**: Flutter (Web + Mobile)
* **Backend**: FastAPI
* **ML**: Scikit-learn Pipeline (Logistic Regression)
* **Database**: PostgreSQL (Neon)
* **Deployment**: Render + Netlify

---

## 🔄 ML Pipeline

* Data preprocessing + encoding inside pipeline
* Model training using Logistic Regression
* Pipeline saved as `pipeline.pkl`
* Used directly in FastAPI for inference

---

## 📈 Retraining Workflow

* Collects real prediction data from database
* Retrains model periodically
* Updates pipeline for improved accuracy

---

## 💡 What Makes This Different?

✔️ Not just a model — a **complete ML system**
✔️ Real-time API + database integration
✔️ Cross-platform frontend (Flutter)
✔️ Production deployment (Render + Netlify)
✔️ Built with scalability in mind

---

## 📌 Future Improvements (v2)

* 🔐 Authentication (multi-user system)
* 📊 Advanced analytics dashboard
* 🧠 Explainable AI (feature importance)
* 📈 Model monitoring & logging

---

## 👨‍💻 Author

**Saransh Sharma**

---

⭐ If you found this project interesting, feel free to star the repo!
