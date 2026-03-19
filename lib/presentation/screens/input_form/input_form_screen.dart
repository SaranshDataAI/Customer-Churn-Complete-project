// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:churn_app/data/models/customer_input.dart';
import 'package:churn_app/data/providers/prediction_provider.dart';
import 'package:churn_app/presentation/screens/results/results_screen.dart';

class InputFormScreen extends ConsumerStatefulWidget {
  const InputFormScreen({super.key});

  @override
  ConsumerState<InputFormScreen> createState() => _InputFormScreenState();
}

class _InputFormScreenState extends ConsumerState<InputFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  int _currentStep = 0;

  final List<FormSection> _sections = const [
    FormSection(
      title: 'Personal Information',
      icon: Icons.person_outline,
      fields: ['Gender', 'Senior Citizen', 'Partner', 'Dependents'],
    ),
    FormSection(
      title: 'Account Details',
      icon: Icons.account_balance_wallet,
      fields: ['Tenure', 'Contract', 'Paperless Billing', 'Payment Method'],
    ),
    FormSection(
      title: 'Services',
      icon: Icons.settings,
      fields: ['Phone Service', 'Internet Service', 'Multiple Lines'],
    ),
    FormSection(
      title: 'Security & Support',
      icon: Icons.security,
      fields: [
        'Online Security',
        'Online Backup',
        'Device Protection',
        'Tech Support'
      ],
    ),
    FormSection(
      title: 'Streaming Services',
      icon: Icons.live_tv,
      fields: ['Streaming TV', 'Streaming Movies'],
    ),
    FormSection(
      title: 'Billing',
      icon: Icons.receipt,
      fields: ['Monthly Charges', 'Total Charges'],
    ),
  ];

  // Initial form values
  final Map<String, dynamic> _initialValues = {
    'gender': 'Male',
    'seniorCitizen': false,
    'partner': 'No',
    'dependents': 'No',
    'tenure': 12.0,
    'phoneService': 'Yes',
    'multipleLines': 'No',
    'internetService': 'Fiber optic',
    'onlineSecurity': 'No',
    'onlineBackup': 'No',
    'deviceProtection': 'No',
    'techSupport': 'No',
    'streamingTV': 'No',
    'streamingMovies': 'No',
    'contract': 'Month-to-month',
    'paperlessBilling': 'Yes',
    'paymentMethod': 'Electronic check',
    'monthlyCharges': '', // Start empty
    'totalCharges': '', // Start empty
  };

  @override
  Widget build(BuildContext context) {
    final isPredicting = ref.watch(isPredictingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Churn Predictor',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),

            // Form Content
            Expanded(
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                initialValue: _initialValues,
                child: _buildCurrentSection(),
              ),
            ),

            // Navigation Buttons
            _buildNavigationButtons(isPredicting),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Section ${_currentStep + 1} of ${_sections.length}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              Text(
                '${((_currentStep + 1) / _sections.length * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentStep + 1) / _sections.length,
            backgroundColor: Colors.grey.shade200,
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildSectionContent(_sections[_currentStep]),
      ),
    );
  }

  Widget _buildSectionContent(FormSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  section.icon,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                section.title,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Form Fields
        ...section.fields.map((field) => _buildFormField(field)),
      ],
    );
  }

  Widget _buildFormField(String fieldName) {
    switch (fieldName) {
      case 'Gender':
        return _buildGenderField();
      case 'Senior Citizen':
        return _buildSeniorCitizenField();
      case 'Tenure':
        return _buildTenureField();
      case 'Monthly Charges':
      case 'Total Charges':
        return _buildNumericField(fieldName);
      case 'Internet Service':
        return _buildInternetServiceField();
      case 'Contract':
        return _buildContractField();
      case 'Payment Method':
        return _buildPaymentMethodField();
      default:
        return _buildDropdownField(fieldName);
    }
  }

  Widget _buildGenderField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderRadioGroup<String>(
            name: 'gender',
            orientation: OptionsOrientation.horizontal,
            options: const [
              FormBuilderFieldOption(value: 'Male', child: Text('Male')),
              FormBuilderFieldOption(value: 'Female', child: Text('Female')),
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildSeniorCitizenField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Senior Citizen',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderCheckbox(
            name: 'seniorCitizen',
            title: const Text('Is the customer a senior citizen?'),
            initialValue: false,
            activeColor: Theme.of(context).primaryColor,
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildTenureField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tenure (months)',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderSlider(
            name: 'tenure',
            min: 0,
            max: 72,
            divisions: 72,
            initialValue: 12,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey.shade300,
            onChanged: (value) => setState(() {}),
          ),
          // Display current value
          Builder(
            builder: (context) {
              final value =
                  _formKey.currentState?.fields['tenure']?.value ?? 12;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Selected: ${value.toStringAsFixed(0)} months',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInternetServiceField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Internet Service',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderRadioGroup<String>(
            name: 'internetService',
            orientation: OptionsOrientation.wrap,
            options: const [
              FormBuilderFieldOption(value: 'DSL', child: Text('DSL')),
              FormBuilderFieldOption(
                  value: 'Fiber optic', child: Text('Fiber optic')),
              FormBuilderFieldOption(value: 'No', child: Text('No')),
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildContractField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contract',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderRadioGroup<String>(
            name: 'contract',
            orientation: OptionsOrientation.vertical,
            options: const [
              FormBuilderFieldOption(
                  value: 'Month-to-month', child: Text('Month-to-month')),
              FormBuilderFieldOption(
                  value: 'One year', child: Text('One year')),
              FormBuilderFieldOption(
                  value: 'Two year', child: Text('Two year')),
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderDropdown<String>(
            name: 'paymentMethod',
            initialValue: 'Electronic check',
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: const [
              DropdownMenuItem(
                  value: 'Electronic check', child: Text('Electronic check')),
              DropdownMenuItem(
                  value: 'Mailed check', child: Text('Mailed check')),
              DropdownMenuItem(
                  value: 'Bank transfer (automatic)',
                  child: Text('Bank transfer (automatic)')),
              DropdownMenuItem(
                  value: 'Credit card (automatic)',
                  child: Text('Credit card (automatic)')),
            ],
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String fieldName) {
    final fieldKey = fieldName.toLowerCase().replaceAll(' ', '');
    final options = _getOptionsForField(fieldName);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderRadioGroup<String>(
            name: fieldKey,
            orientation: OptionsOrientation.horizontal,
            options: options
                .map((option) =>
                    FormBuilderFieldOption(value: option, child: Text(option)))
                .toList(),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericField(String fieldName) {
    final fieldKey = fieldName.toLowerCase().replaceAll(' ', '');

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldName,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: fieldKey,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixText: '\$ ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintText: '0.00',
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  List<String> _getOptionsForField(String fieldName) {
    switch (fieldName) {
      case 'Partner':
      case 'Dependents':
      case 'Phone Service':
      case 'Multiple Lines':
      case 'Online Security':
      case 'Online Backup':
      case 'Device Protection':
      case 'Tech Support':
      case 'Streaming TV':
      case 'Streaming Movies':
      case 'Paperless Billing':
        return ['Yes', 'No'];
      default:
        return ['Yes', 'No'];
    }
  }

  Widget _buildNavigationButtons(bool isPredicting) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: ElevatedButton(
                onPressed: isPredicting ? null : _previousSection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.grey.shade800,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Previous',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: isPredicting ? null : _nextSection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isPredicting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _currentStep == _sections.length - 1 ? 'Predict' : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _previousSection() {
    setState(() {
      _currentStep--;
    });
  }

  void _nextSection() async {
    if (_currentStep < _sections.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // First validate the form
      if (_formKey.currentState?.saveAndValidate() ?? false) {
        final formData = _formKey.currentState!.value;

        // Debug print to see what's in the form
        print('RAW form data:');
        formData.forEach((key, value) {
          print('  $key: $value (${value.runtimeType})');
        });

        // Parse numeric values properly
        double monthlyCharges = 0.0;
        double totalCharges = 0.0;

        // Handle monthlycharges
        if (formData['monthlycharges'] != null) {
          final monthlyStr = formData['monthlycharges'].toString().trim();
          if (monthlyStr.isNotEmpty) {
            monthlyCharges = double.tryParse(monthlyStr) ?? 0.0;
          }
        }

        // Handle totalcharges
        if (formData['totalcharges'] != null) {
          final totalStr = formData['totalcharges'].toString().trim();
          if (totalStr.isNotEmpty) {
            totalCharges = double.tryParse(totalStr) ?? 0.0;
          }
        }

        print('Monthly Charges: $monthlyCharges, Total Charges: $totalCharges');

        // Handle seniorCitizen properly (checkbox returns bool)
        final seniorCitizen = formData['seniorCitizen'] == true ? 1 : 0;

        // Handle tenure (slider returns double)
        int tenure = 12; // default
        if (formData['tenure'] != null) {
          if (formData['tenure'] is double) {
            tenure = (formData['tenure'] as double).toInt();
          } else {
            tenure = int.tryParse(formData['tenure'].toString()) ?? 12;
          }
        }

        // Map form field keys to match CustomerInput
        String gender = formData['gender'] ?? 'Male';
        String partner = formData['partner'] ?? 'No';
        String dependents = formData['dependents'] ?? 'No';
        String phoneService = formData['phoneservice'] ?? 'Yes';
        String multipleLines = formData['multiplelines'] ?? 'No';
        String internetService = formData['internetService'] ?? 'Fiber optic';
        String onlineSecurity = formData['onlinesecurity'] ?? 'No';
        String onlineBackup = formData['onlinebackup'] ?? 'No';
        String deviceProtection = formData['deviceprotection'] ?? 'No';
        String techSupport = formData['techsupport'] ?? 'No';
        String streamingTV = formData['streamingtv'] ?? 'No';
        String streamingMovies = formData['streamingmovies'] ?? 'No';
        String contract = formData['contract'] ?? 'Month-to-month';
        String paperlessBilling = formData['paperlessbilling'] ?? 'Yes';
        String paymentMethod = formData['paymentMethod'] ?? 'Electronic check';

        // Create customer input from form data
        final input = CustomerInput(
          gender: gender,
          SeniorCitizen: seniorCitizen,
          Partner: partner,
          Dependents: dependents,
          tenure: tenure,
          PhoneService: phoneService,
          MultipleLines: multipleLines,
          InternetService: internetService,
          OnlineSecurity: onlineSecurity,
          OnlineBackup: onlineBackup,
          DeviceProtection: deviceProtection,
          TechSupport: techSupport,
          StreamingTV: streamingTV,
          StreamingMovies: streamingMovies,
          Contract: contract,
          PaperlessBilling: paperlessBilling,
          PaymentMethod: paymentMethod,
          MonthlyCharges: monthlyCharges,
          TotalCharges: totalCharges,
        );

        print('Customer Input: ${input.toJson()}');

        // Set loading state
        ref.read(isPredictingProvider.notifier).state = true;

        try {
          // Get repository
          final repositoryAsync =
              await ref.read(predictionRepositoryProvider.future);

          // Get prediction
          final result = await repositoryAsync.predict(input);

          // Save to history (ONLY ONCE)
          await repositoryAsync.savePrediction(result);

          // Invalidate the provider to refresh the history list
          ref.invalidate(predictionsProvider);

          // Navigate to results screen
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultsScreen(result: result),
              ),
            );
          }
        } catch (e) {
          print('Error: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Prediction failed: ${e.toString().replaceAll('Exception: ', '')}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    _nextSection();
                  },
                ),
              ),
            );
          }
        } finally {
          ref.read(isPredictingProvider.notifier).state = false;
        }
      } else {
        // Show which fields are invalid
        final errors = _formKey.currentState?.errors;
        print('Form validation errors: $errors');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all required fields correctly'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}

class FormSection {
  final String title;
  final IconData icon;
  final List<String> fields;

  const FormSection({
    required this.title,
    required this.icon,
    required this.fields,
  });
}
