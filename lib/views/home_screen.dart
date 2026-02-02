import 'package:flutter/material.dart';
import 'package:gimnasioapp/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../viewmodels/rutina_provider.dart';
import 'ejercicios_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _fechaFoco = DateTime.now();
  DateTime _fechaSeleccionada = DateTime.now();
  bool _esPasado = false;
  bool _entrenoRealizado = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosDelDia(_fechaSeleccionada);
    });
  }

  void _cargarDatosDelDia(DateTime fecha) async {
    final hoy = DateTime.now();
    final fechaSinHora = DateTime(fecha.year, fecha.month, fecha.day);
    final hoySinHora = DateTime(hoy.year, hoy.month, hoy.day);

    final esPasado = fechaSinHora.isBefore(hoySinHora);

    // Mapeo simple de días en inglés para la BBDD interna (No traducir esto, la BBDD espera estos strings)
    // Pero si quieres mostrarlo traducido en UI, usa DateFormat o l10n.
    final List<String> diasBBDD = [
      '',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    final nombreDia = diasBBDD[fecha.weekday];

    final provider = Provider.of<RutinaProvider>(context, listen: false);
    await provider.buscarRutinaPorDia(nombreDia);

    bool entrenoHecho = false;
    if (esPasado) {
      entrenoHecho = await provider.verificarSiHuboEntreno(fecha);
    }

    if (mounted) {
      setState(() {
        _fechaSeleccionada = fecha;
        _esPasado = esPasado;
        _entrenoRealizado = entrenoHecho;
        if (fecha.difference(_fechaFoco).inDays.abs() > 7) {
          _fechaFoco = fecha;
        }
      });
    }
  }

  void _volverAHoy() {
    final hoy = DateTime.now();
    setState(() {
      _fechaFoco = hoy;
    });
    _cargarDatosDelDia(hoy);
  }

  void _cambiarSemana(int dias) {
    setState(() {
      _fechaFoco = _fechaFoco.add(Duration(days: dias));
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> meses = [
      '',
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];

    final lunesSemana = _fechaFoco.subtract(
      Duration(days: _fechaFoco.weekday - 1),
    );
    final domingoSemana = lunesSemana.add(const Duration(days: 6));

    final textoSemana = l10n.semanaDel(lunesSemana.day, domingoSemana.day);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.calendario, style: const TextStyle(fontSize: 20)),
            Text(
              textoSemana,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: l10n.volverHoy,
            onPressed: _volverAHoy,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  onPressed: () => _cambiarSemana(-7),
                ),
                Text(
                  "${meses[_fechaFoco.month]} ${_fechaFoco.year}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 20),
                  onPressed: () => _cambiarSemana(7),
                ),
              ],
            ),
          ),
          _buildCalendarioResponsive(),
          const Divider(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<RutinaProvider>(
                builder: (context, provider, child) {
                  final rutina = provider.rutinaSeleccionada;

                  if (_esPasado) {
                    return _buildTarjetaHistorial(
                      rutina,
                      hecho: _entrenoRealizado,
                      l10n: l10n,
                    );
                  }

                  if (rutina == null) {
                    return _buildDescansoCard(esFuturo: true, l10n: l10n);
                  }
                  return _buildRutinaFuturaCard(rutina, l10n);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarioResponsive() {
    final lunesDeLaSemanaVisible = _fechaFoco.subtract(
      Duration(days: _fechaFoco.weekday - 1),
    );
    final letrasDias = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final fechaDia = lunesDeLaSemanaVisible.add(Duration(days: index));
          final esSeleccionado = _mismoDia(fechaDia, _fechaSeleccionada);
          final esHoy = _mismoDia(fechaDia, DateTime.now());

          return Expanded(
            child: GestureDetector(
              onTap: () => _cargarDatosDelDia(fechaDia),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: esSeleccionado
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(
                          context,
                        ).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: esHoy
                      ? Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        )
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      letrasDias[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: esSeleccionado ? Colors.white : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${fechaDia.day}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: esSeleccionado
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRutinaFuturaCard(dynamic rutina, AppLocalizations l10n) {
    return Column(
      children: [
        Card(
          elevation: 4,
          color: Theme.of(context).colorScheme.primaryContainer,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EjerciciosScreen(rutina: rutina),
              ),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  const Icon(Icons.fitness_center, size: 50),
                  const SizedBox(height: 10),
                  Text(
                    l10n.planificado,
                    style: const TextStyle(letterSpacing: 2, fontSize: 10),
                  ),
                  Text(
                    rutina.nombre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EjerciciosScreen(rutina: rutina)),
          ),
          child: Text(l10n.verEjercicios),
        ),
      ],
    );
  }

  Widget _buildTarjetaHistorial(
    dynamic rutina, {
    required bool hecho,
    required AppLocalizations l10n,
  }) {
    return Card(
      color: hecho ? Colors.green[100] : Colors.grey[200],
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(
              hecho ? Icons.check_circle : Icons.cancel,
              size: 60,
              color: hecho ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              hecho ? l10n.entrenoCompletado : l10n.noRealizado,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: hecho ? Colors.green[800] : Colors.grey[600],
              ),
            ),
            if (hecho && rutina != null)
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EjerciciosScreen(rutina: rutina),
                  ),
                ),
                child: Text(l10n.verEjercicios),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescansoCard({
    required bool esFuturo,
    required AppLocalizations l10n,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.weekend, size: 80, color: Colors.blue[100]),
          const SizedBox(height: 20),
          Text(
            l10n.descanso,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(esFuturo ? l10n.sinRutina : l10n.noRealizado),
        ],
      ),
    );
  }

  bool _mismoDia(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
