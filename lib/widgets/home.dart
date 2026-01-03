import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const Color mainColor = Color.fromARGB(255, 37, 40, 255);
  double saldoActual = 1234.56;

  final List<Map<String, dynamic>> ingresos = [];
  final List<Map<String, dynamic>> gastos = [];

  void agregarIngreso(double monto, String titulo) {
    setState(() {
      saldoActual += monto;
      ingresos.add({
        'Título': titulo,
        'monto': monto,
        'fecha': DateTime.now(),
      });
    });
  }

  void agregarGasto(double monto, String titulo) {
    setState(() {
      saldoActual -= monto;
      gastos.add({
        'Título': titulo,
        'monto': monto,
        'fecha': DateTime.now(),
      });
    });
  }

  void mostrarFormularioIngreso() {
    final montoController = TextEditingController();
    final descripcionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Añadir Ingreso',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixIcon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final monto = double.tryParse(montoController.text);
                  final desc = descripcionController.text;
                  if (monto != null && monto > 0 && desc.isNotEmpty) {
                    agregarIngreso(monto, desc);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                child: const Text('Guardar ingreso'),
              ),
            ],
          ),
        );
      },
    );
  }

  void mostrarFormularioGasto() {
    final montoController = TextEditingController();
    final descripcionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Añadir Gasto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixIcon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final monto = double.tryParse(montoController.text);
                  final desc = descripcionController.text;
                  if (monto != null && monto > 0 && desc.isNotEmpty) {
                    agregarGasto(monto, desc);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                child: const Text('Guardar gasto'),
              ),
            ],
          ),
        );
      },
    );
  }

  String formatFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartCash'),
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: mainColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: mainColor,
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: mostrarFormularioGasto,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Saldo actual',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(
                      'S/. ${saldoActual.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gastos recientes',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add),
                  color: mainColor,
                  onPressed: mostrarFormularioGasto,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...gastos.reversed.map((gasto) {
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.arrow_downward, color: Colors.red),
                  title: Text(gasto['Título']),
                  subtitle: Text('Fecha: ${formatFecha(gasto['fecha'])}'),
                  trailing:
                      Text('- S/. ${gasto['monto'].toStringAsFixed(2)}'),
                ),
              );
            }),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ingresos recientes',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add),
                  color: mainColor,
                  onPressed: mostrarFormularioIngreso,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...ingresos.reversed.map((ingreso) {
              return Card(
                elevation: 2,
                child: ListTile(
                  leading:
                      const Icon(Icons.arrow_upward, color: Colors.green),
                  title: Text(ingreso['Título']),
                  subtitle: Text('Fecha: ${formatFecha(ingreso['fecha'])}'),
                  trailing:
                      Text('+ S/. ${ingreso['monto'].toStringAsFixed(2)}'),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Alertas rápidas
            const Text(
              'Alertas rápidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Estás cerca de exceder tu presupuesto en “Comida”.',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
