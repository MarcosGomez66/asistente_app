import 'package:caja_inventario/core/theme/font_style.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/stock_service.dart';

class AdjustStockScreen extends StatefulWidget {
  const AdjustStockScreen({super.key});

  @override
  State<AdjustStockScreen> createState() => _AdjustStockScreenState();
}

class _AdjustStockScreenState extends State<AdjustStockScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustar stock', style: titleStyle,),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}