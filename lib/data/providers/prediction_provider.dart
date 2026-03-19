import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:churn_app/data/models/customer_input.dart';
import 'package:churn_app/data/models/prediction_result.dart';
import 'package:churn_app/data/repositories/prediction_repository.dart';

// Repository provider - use a future provider since initialization is async
final predictionRepositoryProvider =
    FutureProvider<PredictionRepository>((ref) async {
  await PredictionRepository.ensureInitialized();
  return PredictionRepository();
});

// Current input provider
final currentInputProvider = StateProvider<CustomerInput>((ref) {
  return CustomerInput.initial();
});

// Predictions list provider
final predictionsProvider = FutureProvider<List<PredictionResult>>((ref) async {
  final repository = await ref.watch(predictionRepositoryProvider.future);
  return await repository.getPredictionHistory();
});

// Selected prediction provider for results screen
final selectedPredictionProvider = StateProvider<PredictionResult?>((ref) {
  return null;
});

// Loading state provider
final isPredictingProvider = StateProvider<bool>((ref) {
  return false;
});
