import 'dart:convert';
import 'package:http/http.dart' as http;

class MovementsService {
  static const String baseUrl = 'http://192.168.100.84:3000';

  static Future<void> adjustStock(
      String id,
      double newStock,
      String? reason,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/$id/adjust'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'newStock': newStock,
        'reason': reason
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al ajustar stock');
    }
  }
}