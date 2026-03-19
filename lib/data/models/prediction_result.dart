import 'package:flutter/material.dart';
import 'customer_input.dart';

class PredictionResult {
  final int prediction;
  final double probability;
  final DateTime timestamp;
  final CustomerInput input;

  PredictionResult({
    required this.prediction,
    required this.probability,
    required this.timestamp,
    required this.input,
  });

  // Churn risk level
  String get riskLevel {
    if (probability >= 0.7) return 'High';
    if (probability >= 0.4) return 'Medium';
    return 'Low';
  }

  Color get riskColor {
    if (probability >= 0.7) return Colors.red;
    if (probability >= 0.4) return Colors.orange;
    return Colors.green;
  }

  IconData get riskIcon {
    if (probability >= 0.7) return Icons.warning_amber_rounded;
    if (probability >= 0.4) return Icons.info_outline;
    return Icons.check_circle_outline;
  }

  String get riskMessage {
    if (prediction == 1) {
      if (probability >= 0.7) return 'High Risk of Churn';
      if (probability >= 0.4) return 'Moderate Risk of Churn';
      return 'Slight Risk of Churn';
    } else {
      return 'Low Risk of Churn';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'prediction': prediction,
      'probability': probability,
      'timestamp': timestamp.toIso8601String(),
      'input': {
        'gender': input.gender,
        'SeniorCitizen': input.SeniorCitizen, // Fixed: Capital S
        'Partner': input.Partner, // Fixed: Capital P
        'Dependents': input.Dependents, // Fixed: Capital D
        'tenure': input.tenure,
        'PhoneService': input.PhoneService, // Fixed: Capital P, S
        'MultipleLines': input.MultipleLines, // Fixed: Capital M, L
        'InternetService': input.InternetService, // Fixed: Capital I, S
        'OnlineSecurity': input.OnlineSecurity, // Fixed: Capital O, S
        'OnlineBackup': input.OnlineBackup, // Fixed: Capital O, B
        'DeviceProtection': input.DeviceProtection, // Fixed: Capital D, P
        'TechSupport': input.TechSupport, // Fixed: Capital T, S
        'StreamingTV': input.StreamingTV, // Fixed: Capital S, TV
        'StreamingMovies': input.StreamingMovies, // Fixed: Capital S, M
        'Contract': input.Contract, // Fixed: Capital C
        'PaperlessBilling': input.PaperlessBilling, // Fixed: Capital P, B
        'PaymentMethod': input.PaymentMethod, // Fixed: Capital P, M
        'MonthlyCharges': input.MonthlyCharges, // Fixed: Capital M, C
        'TotalCharges': input.TotalCharges, // Fixed: Capital T, C
      },
    };
  }

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      prediction: json['prediction'] ?? 0,
      probability: (json['probability'] ?? 0.0).toDouble(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      input: CustomerInput.fromJson(json['input'] ?? {}),
    );
  }
}
