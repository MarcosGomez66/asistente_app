import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../features/caja/presentation/caja_screen.dart';
import '../features/inventario/presentation/inventario_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const HomeScreen(),
  '/caja': (context) => const CajaScreen(),
  '/inventario': (context) => const InventarioScreen(),
};
