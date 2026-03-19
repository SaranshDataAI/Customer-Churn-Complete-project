// ignore_for_file: unused_import

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:churn_app/data/models/customer_input.dart';
import 'package:churn_app/data/models/prediction_result.dart';
import 'package:churn_app/core/constants/api_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PredictionRepository {
  static const String _historyBox = 'predictions_history';
  static bool _isHiveInitialized = false;

  PredictionRepository() {
    // Don't call async methods in constructor
  }

  // Initialize Hive - call this before using the repository
  static Future<void> ensureInitialized() async {
    if (!_isHiveInitialized) {
      await Hive.initFlutter();
      await Hive.openBox(_historyBox);
      _isHiveInitialized = true;
    }
  }

  // Get the Hive box (ensures it's open)
  Future<Box> _getHistoryBox() async {
    await ensureInitialized();
    return await Hive.openBox(_historyBox);
  }

  // Actual API call to your live backend
  Future<PredictionResult> predict(CustomerInput input) async {
    try {
      print(
          'Sending request to: ${ApiConstants.baseUrl}${ApiConstants.predictEndpoint}');
      print('Request body: ${jsonEncode(input.toJson())}');

      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.predictEndpoint}'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(input.toJson()),
          )
          .timeout(ApiConstants.timeout);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final result = PredictionResult(
          prediction: data['prediction'] ?? 0,
          probability: (data['probability'] ?? 0.0).toDouble(),
          timestamp: DateTime.now(),
          input: input,
        );

        // REMOVED: Auto-save to history - now only saves when explicitly called
        // await _saveToHistory(result);

        return result;
      } else {
        throw Exception(
            'Server error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Prediction error: $e');
      throw Exception('Failed to get prediction: $e');
    }
  }

  // Get prediction history from local storage
  Future<List<PredictionResult>> getPredictionHistory() async {
    try {
      final box = await _getHistoryBox();
      final List<PredictionResult> predictions = [];

      for (var i = 0; i < box.length; i++) {
        try {
          final item = box.getAt(i);
          if (item != null) {
            // Convert to Map<String, dynamic> safely
            final Map<String, dynamic> castedItem =
                Map<String, dynamic>.from(item as Map);
            predictions.add(PredictionResult.fromJson(castedItem));
          }
        } catch (e) {
          print('Error parsing prediction at index $i: $e');
        }
      }

      // Sort by timestamp descending (newest first)
      predictions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return predictions;
    } catch (e) {
      print('Error loading history: $e');
      return [];
    }
  }

  // Save prediction to local storage
  Future<void> _saveToHistory(PredictionResult prediction) async {
    try {
      final box = await _getHistoryBox();
      await box.add(prediction.toJson());
      print('Saved prediction to history');
    } catch (e) {
      print('Error saving to history: $e');
    }
  }

  // Public method to save prediction (called from UI)
  Future<void> savePrediction(PredictionResult result) async {
    await _saveToHistory(result);
  }

  // Clear history (optional)
  Future<void> clearHistory() async {
    try {
      final box = await _getHistoryBox();
      await box.clear();
    } catch (e) {
      print('Error clearing history: $e');
    }
  }
}
