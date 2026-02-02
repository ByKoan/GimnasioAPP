import 'package:flutter/material.dart';
import 'package:gimnasioapp/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../viewmodels/rutina_provider.dart';

class ProgresoScreen extends StatefulWidget {
  const ProgresoScreen({super.key});

  @override
  State<ProgresoScreen> createState() => _ProgresoScreenState();
}

class _ProgresoScreenState extends State<ProgresoScreen> {
  int? _idEjercicioSeleccionado;
  bool _mostrarPesoCorporal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<RutinaProvider>();
      provider.cargarCatalogo();
      provider.cargarHistorialPesoCorporal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.estadisticas)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _botonModo(
                    l10n.ejercicios,
                    !_mostrarPesoCorporal,
                    () => setState(() => _mostrarPesoCorporal = false),
                  ),
                  _botonModo(
                    l10n.pesoCorporal,
                    _mostrarPesoCorporal,
                    () => setState(() => _mostrarPesoCorporal = true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (!_mostrarPesoCorporal)
              Consumer<RutinaProvider>(
                builder: (context, provider, child) {
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: l10n.eligeEjercicio,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.fitness_center),
                    ),
                    value: _idEjercicioSeleccionado,
                    items: provider.catalogoEjercicios
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.nombre),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() => _idEjercicioSeleccionado = val);
                      if (val != null) provider.cargarHistorialDeEjercicio(val);
                    },
                  );
                },
              ),
            const SizedBox(height: 20),
            Text(
              _mostrarPesoCorporal ? l10n.evolucionPeso : l10n.progresoCargas,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<RutinaProvider>(
                builder: (context, provider, _) {
                  if (_mostrarPesoCorporal) {
                    final datosPeso = provider.historialPesoCorporal;
                    if (datosPeso.isEmpty)
                      return _mensajeVacio(Icons.scale, l10n.sinDatos);
                    return _construirGrafica(datosPeso, esPesoCorporal: true);
                  }
                  if (_idEjercicioSeleccionado == null)
                    return _mensajeVacio(Icons.touch_app, l10n.eligeEjercicio);
                  final datosEj = provider.historialSeleccionado;
                  if (datosEj.isEmpty)
                    return _mensajeVacio(Icons.bar_chart, l10n.sinDatos);
                  return _construirGrafica(datosEj, esPesoCorporal: false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _botonModo(String texto, bool activo, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: activo ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: activo
                ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                : [],
          ),
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: activo ? Colors.black : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _mensajeVacio(IconData icon, String texto) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text(texto, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _construirGrafica(
    List<dynamic> datos, {
    required bool esPesoCorporal,
  }) {
    List<FlSpot> puntos = [];
    for (int i = 0; i < datos.length; i++) {
      double ejeY = esPesoCorporal ? datos[i]['peso'] as double : datos[i].peso;
      puntos.add(FlSpot(i.toDouble(), ejeY));
    }
    Color colorLinea = esPesoCorporal ? Colors.green : Colors.blueAccent;

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                "${value.toInt()}kg",
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: puntos,
            isCurved: true,
            color: colorLinea,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: colorLinea.withOpacity(0.15),
            ),
          ),
        ],
      ),
    );
  }
}
