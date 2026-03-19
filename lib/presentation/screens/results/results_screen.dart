import 'package:churn_app/presentation/screens/input_form/input_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:churn_app/data/models/prediction_result.dart';
import 'package:churn_app/core/utils/custom_painters.dart';
import 'package:churn_app/core/utils/date_formatter.dart';

class ResultsScreen extends ConsumerWidget {
  final PredictionResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              result.riskColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Enhanced Animated Header
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              stretch: true,
              backgroundColor: result.riskColor,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Stack(
                  children: [
                    // Animated gradient background
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            result.riskColor,
                            result.riskColor.withOpacity(0.7),
                            Colors.purple.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),

                    // Animated particles
                    Positioned.fill(
                      child: CustomPaint(
                        painter: ParticlePainter(
                          color: Colors.white.withOpacity(0.15),
                          particleCount: 20,
                        ),
                      ),
                    ),

                    // Decorative circles
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -30,
                      left: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),

                    // Main content with enhanced animation
                    Center(
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.elasticOut,
                        builder: (context, double value, child) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Animated icon with scale and rotation
                              Transform.scale(
                                scale: value,
                                child: Transform.rotate(
                                  angle: value * 0.2,
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              result.riskColor.withOpacity(0.3),
                                          blurRadius: 20 * value,
                                          spreadRadius: 5 * value,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      result.riskIcon,
                                      size: 60,
                                      color: result.riskColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Animated text with fade and slide
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: 1),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeOut,
                                builder: (context, double val, child) {
                                  return Opacity(
                                    opacity: val,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - val)),
                                      child: Text(
                                        result.riskMessage,
                                        style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Results Details with staggered animations
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Probability Gauge with enhanced design
                  _buildAnimatedCard(
                    child: _buildProbabilityGauge(context),
                    delay: 0,
                  ),
                  const SizedBox(height: 20),

                  // Risk Factors
                  _buildAnimatedCard(
                    child: _buildRiskFactors(context),
                    delay: 100,
                  ),
                  const SizedBox(height: 20),

                  // Recommendations with gradient background
                  _buildAnimatedCard(
                    child: _buildRecommendations(),
                    delay: 200,
                  ),
                  const SizedBox(height: 20),

                  // Customer Summary
                  _buildAnimatedCard(
                    child: _buildCustomerSummary(context),
                    delay: 300,
                  ),
                  const SizedBox(height: 20),

                  // Enhanced Action Buttons
                  _buildAnimatedCard(
                    child: _buildActionButtons(context),
                    delay: 400,
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCard({required Widget child, required int delay}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildProbabilityGauge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: result.riskColor.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: result.riskColor.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Churn Probability',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 220,
                width: 220,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: result.probability),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeOutCubic,
                  builder: (context, double value, child) {
                    return CustomPaint(
                      painter: GaugePainter(
                        progress: value,
                        color: result.riskColor,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    );
                  },
                ),
              ),
              Column(
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: result.probability),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeOutCubic,
                    builder: (context, double value, child) {
                      return Text(
                        '${(value * 100).toStringAsFixed(1)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: result.riskColor,
                          shadows: [
                            Shadow(
                              color: result.riskColor.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: result.riskColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      result.riskLevel,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: result.riskColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskFactors(BuildContext context) {
    final factors = _analyzeRiskFactors();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: result.riskColor),
              const SizedBox(width: 10),
              Text(
                'Key Risk Factors',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (factors.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 50,
                      color: Colors.green.shade400,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No significant risk factors identified',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...factors.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: Duration(milliseconds: 500 + (entry.key * 100)),
                    curve: Curves.easeOut,
                    builder: (context, double value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(20 * (1 - value), 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: entry.value['impact'] == 'High'
                                      ? Colors.red.shade50
                                      : Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  entry.value['impact'] == 'High'
                                      ? Icons.warning
                                      : Icons.info_outline,
                                  color: entry.value['impact'] == 'High'
                                      ? Colors.red
                                      : Colors.orange,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.value['name'] ?? '',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      entry.value['description'] ?? '',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey.shade600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )),
        ],
      ),
    );
  }

  List<Map<String, String>> _analyzeRiskFactors() {
    final factors = <Map<String, String>>[];

    // Analyze contract type
    if (result.input.Contract == 'Month-to-month') {
      factors.add({
        'name': 'Month-to-month Contract',
        'description':
            'Customers with monthly contracts are more likely to churn',
        'impact': 'High',
      });
    }

    // Analyze tenure
    if (result.input.tenure < 6) {
      factors.add({
        'name': 'Short Tenure',
        'description':
            'New customers (less than 6 months) have higher churn risk',
        'impact': 'High',
      });
    } else if (result.input.tenure < 12) {
      factors.add({
        'name': 'Medium Tenure',
        'description': 'Customers with 6-12 months tenure show moderate risk',
        'impact': 'Medium',
      });
    }

    // Analyze payment method
    if (result.input.PaymentMethod == 'Electronic check') {
      factors.add({
        'name': 'Electronic Check Payment',
        'description': 'Electronic check users have higher churn rates',
        'impact': 'High',
      });
    }

    // Analyze internet service
    if (result.input.InternetService == 'Fiber optic') {
      factors.add({
        'name': 'Fiber Optic Service',
        'description': 'Fiber optic users may churn due to price sensitivity',
        'impact': 'Medium',
      });
    }

    // Analyze lack of security services
    if (result.input.OnlineSecurity == 'No') {
      factors.add({
        'name': 'No Online Security',
        'description':
            'Customers without security services are more likely to leave',
        'impact': 'Medium',
      });
    }

    return factors;
  }

  Widget _buildRecommendations() {
    final recommendations = _getRecommendations();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lightbulb, color: Colors.amber.shade800),
              ),
              const SizedBox(width: 12),
              Text(
                'Recommendations',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...recommendations.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 400 + (entry.key * 100)),
                  curve: Curves.easeOut,
                  builder: (context, double value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.green.shade700,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }

  List<String> _getRecommendations() {
    final recommendations = <String>[];

    if (result.prediction == 1) {
      if (result.input.Contract == 'Month-to-month') {
        recommendations
            .add('Offer a long-term contract discount to reduce churn risk');
      }

      if (result.input.tenure < 6) {
        recommendations.add('Send personalized onboarding emails and tips');
      }

      if (result.input.OnlineSecurity == 'No') {
        recommendations
            .add('Promote online security features with a free trial');
      }

      if (result.input.PaymentMethod == 'Electronic check') {
        recommendations.add('Offer incentive to switch to automatic payments');
      }

      recommendations
          .add('Schedule a retention call with customer success team');
      recommendations
          .add('Consider offering a one-time discount or loyalty reward');
    } else {
      recommendations
          .add('Continue providing excellent service to maintain satisfaction');
      recommendations
          .add('Consider upselling additional services for increased loyalty');
      recommendations.add('Send satisfaction survey to gather feedback');
    }

    return recommendations;
  }

  Widget _buildCustomerSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: Colors.blue.shade400),
              const SizedBox(width: 10),
              Text(
                'Customer Summary',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            'Tenure',
            '${result.input.tenure} months',
            Icons.timer_outlined,
          ),
          _buildInfoRow(
            'Contract',
            result.input.Contract,
            Icons.description_outlined,
          ),
          _buildInfoRow(
            'Internet Service',
            result.input.InternetService,
            Icons.wifi_outlined,
          ),
          _buildInfoRow(
            'Monthly Charges',
            '\$${result.input.MonthlyCharges.toStringAsFixed(2)}',
            Icons.attach_money_outlined,
          ),
          _buildInfoRow(
            'Total Charges',
            '\$${result.input.TotalCharges.toStringAsFixed(2)}',
            Icons.account_balance_wallet_outlined,
          ),
          _buildInfoRow(
            'Payment Method',
            result.input.PaymentMethod,
            Icons.payment_outlined,
          ),
          const Divider(height: 30),
          _buildInfoRow(
            'Prediction Date',
            DateFormatter.formatDateTime(result.timestamp),
            Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // Go back to input form (previous screen)
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'New Prediction',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // Navigate to home (InputFormScreen) and clear all previous routes
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const InputFormScreen(),
                ),
                (route) => false, // This removes all previous routes
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 8,
              shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Home',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Enhanced GaugePainter with better visuals
class GaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  GaugePainter({
    required this.progress,
    required this.color,
    this.backgroundColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 20.0;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Draw progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -90 * (3.14159 / 180),
      360 * progress * (3.14159 / 180),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
