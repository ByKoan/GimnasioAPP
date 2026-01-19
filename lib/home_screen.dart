import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rutina_provider.dart';
import 'ejercicios_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarRutinaDelDia(_fechaSeleccionada);
    });
  }

  void _cargarRutinaDelDia(DateTime fecha) {
    final List<String> diasNombres = [
      '',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    final nombreDia = diasNombres[fecha.weekday];

    Provider.of<RutinaProvider>(
      context,
      listen: false,
    ).buscarRutinaPorDia(nombreDia);

    setState(() {
      _fechaSeleccionada = fecha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendario Semanal"), centerTitle: false),
      body: Column(
        children: [
          _buildCalendarioSemanal(),
          Divider(height: 30),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<RutinaProvider>(
                builder: (context, provider, child) {
                  final rutina = provider.rutinaSeleccionada;
                  if (rutina == null) {
                    return _buildDescansoCard();
                  }
                  return _buildRutinaCard(rutina);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarioSemanal() {
    final hoy = DateTime.now();
    final lunesDeEstaSemana = hoy.subtract(Duration(days: hoy.weekday - 1));

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final fechaDia = lunesDeEstaSemana.add(Duration(days: index));
          final esSeleccionado = _mismoDia(fechaDia, _fechaSeleccionada);
          final esHoy = _mismoDia(fechaDia, DateTime.now());
          final letrasDias = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

          return GestureDetector(
            onTap: () => _cargarRutinaDelDia(fechaDia),
            child: Container(
              width: 60,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: esSeleccionado
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                        context,
                      ).colorScheme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: esHoy
                    ? Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    letrasDias[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: esSeleccionado ? Colors.white : Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "${fechaDia.day}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: esSeleccionado
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _mismoDia(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDescansoCard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text(
            "Día Libre",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text("No hay rutina asignada para este día."),
        ],
      ),
    );
  }

  Widget _buildRutinaCard(dynamic rutina) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EjerciciosScreen(rutina: rutina),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Icon(Icons.fitness_center, size: 60),
                  SizedBox(height: 20),
                  Text(
                    "RUTINA ASIGNADA",
                    style: TextStyle(letterSpacing: 2, fontSize: 12),
                  ),
                  SizedBox(height: 10),
                  Text(
                    rutina.nombre.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Chip(label: Text("Toca para ver ejercicios")),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
