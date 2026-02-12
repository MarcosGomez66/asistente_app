import 'package:flutter/material.dart';
import '../services/stock_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final salePriceController = TextEditingController();
  final costPriceController = TextEditingController();
  final stockController = TextEditingController();
  final minStockController = TextEditingController();

  String unit = 'unit';
  bool isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await StockService.createProduct(
          name: nameController.text,
          description: descriptionController.text,
          salePrice: double.parse(salePriceController.text),
          costPrice: double.parse(costPriceController.text),
          stock: double.parse(stockController.text),
          minStock: double.parse(minStockController.text),
          unit: unit
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(nameController, 'Nombre'),
              _buildTextField(descriptionController, 'Descripción'),
              _buildTextField(salePriceController, 'Precio de venta', isNumber: true),
              _buildTextField(costPriceController, 'Precio de compra', isNumber: true),
              _buildTextField(stockController, 'Stock inicial', isNumber: true),
              _buildTextField(minStockController, 'Stock minimo', isNumber: true),

              const SizedBox(height: 16,),

              DropdownButtonFormField(
                value: unit,
                items: const [
                  DropdownMenuItem(value: 'unit', child: Text('Unidad'),),
                  DropdownMenuItem(value: 'kg', child: Text('Kilogramo'),),
                ],
                onChanged: (value) {
                  setState(() => unit = value!);
                },
              ),
              const SizedBox(height: 24,),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                child: isLoading ? const CircularProgressIndicator() : const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}