import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class StockService {
  static const String baseUrl = 'http://192.168.100.83:3000';

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

    if (response.statusCode != 201) {
      throw Exception('Error al crear producto');
    }
  }

  static Future<ProductModel> getById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: {
        'Content-type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception('Producto no encontrado');
    } else {
      throw Exception('Error al obtener producto');
    }
  }
}