import 'package:flutter/material.dart';
import 'package:gimnasioapp/l10n/app_localizations.dart';
import 'package:gimnasioapp/models/models.dart';
import 'package:provider/provider.dart';
import '../viewmodels/rutina_provider.dart';

class EjerciciosScreen extends StatefulWidget {
  final Rutina rutina;
  const EjerciciosScreen({super.key, required this.rutina});

  @override
  State<EjerciciosScreen> createState() => _EjerciciosScreenState();
}

class _EjerciciosScreenState extends State<EjerciciosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.rutina.id != null) {
        context.read<RutinaProvider>().cargarItemsDeRutina(widget.rutina.id!);
        context.read<RutinaProvider>().cargarCatalogo();
      }
    });
  }

  void _mostrarDialogoAgregar(AppLocalizations l10n) {
    final nombreCtrl = TextEditingController();
    final seriesCtrl = TextEditingController();
    final repesCtrl = TextEditingController();
    int? _idEjercicioSeleccionado;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setStateDialog) {
          final catalogo = context.read<RutinaProvider>().catalogoEjercicios;

          return AlertDialog(
            title: Text(l10n.anadirEjercicio),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    value: _idEjercicioSeleccionado,
                    hint: Text(l10n.eligeEjercicio),
                    items: catalogo
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.nombre),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setStateDialog(() {
                        _idEjercicioSeleccionado = val;
                        final nombre = catalogo
                            .firstWhere((e) => e.id == val)
                            .nombre;
                        nombreCtrl.text = nombre;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nombreCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.nombreEjercicio,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: seriesCtrl,
                          decoration: InputDecoration(labelText: l10n.series),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: repesCtrl,
                          decoration: InputDecoration(labelText: l10n.repes),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.cancelar),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nombreCtrl.text.isNotEmpty && widget.rutina.id != null) {
                    final provider = context.read<RutinaProvider>();
                    int idGlobal;
                    if (_idEjercicioSeleccionado != null) {
                      idGlobal = _idEjercicioSeleccionado!;
                    } else {
                      idGlobal = await provider.crearEjercicioGlobal(
                        nombreCtrl.text,
                      );
                    }
                    await provider.agregarEjercicioARutina(
                      widget.rutina.id!,
                      idGlobal,
                      nombreCtrl.text,
                      seriesCtrl.text,
                      repesCtrl.text,
                    );
                    Navigator.pop(ctx);
                  }
                },
                child: Text(l10n.guardar),
              ),
            ],
          );
        },
      ),
    );
  }

  void _mostrarDialogoProgreso(
    int ejercicioGlobalId,
    String nombreEjercicio,
    AppLocalizations l10n,
  ) {
    final pesoCtrl = TextEditingController();
    final repesRealizadasCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("$nombreEjercicio: ${l10n.registrarSerie}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: pesoCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.peso,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: repesRealizadasCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.repesHechas,
                border: const OutlineInputBorder(),
              ),
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
              final peso = double.tryParse(pesoCtrl.text);
              final repes = int.tryParse(repesRealizadasCtrl.text);
              if (peso != null && repes != null) {
                context.read<RutinaProvider>().registrarSerie(
                  ejercicioGlobalId,
                  peso,
                  repes,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.datosGuardados)));
              }
            },
            child: Text(l10n.guardar),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.rutina.nombre)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoAgregar(l10n),
        child: const Icon(Icons.add),
      ),
      body: Consumer<RutinaProvider>(
        builder: (context, provider, child) {
          final lista = provider.itemsRutinaActual;

          if (lista.isEmpty) return Center(child: Text(l10n.sinDatos));

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final item = lista[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    item.nombreEjercicio,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("${item.series} x ${item.repeticiones}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.fitness_center,
                          color: Colors.blue,
                        ),
                        onPressed: () => _mostrarDialogoProgreso(
                          item.ejercicioGlobalId,
                          item.nombreEjercicio,
                          l10n,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          if (item.id != null && widget.rutina.id != null) {
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
                                  TextButton(
                                    onPressed: () {
                                      provider.borrarItemRutina(
                                        item.id!,
                                        widget.rutina.id!,
                                      );
                                      Navigator.pop(ctx);
                                    },
                                    child: Text(
                                      l10n.borrar,
                                      style: const TextStyle(color: Colors.red),
                                    ),
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
