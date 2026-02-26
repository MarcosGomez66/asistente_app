import 'package:caja_inventario/core/theme/font_style.dart';
import 'package:caja_inventario/features/movements/services/movements_service.dart';
import 'package:flutter/material.dart';
import '../../stock/models/product_model.dart';
import '../../stock/services/stock_service.dart';

class WasteStockScreen extends StatefulWidget {
  final ProductModel product;
  const WasteStockScreen({super.key, required this.product});

  @override
  State<WasteStockScreen> createState() => _WasteStockScreenState();
}

class _WasteStockScreenState extends State<WasteStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  bool isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final quantity = double.parse(_quantityController.text);
    setState(() => isLoading = true);

    try {
      await MovementsService.wasteStock(
        widget.product.id,
        quantity,
        _reasonController.text,
      );

      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al registrar merma: ${e}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar merma', style: titleStyle),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text('Stock actual: ${product.stock}'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad a descontar',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese una cantidad';
                  }
                  final qty = double.tryParse(value);
                  if (qty == null) return 'Numero inválido';
                  if (qty <= 0) return 'Debe ser mayor a 0';
                  if (qty > product.stock) {
                    return 'No puede ser mayor al stock actual';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Motivo (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Registrar merma'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
