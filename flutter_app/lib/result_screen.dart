
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String status;
  final int prediction;
  final double failureProbability;
  final bool maintenanceRequired;
  final String timestamp;

  const ResultScreen({
    super.key,
    required this.status,
    required this.prediction,
    required this.failureProbability,
    required this.maintenanceRequired,
    required this.timestamp,
  });

  static const Color bgColor = Color(0xFF051424);
  static const Color cardColor = Color(0xFF122131);
  static const Color secondary = Color(0xFF46EAED);

  @override
  Widget build(BuildContext context) {
    final isHealthy = status.toLowerCase() == "healthy";

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text("Prediction Result"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isHealthy ? secondary : Colors.redAccent,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        (isHealthy ? secondary : Colors.redAccent)
                            .withValues(alpha: 0.15),
                    child: Icon(
                      isHealthy
                          ? Icons.verified_user
                          : Icons.warning_amber_rounded,
                      size: 50,
                      color: isHealthy
                          ? secondary
                          : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: isHealthy
                          ? secondary
                          : Colors.redAccent,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Asset Diagnostics Complete",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            strokeWidth: 10,
                            value: failureProbability / 100,
                            color: isHealthy
                                ? secondary
                                : Colors.redAccent,
                            backgroundColor: Colors.white12,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${failureProbability.toStringAsFixed(1)}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Failure Prob.",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _infoCard(
                  "Status",
                  status,
                  isHealthy ? secondary : Colors.redAccent,
                ),
                _infoCard(
                  "Prediction",
                  prediction == 1 ? "Failure" : "Healthy",
                  prediction == 1 ? Colors.redAccent : secondary,
                ),
                _infoCard(
                  "Probability",
                  "${failureProbability.toStringAsFixed(1)}%",
                  Colors.white,
                ),
                _infoCard(
                  "Maintenance",
                  maintenanceRequired ? "Required" : "Not Required",
                  maintenanceRequired ? Colors.redAccent : secondary,
                ),
                _infoCard(
                  "Timestamp",
                  timestamp,
                  Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border(
                  left: BorderSide(
                    color: isHealthy ? secondary : Colors.redAccent,
                    width: 4,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: isHealthy ? secondary : Colors.redAccent,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Recommendation",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isHealthy
                              ? "Machine operating normally. No maintenance required at this time."
                              : "Failure risk detected. Schedule preventive maintenance immediately.",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                icon: const Icon(Icons.check_circle),
                label: const Text("Back To Home"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
