import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/stock/screens/stock_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    StockScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      // boton para ventas
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.point_of_sale),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('proximamente ventas'))
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.home,
                color: currentIndex == 0 ? Colors.deepPurple : Colors.grey,
              ),
              onPressed: () => setState(() => currentIndex = 0),
            ),
            const SizedBox(width: 18,),
            IconButton(
              icon: Icon(
                Icons.inventory,
                color: currentIndex == 1 ? Colors.deepPurple : Colors.grey,
              ),
              onPressed: () => setState(() => currentIndex = 1),
            ),
          ],
        ),
      ),
    );
  }
}