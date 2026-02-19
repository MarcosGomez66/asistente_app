import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkdayService {
  static const String baseUrl = 'http://192.168.100.83:3000';

  static Future<Map<String, dynamic>?> getCurrent() async {
    final response = await http.get(
      Uri.parse('$baseUrl/workday/current'),
    );

    if (response.statusCode == 200 && response.body != 'null') {
      return jsonDecode(response.body);
    }
    return null;
  }

  static Future<Map<String, dynamic>> start() async {
    final response = await http.post(
      Uri.parse('$baseUrl/workday/start'),
    );

    if (response.statusCode != 201) {
      throw Exception('No se pudo abrir la jornada');
    }

    return jsonDecode(response.body);
  }

  static Future<void> close(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/workday/close/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudo cerrar la jornada');
    }
  }
}