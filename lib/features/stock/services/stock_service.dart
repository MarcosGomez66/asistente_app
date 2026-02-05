import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class StockService {
  static const String baseUrl = 'http://192.168.100.85:3000';

  static Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}