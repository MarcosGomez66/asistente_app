import 'package:caja_inventario/core/theme/font_style.dart';
import 'package:caja_inventario/features/stock/screens/add_product_screen.dart';
import 'package:caja_inventario/features/stock/services/stock_service.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductModel? product;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await StockService.getById(widget.productId);

      setState(() {
        product = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error al cargar el producto: $e';
        isLoading = false;
      });
    }
  }

  /// agregar los metodos para ir a las pantallas de ajuste, merma y desactivacion

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(error!),),
      );
    }

    final p = product!;
    final lowStock = p.stock <= p.minStock;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del producto', style: titleStyle,),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchProduct,
          )
        ],
      ),
      body: Center(
        child: Text(p.name),
      ),
    );
  }
}