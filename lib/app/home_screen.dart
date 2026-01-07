import 'package:flutter/material.dart';
import 'font_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool activeWDay = false;

  void DwInit() {
    setState(() {
      activeWDay = true;
    });
    // guardar fecha de inicio en backend
  }

  void DwEnded() {
    setState(() {
      activeWDay = false;
    });
    // guardad fecha de cierre en backen
  }

  Future<bool> DwEndConfirm(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text('Terminar jornada'),
              content: const Text(
                "Desea Finalizar la jornada? \n Esta acción guardará los datos del día",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Terminar'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistente de ventas', style: titleStyle),
        backgroundColor: Colors.deepPurple,
      ),
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
                onPressed: () async {
                  if (activeWDay) {
                    final confirm = await DwEndConfirm(context);
                    if (!confirm) return;
                    DwEnded();
                  } else {
                    DwInit();
                  }
                },
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
