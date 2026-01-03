import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Plan extends StatefulWidget {
  const Plan({super.key});

  @override
  State<Plan> createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  void _mostrarFormularioPlan() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nuevo Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del plan'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
              _nombreController.clear();
              _descripcionController.clear();
            },
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () {
              _registrarPlan();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _registrarPlan() async {
    final nombre = _nombreController.text.trim();
    final descripcion = _descripcionController.text.trim();

    if (nombre.isEmpty || descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('planes').add({
        'nombre': nombre,
        'descripcion': descripcion,
        'fechaCreacion': Timestamp.now(),
      });
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plan registrado correctamente')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    _nombreController.clear();
    _descripcionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_today, size: 28, color: Color.fromRGBO(37, 40, 255, 1)),
              SizedBox(width: 30),
              Text(
                'Planes',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Administra tus metas y presupuestos mensuales.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 50),
          Center(
            child: ElevatedButton.icon(
              onPressed: _mostrarFormularioPlan,
              icon: const Icon(Icons.add, color: Color.fromRGBO(255, 255, 255, 1)),
              label: const Text(
                'Registrar Plan',
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(37, 40, 255, 1),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
