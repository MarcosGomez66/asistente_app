import 'package:flutter/material.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stock'),),
      body: Center(
        child: Text(
          'Gestion de stock',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}