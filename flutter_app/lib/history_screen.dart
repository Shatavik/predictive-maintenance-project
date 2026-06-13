
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const Color bgColor = Color(0xFF051424);
  static const Color cardColor = Color(0xFF122131);
  static const Color secondary = Color(0xFF46EAED);
  static const Color tertiary = Color(0xFFFFB596);

  final Box box = Hive.box('prediction_history');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text("Prediction History"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "RECENT TRENDS",
                    style: TextStyle(
                      color: secondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "LIVE DATA",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Prediction History Records",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search predictions...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box box, _) {

                if (box.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Predictions Yet",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: box.length,
                  itemBuilder: (context, index) {

                    final item =
                        box.getAt(box.length - 1 - index);

                    Color color;
                    IconData icon;

                    switch (item["status"]) {
                      case "Failure Risk":
                        color = Colors.redAccent;
                        icon = Icons.error;
                        break;

                      case "Warning":
                        color = tertiary;
                        icon = Icons.warning;
                        break;

                      default:
                        color = secondary;
                        icon = Icons.check_circle;
                    }

                    final probability =
                        (item["failure_probability"] as num)
                            .toDouble();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius:
                            BorderRadius.circular(20),
                        border: Border(
                          top: BorderSide(
                            color: color,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["status"] == "Healthy"
                                          ? "Healthy Prediction"
                                          : "Failure Risk Prediction",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item["timestamp"]
                                          .toString(),
                                      style: const TextStyle(
                                        color:
                                            Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(
                                      alpha: 0.15),
                                  borderRadius:
                                      BorderRadius.circular(
                                          20),
                                ),
                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    Icon(
                                      icon,
                                      size: 16,
                                      color: color,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item["status"],
                                      style: TextStyle(
                                        color: color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          LinearProgressIndicator(
                            value: probability / 100,
                            backgroundColor:
                                Colors.white12,
                            color: color,
                          ),

                          const SizedBox(height: 6),

                          Align(
                            alignment:
                                Alignment.centerRight,
                            child: Text(
                              "${probability.toStringAsFixed(1)}%",
                              style: TextStyle(
                                color: color,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
