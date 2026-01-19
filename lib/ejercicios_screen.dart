import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rutina_provider.dart';
import 'models.dart';

class EjerciciosScreen extends StatefulWidget {
  final Rutina rutina;

  EjerciciosScreen({super.key, required this.rutina});

  @override
  State<EjerciciosScreen> createState() => _EjerciciosScreenState();
}

class _EjerciciosScreenState extends State<EjerciciosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.rutina.id != null) {
        Provider.of<RutinaProvider>(
          context,
          listen: false,
        ).cargarEjercicios(widget.rutina.id!);
      }
    });
  }

  void _mostrarDialogoNuevoEjercicio() {
    final nombreCtrl = TextEditingController();
    final seriesCtrl = TextEditingController();
    final repesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Nuevo Ejercicio"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: InputDecoration(
                labelText: "Ejercicio (ej: Press Banca)",
              ),
            ),
            TextField(
              controller: seriesCtrl,
              decoration: InputDecoration(labelText: "Series (ej: 4)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: repesCtrl,
              decoration: InputDecoration(labelText: "Repeticiones (ej: 12)"),
              keyboardType: TextInputType.number,
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
              if (nombreCtrl.text.isNotEmpty && widget.rutina.id != null) {
                final nuevo = Ejercicio(
                  rutinaId: widget.rutina.id!,
                  nombre: nombreCtrl.text,
                  series: seriesCtrl.text,
                  repeticiones: repesCtrl.text,
                );
                context.read<RutinaProvider>().agregarEjercicio(nuevo);
                Navigator.pop(ctx);
              }
            },
            child: Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.rutina.nombre)),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialogoNuevoEjercicio,
        child: Icon(Icons.add),
      ),
      body: Consumer<RutinaProvider>(
        builder: (context, provider, child) {
          final lista = provider.ejercicios;

          if (lista.isEmpty) {
            return Center(child: Text("Añade tu primer ejercicio 💪"));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final ej = lista[index];
              return ListTile(
                title: Text(
                  ej.nombre,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("${ej.series} series x ${ej.repeticiones} reps"),
                leading: Icon(Icons.fitness_center),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    if (ej.id != null) {
                      provider.borrarEjercicio(ej.id!, widget.rutina.id!);
                    }
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
