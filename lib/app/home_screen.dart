import 'package:flutter/material.dart';
import 'font_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool activeWDay = false;

  void toggleWDay() {
    setState(() {
      activeWDay = !activeWDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asistente de ventas', style: titleStyle), backgroundColor: Colors.deepPurple,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: activeWDay ? Colors.green : Colors.red,
                ),
                onPressed: toggleWDay,
                child: Text(
                  activeWDay ? 'Abierto' : 'Cerrado',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
