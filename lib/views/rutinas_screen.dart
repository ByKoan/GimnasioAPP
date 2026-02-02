import 'package:flutter/material.dart';
import 'package:gimnasioapp/l10n/app_localizations.dart';
import 'package:gimnasioapp/models/models.dart';
import 'package:provider/provider.dart';
import '../viewmodels/rutina_provider.dart';
import 'ejercicios_screen.dart';

class RutinasScreen extends StatelessWidget {
  const RutinasScreen({super.key});

  // --- DIÁLOGO PARA CREAR NUEVA RUTINA (NUEVO) ---
  void _mostrarDialogoCrear(BuildContext context, AppLocalizations l10n) {
    final nombreCtrl = TextEditingController();
    String diaSeleccionado = 'Lunes';
    final dias = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        // StatefulBuilder para que el Dropdown cambie visualmente dentro del diálogo
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(l10n.nuevaRutina),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.nombreRutina,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.edit),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: diaSeleccionado,
                    decoration: InputDecoration(
                      labelText: l10n.seleccionaDia,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    items: dias
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null)
                        setStateDialog(() => diaSeleccionado = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l10n.cancelar),
                ),
                FilledButton(
                  onPressed: () {
                    if (nombreCtrl.text.isNotEmpty) {
                      // Llamada al ViewModel para guardar
                      Provider.of<RutinaProvider>(
                        context,
                        listen: false,
                      ).agregarRutina(nombreCtrl.text, diaSeleccionado);

                      Navigator.pop(ctx);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.datosGuardados)),
                      );
                    }
                  },
                  child: Text(l10n.guardar),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- DIÁLOGO PARA DUPLICAR RUTINA ---
  void _mostrarDialogoDuplicar(
    BuildContext context,
    Rutina rutina,
    AppLocalizations l10n,
  ) {
    String diaSeleccionado = 'Lunes';
    final dias = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(l10n.copiar),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.nuevoDia),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: diaSeleccionado,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: dias
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null)
                        setStateDialog(() => diaSeleccionado = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(l10n.cancelar),
                ),
                FilledButton(
                  onPressed: () {
                    if (rutina.id != null) {
                      Provider.of<RutinaProvider>(
                        context,
                        listen: false,
                      ).duplicarRutina(rutina.id!, diaSeleccionado);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.rutinaCopiada)),
                      );
                    }
                  },
                  child: Text(l10n.copiar),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.rutinas)),

      // --- ESTE ES EL BOTÓN QUE FALTABA ---
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoCrear(context, l10n),
        tooltip: l10n.nuevaRutina,
        child: const Icon(Icons.add),
      ),

      // ------------------------------------
      body: Consumer<RutinaProvider>(
        builder: (context, provider, child) {
          final rutinas = provider.rutinas;
          if (rutinas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 60, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text(
                    l10n.sinDatos,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 80,
            ), // Espacio para que el botón no tape el último item
            itemCount: rutinas.length,
            itemBuilder: (context, index) {
              final item = rutinas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(item.diaSemana.substring(0, 1)),
                  ),
                  title: Text(item.nombre),
                  subtitle: Text(item.diaSemana),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EjerciciosScreen(rutina: item),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.blue),
                        tooltip: l10n.copiar,
                        onPressed: () =>
                            _mostrarDialogoDuplicar(context, item, l10n),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        tooltip: l10n.borrar,
                        onPressed: () {
                          if (item.id != null) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(l10n.seguroBorrar),
                                content: Text(l10n.advertenciaBorrar),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text(l10n.cancelar),
                                  ),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      provider.borrarRutina(item.id!);
                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(l10n.rutinaEliminada),
                                        ),
                                      );
                                    },
                                    child: Text(l10n.borrar),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
