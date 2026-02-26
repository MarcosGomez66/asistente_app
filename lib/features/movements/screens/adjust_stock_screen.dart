import 'package:caja_inventario/core/theme/font_style.dart';
import 'package:caja_inventario/features/movements/services/movements_service.dart';
import 'package:flutter/material.dart';
import '../../stock/models/product_model.dart';
import '../../stock/services/stock_service.dart';

class AdjustStockScreen extends StatefulWidget {
  final ProductModel product;
  const AdjustStockScreen({super.key, required this.product});

  @override
  State<AdjustStockScreen> createState() => _AdjustStockScreenState();
}

class _AdjustStockScreenState extends State<AdjustStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stockController = TextEditingController();
  final _reasonController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _stockController.text = widget.product.stock.toString();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final newStock = double.parse(_stockController.text);
    setState(() => isLoading = true);

    try {
      await MovementsService.adjustStock(
        widget.product.id,
        newStock,
        _reasonController.text,
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al ajustar stock')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    print(product.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuste de stock', style: titleStyle),
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
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Stock actual: ${product.stock}',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nuevo stock',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Numero inválido';
                  }
                  if (double.parse(value) < 0) {
                    return 'No puede ser negativo';
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
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Confirmar ajuste'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
