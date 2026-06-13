
import 'package:flutter/material.dart';
import 'package:flutter_app/api_service.dart';
import 'package:flutter_app/result_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PredictScreen extends StatefulWidget {
  const PredictScreen({super.key});

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  String selectedType = 'L';
  bool isLoading = false;

  final airController = TextEditingController();
  final processController = TextEditingController();
  final speedController = TextEditingController();
  final torqueController = TextEditingController();
  final wearController = TextEditingController();

  static const bgColor = Color(0xFF051424);
  static const cardColor = Color(0xFF122131);
  static const primary = Color(0xFFB0C6FF);
  static const secondary = Color(0xFF46EAED);

  Future<void> predictMachine() async {
    try {
      setState(() {
        isLoading = true;
      });

      int machineType = 0;

      if (selectedType == 'M') {
        machineType = 1;
      } else if (selectedType == 'H') {
        machineType = 2;
      }

      final result = await ApiService.predict(
        type: machineType,
        airTemperature: double.parse(airController.text),
        processTemperature: double.parse(processController.text),
        rotationalSpeed: double.parse(speedController.text),
        torque: double.parse(torqueController.text),
        toolWear: double.parse(wearController.text),
      );
      Hive.box('prediction_history').add(result);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            status: result["status"],
            prediction: result["prediction"],
            failureProbability:
            (result["failure_probability"] as num).toDouble(),
            maintenanceRequired:
            result["maintenance_required"],
            timestamp: result["timestamp"],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Prediction Failed: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text('Predict Machine Health'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.help_outline),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    secondary.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Predictive Engine',
                  style: TextStyle(color: secondary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Machine Configuration',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _typeButton('L', 'Low (L)'),
                      const SizedBox(width: 8),
                      _typeButton('M', 'Medium'),
                      const SizedBox(width: 8),
                      _typeButton('H', 'High (H)'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              child: Column(
                children: [
                  _field('Air Temperature', airController, Icons.thermostat),
                  const SizedBox(height: 14),
                  _field('Process Temperature', processController, Icons.device_thermostat),
                  const SizedBox(height: 14),
                  _field('Rotational Speed (RPM)', speedController, Icons.speed),
                  const SizedBox(height: 14),
                  _field('Torque (Nm)', torqueController, Icons.settings),
                  const SizedBox(height: 14),
                  _field('Tool Wear (min)', wearController, Icons.build),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ensure all values represent the last 5 minutes of operational average.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomSheet: Container(
        color: bgColor,
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : predictMachine,
            icon: const Icon(Icons.auto_awesome),
            label: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Predict Machine Health'),
          ),
        ),
      ),
    );
  }

  Widget _typeButton(String value, String text) {
    final active = selectedType == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? secondary.withValues(alpha: 0.2) : cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: active ? secondary : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
