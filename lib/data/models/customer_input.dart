class CustomerInput {
  final String gender;
  final int SeniorCitizen; // Must match Pydantic: SeniorCitizen
  final String Partner; // Must match Pydantic: Partner
  final String Dependents; // Must match Pydantic: Dependents
  final int tenure; // Must match Pydantic: tenure
  final String PhoneService; // Must match Pydantic: PhoneService
  final String MultipleLines; // Must match Pydantic: MultipleLines
  final String InternetService; // Must match Pydantic: InternetService
  final String OnlineSecurity; // Must match Pydantic: OnlineSecurity
  final String OnlineBackup; // Must match Pydantic: OnlineBackup
  final String DeviceProtection; // Must match Pydantic: DeviceProtection
  final String TechSupport; // Must match Pydantic: TechSupport
  final String StreamingTV; // Must match Pydantic: StreamingTV
  final String StreamingMovies; // Must match Pydantic: StreamingMovies
  final String Contract; // Must match Pydantic: Contract
  final String PaperlessBilling; // Must match Pydantic: PaperlessBilling
  final String PaymentMethod; // Must match Pydantic: PaymentMethod
  final double MonthlyCharges; // Must match Pydantic: MonthlyCharges
  final double TotalCharges; // Must match Pydantic: TotalCharges

  CustomerInput({
    required this.gender,
    required this.SeniorCitizen,
    required this.Partner,
    required this.Dependents,
    required this.tenure,
    required this.PhoneService,
    required this.MultipleLines,
    required this.InternetService,
    required this.OnlineSecurity,
    required this.OnlineBackup,
    required this.DeviceProtection,
    required this.TechSupport,
    required this.StreamingTV,
    required this.StreamingMovies,
    required this.Contract,
    required this.PaperlessBilling,
    required this.PaymentMethod,
    required this.MonthlyCharges,
    required this.TotalCharges,
  });

  factory CustomerInput.initial() {
    return CustomerInput(
      gender: 'Male',
      SeniorCitizen: 0,
      Partner: 'No',
      Dependents: 'No',
      tenure: 1,
      PhoneService: 'Yes',
      MultipleLines: 'No',
      InternetService: 'Fiber optic',
      OnlineSecurity: 'No',
      OnlineBackup: 'No',
      DeviceProtection: 'No',
      TechSupport: 'No',
      StreamingTV: 'No',
      StreamingMovies: 'No',
      Contract: 'Month-to-month',
      PaperlessBilling: 'Yes',
      PaymentMethod: 'Electronic check',
      MonthlyCharges: 0.0,
      TotalCharges: 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'SeniorCitizen': SeniorCitizen,
      'Partner': Partner,
      'Dependents': Dependents,
      'tenure': tenure,
      'PhoneService': PhoneService,
      'MultipleLines': MultipleLines,
      'InternetService': InternetService,
      'OnlineSecurity': OnlineSecurity,
      'OnlineBackup': OnlineBackup,
      'DeviceProtection': DeviceProtection,
      'TechSupport': TechSupport,
      'StreamingTV': StreamingTV,
      'StreamingMovies': StreamingMovies,
      'Contract': Contract,
      'PaperlessBilling': PaperlessBilling,
      'PaymentMethod': PaymentMethod,
      'MonthlyCharges': MonthlyCharges,
      'TotalCharges': TotalCharges,
    };
  }

  factory CustomerInput.fromJson(Map<String, dynamic> json) {
    return CustomerInput(
      gender: json['gender'] ?? 'Male',
      SeniorCitizen: json['SeniorCitizen'] ?? 0,
      Partner: json['Partner'] ?? 'No',
      Dependents: json['Dependents'] ?? 'No',
      tenure: json['tenure'] ?? 0,
      PhoneService: json['PhoneService'] ?? 'Yes',
      MultipleLines: json['MultipleLines'] ?? 'No',
      InternetService: json['InternetService'] ?? 'Fiber optic',
      OnlineSecurity: json['OnlineSecurity'] ?? 'No',
      OnlineBackup: json['OnlineBackup'] ?? 'No',
      DeviceProtection: json['DeviceProtection'] ?? 'No',
      TechSupport: json['TechSupport'] ?? 'No',
      StreamingTV: json['StreamingTV'] ?? 'No',
      StreamingMovies: json['StreamingMovies'] ?? 'No',
      Contract: json['Contract'] ?? 'Month-to-month',
      PaperlessBilling: json['PaperlessBilling'] ?? 'Yes',
      PaymentMethod: json['PaymentMethod'] ?? 'Electronic check',
      MonthlyCharges: (json['MonthlyCharges'] ?? 0).toDouble(),
      TotalCharges: (json['TotalCharges'] ?? 0).toDouble(),
    );
  }
}
