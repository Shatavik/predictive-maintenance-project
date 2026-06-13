
import 'package:flutter/material.dart';

class ModelInfoScreen extends StatelessWidget {
  const ModelInfoScreen({super.key});

  static const Color bgColor = Color(0xFF051424);
  static const Color cardColor = Color(0xFF122131);
  static const Color secondary = Color(0xFF46EAED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text("Model Intelligence"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: secondary.withOpacity(.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Random Forest Classifier",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: secondary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "ACTIVE & OPTIMIZED",
                        style: TextStyle(
                          color: secondary,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text("Algorithm: Random Forest"),
                  SizedBox(height: 6),
                  Text("Features: 6 Sensor Inputs"),
                  SizedBox(height: 6),
                  Text("Dataset: AI4I Predictive Maintenance"),
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
              childAspectRatio: 1.15,
              children: const [
                _MetricCard("Accuracy", "98.25%"),
                _MetricCard("Precision", "75%"),
                _MetricCard("Recall", "74%"),
                _MetricCard("F1 Score", "74.5%"),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
                  Text(
                    "Inference Pipeline",
                    style: TextStyle(
                      color: secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),

                  Icon(Icons.storage,
                      size: 40, color: secondary),
                  Text("Dataset"),

                  Icon(Icons.arrow_downward),

                  Icon(Icons.tune,
                      size: 40, color: secondary),
                  Text("Preprocessing"),

                  Icon(Icons.arrow_downward),

                  Icon(Icons.account_tree,
                      size: 40, color: secondary),
                  Text("Random Forest"),

                  Icon(Icons.arrow_downward),

                  Icon(Icons.api,
                      size: 40, color: secondary),
                  Text("FastAPI"),

                  Icon(Icons.arrow_downward),

                  Icon(Icons.phone_android,
                      size: 40, color: secondary),
                  Text("Flutter App"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bar_chart,
                          color: secondary),
                      SizedBox(width: 10),
                      Text(
                        "Feature Importance",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _feature("Torque", 42),
                  _feature("Rotational Speed", 20),
                  _feature("Tool Wear", 15),
                  _feature("Air Temperature", 10),
                  _feature("Process Temperature", 8),
                  _feature("Type", 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _feature(String title, int percent) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text("$percent%"),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: percent / 100,
            color: secondary,
            backgroundColor: Colors.white12,
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const _MetricCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF122131),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF46EAED),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
