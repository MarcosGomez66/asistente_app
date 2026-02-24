import 'package:caja_inventario/core/theme/font_style.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/stock_service.dart';

class WasteStockScreen extends StatefulWidget {
  const WasteStockScreen({super.key});

  @override
  State<WasteStockScreen> createState() => _WasteStockScreenState();
}

class _WasteStockScreenState extends State<WasteStockScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mermar stock', style: titleStyle,),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}