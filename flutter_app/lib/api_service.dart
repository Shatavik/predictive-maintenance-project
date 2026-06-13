
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://predictive-maintenance-project-axoe.onrender.com/predict';

  static Future<Map<String, dynamic>> predict({
    required int type,
    required double airTemperature,
    required double processTemperature,
    required double rotationalSpeed,
    required double torque,
    required double toolWear,
  }) async {

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "Type": type,
        "Air_temperature": airTemperature,
        "Process_temperature": processTemperature,
        "Rotational_speed": rotationalSpeed,
        "Torque": torque,
        "Tool_wear": toolWear,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to get prediction: ${response.body}',
      );
    }
  }
}
