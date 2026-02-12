import 'package:caja_inventario/features/stock/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import '../navigation/main_layout.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const MainLayout(),
  '/create_product': (_) => const AddProductScreen()
};
