import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class StockService {
  static const String baseUrl = 'http://192.168.100.84:3000';

  static Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  static Future<void> createProduct({
    required String name,
    required String description,
    required double salePrice,
    required double costPrice,
    required double stock,
    required double minStock,
    required String unit
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'salePrice': salePrice,
        'costPrice': costPrice,
        'stock': stock,
        'minStock': minStock,
        'unit': unit
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al cargar producto');
    }
  }
}