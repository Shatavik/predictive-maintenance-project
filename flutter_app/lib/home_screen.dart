
import 'package:flutter/material.dart';
import 'package:flutter_app/predict_screen.dart';
import 'package:flutter_app/history_screen.dart';
import 'package:flutter_app/model_info_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  static const Color bgColor = Color(0xFF051424);
  static const Color cardColor = Color(0xFF122131);
  static const Color primary = Color(0xFFB0C6FF);
  static const Color secondary = Color(0xFF46EAED);
  static const Color tertiary = Color(0xFFFFB596);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.memory, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Industrial AI',
              style: TextStyle(
                color: secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('prediction_history').listenable(),
        builder: (context, box, _) {
          final totalPredictions = box.length;

          final healthyCount = box.values
              .where((e) => e['status'] == 'Healthy')
              .length;

          final failureCount = box.values
              .where((e) => e['status'] == 'Failure Risk')
              .length;

          final avgProbability = box.isEmpty
              ? 0.0
              : box.values
              .map((e) =>
              (e['failure_probability'] as num).toDouble())
              .reduce((a, b) => a + b) /
              box.length;
          return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: secondary.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 6,
                        backgroundColor: secondary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'SYSTEM STATUS',
                        style: TextStyle(
                          color: secondary,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    failureCount > 0
                        ? 'Overall Status:\nAttention Required'
                        : 'Overall Status:\nHealthy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    totalPredictions == 0
                        ? 'No predictions have been performed yet.'
                        : 'AI-powered predictive maintenance system monitoring machine health.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
              children: [
                _StatCard(
                  'Total Predictions',
                  totalPredictions.toString(),
                  primary,
                ),
                _StatCard(
                  'Healthy Records',
                  healthyCount.toString(),
                  secondary,
                ),
                _StatCard(
                  'Failure Risk',
                  failureCount.toString(),
                  Colors.redAccent,
                ),
                _StatCard(
                  'Avg. Failure Prob',
                  '${avgProbability.toStringAsFixed(1)}%',
                  tertiary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _ActionCard(
              icon: Icons.add_circle,
              title: 'New Prediction',
              subtitle: 'Run ad-hoc diagnostics',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PredictScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.history,
              title: 'View History',
              subtitle: 'Review previous alerts & logs',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HistoryScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _ActionCard(
              icon: Icons.analytics,
              title: 'Model Info',
              subtitle: 'ML Performance & Parameters',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ModelInfoScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0A1A2A),
        selectedItemColor: secondary,
        unselectedItemColor: Colors.white70,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          setState(() => currentIndex = i);

          switch (i) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PredictScreen(),
                ),
              );
              break;

            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistoryScreen(),
                ),
              );
              break;

            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ModelInfoScreen(),
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.precision_manufacturing), label: 'Predict'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Model'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard(this.title, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF122131),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF122131),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF46EAED)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white70),
        ],
      ),
      ),
    );
  }
}
