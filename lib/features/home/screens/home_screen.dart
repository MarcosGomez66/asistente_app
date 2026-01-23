import 'package:flutter/material.dart';
import '../services/wd_service.dart';
import '../../../core/theme/font_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool activeWDay = false;
  int? workdayId;
  DateTime? startDate;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCurrentWd();
  }

  Future<void> loadCurrentWd() async {
    try {
      final workday = await WorkdayService.getCurrent();
      if (workday != null) {
        activeWDay = true;
        workdayId = workday['id'];
        startDate = DateTime.parse(workday['start_date']);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> wdStart() async {
    try {
      final workday = await WorkdayService.start();
      setState(() {
        activeWDay = true;
        workdayId = workday['id'];
      });
    } catch (e) {
      showError('No se pudo abrir la jornada');
    }
  }

  Future<void> wdClose() async {
    if (workdayId == null) return;

    try {
      await WorkdayService.close(workdayId!);
      setState(() {
        activeWDay = false;
        workdayId = null;
      });
    } catch (e) {
      showError('No se pudo cerrar la jornada');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> wdCloseConfirm(BuildContext context) async {
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

  Widget wdStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  activeWDay ? Icons.check_circle : Icons.cancel,
                  color: activeWDay ? Colors.green : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  activeWDay ? 'Jornada ABIERTA' : 'Jornada CERRADA',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (activeWDay && startDate != null)
              Text(
                'Iniciada: ${formatDate(startDate!)}',
                style: const TextStyle(fontSize: 16),
              )
            else
              const Text(
                'No hay jornada activa',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  Widget wdActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: activeWDay ? Colors.red : Colors.green,
        ),
        onPressed: loading
            ? null
            : () async {
                if (activeWDay) {
                  final confirm = await wdCloseConfirm(context);
                  if (!confirm) return;
                  await wdClose();
                } else {
                  await wdStart();
                }
              },
        child: Text(
          activeWDay ? 'CERRAR JORNADA' : 'INICIAR JORNADA',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
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
            SizedBox(child: wdStatusCard()),
            SizedBox(child: wdActionButton(context)),
          ],
        ),
      ),
    );
  }
}
