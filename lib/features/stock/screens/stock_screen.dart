import 'package:caja_inventario/core/theme/font_style.dart';
import 'package:caja_inventario/features/stock/screens/add_product_screen.dart';
import 'package:caja_inventario/features/stock/screens/stock_detail_screen.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/stock_service.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  late Future<List<ProductModel>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = StockService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos', style: titleStyle,),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.deepPurple,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddProductScreen()
                    )
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(
              child: Text('No hay productos cargados'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8,),
            itemBuilder: (context, index) {
              final product = products[index];
              final isLowStock = product.stock <= product.minStock;
              return Card(
                elevation: 2,
                child: ListTile(
                  title: Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Gs ${product.salePrice.toStringAsFixed(0)} • Stock: ${product.stock.toStringAsFixed(0)} -${product.description}-',
                  ),
                  trailing: isLowStock ? const Icon(Icons.warning) : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: product.id,)
                      )
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}