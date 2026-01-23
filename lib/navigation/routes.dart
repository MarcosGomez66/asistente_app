import 'package:flutter/material.dart';
import '../navigation/main_layout.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const MainLayout(),
};
