import 'package:flutter/material.dart';

class CajaScreen extends StatelessWidget {
  const CajaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Caja')),
      body: const Center(child: Text('Caja (proximamente...)')),
    );
  }
}
