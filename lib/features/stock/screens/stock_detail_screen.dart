import 'package:caja_inventario/core/theme/font_style.dart';
import 'package:caja_inventario/features/movements/screens/adjust_stock_screen.dart';
import 'package:caja_inventario/features/movements/screens/waste_stock_screen.dart';
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
  Future<void> _goToAdjustScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdjustStockScreen(product: product!,)
      ),
    );
    if (result == true) {
      await fetchProduct();
    }
  }

  Future<void> _goToWasteScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WasteStockScreen(product: product!,)
      ),
    );
    if (result == true) {
      await fetchProduct();
    }
  }

  Future<void> _confirmDeactivate() async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('Seguro que desea desactivar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirmar'),
          ),
        ],
      )
    );
    if (confirm == true) {
      // await ProductService.deactivate(widget.productId)
      await fetchProduct();
    }
  }

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
      body: RefreshIndicator(
        onRefresh: fetchProduct,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // datos generales
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(p.name, style: cardTitleStyle,),
                      if (p.description != null) ...[
                        const SizedBox(height: 8,),
                        Text(p.description!)
                      ],
                      const SizedBox(height: 12,),
                      Text('Precio de venta: \$${p.salePrice}'),
                      Text('Precio de compra: \$${p.costPrice}'),
                      Text('Forma de venta: ${p.unit}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8,),
              // datos de stock
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Cantidad actual ${p.stock}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: p.stock == 0 ? Colors.red : lowStock ? Colors.orange : Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Text('Cantidad minima: ${p.minStock}')
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8,),
              // estado
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        p.isActive ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontSize: 20,
                          color: p.isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 8,),
                      Text('Creado el: ${p.createdAt}'),
                      Text('Actualizado el: ${p.updatedAt}')
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              // botones
              if (p.isActive) ...[
                ElevatedButton.icon(
                  icon: const Icon(Icons.tune),
                  label: const Text('Ajustar'),
                  onPressed: _goToAdjustScreen,
                ),
                SizedBox(height: 8,),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Merma'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: p.stock > 0 ? _goToWasteScreen : null,
                ),
                SizedBox(height: 8,),
                ElevatedButton.icon(
                  icon: const Icon(Icons.block, color: Colors.white,),
                  label: const Text('Desactivar', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: _confirmDeactivate,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}