import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rutina_provider.dart';
import 'models.dart';
import 'ejercicios_screen.dart';

class RutinasScreen extends StatefulWidget {
  RutinasScreen({super.key});

  @override
  State<RutinasScreen> createState() => _RutinasScreenState();
}

class _RutinasScreenState extends State<RutinasScreen> {
  final _nombreCtrl = TextEditingController();

  final List<String> _diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];
  String _diaSeleccionado = 'Lunes';

  void _mostrarDialogoAgregar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Nueva Rutina"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreCtrl,
              decoration: InputDecoration(
                labelText: "Nombre (ej: Pecho y Tríceps)",
                prefixIcon: Icon(Icons.edit),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _diaSeleccionado,
              decoration: InputDecoration(
                labelText: "Día de la semana",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              items: _diasSemana.map((dia) {
                return DropdownMenuItem(value: dia, child: Text(dia));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _diaSeleccionado = val);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              _guardarRutina(ctx);
            },
            child: Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _guardarRutina(BuildContext ctx) {
    if (_nombreCtrl.text.isEmpty) return;
    final nuevaRutina = Rutina(
      nombre: _nombreCtrl.text,
      diaSemana: _diaSeleccionado,
    );

    Provider.of<RutinaProvider>(
      context,
      listen: false,
    ).agregarRutina(nuevaRutina);

    _nombreCtrl.clear();
    Navigator.pop(ctx);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Rutina creada correctamente")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mis Rutinas"), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarDialogoAgregar(context),
        label: Text("Nueva Rutina"),
        icon: Icon(Icons.add),
      ),
      body: Consumer<RutinaProvider>(
        builder: (context, provider, child) {
          final rutinas = provider.rutinas;

          if (rutinas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text("No tienes rutinas creadas"),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: rutinas.length,
            itemBuilder: (context, index) {
              final item = rutinas[index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    child: Text(item.diaSemana.substring(0, 1)),
                  ),
                  title: Text(
                    item.nombre,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Programado para el ${item.diaSemana}"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      if (item.id != null) {
                        provider.borrarRutina(item.id!);
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EjerciciosScreen(rutina: item),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
