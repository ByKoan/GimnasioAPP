import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'models.dart';

class Ejercicio {
  final int? id;
  final int rutinaId;
  final String nombre;
  final String series;
  final String repeticiones;

  Ejercicio({
    this.id,
    required this.rutinaId,
    required this.nombre,
    required this.series,
    required this.repeticiones,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'rutina_id': rutinaId,
    'nombre': nombre,
    'series': series,
    'repeticiones': repeticiones,
  };

  factory Ejercicio.fromMap(Map<String, dynamic> map) => Ejercicio(
    id: map['id'],
    rutinaId: map['rutina_id'],
    nombre: map['nombre'],
    series: map['series'],
    repeticiones: map['repeticiones'],
  );
}

class RutinaProvider extends ChangeNotifier {
  Database? _database;

  List<Rutina> _rutinas = [];
  List<Rutina> get rutinas => _rutinas;

  List<Ejercicio> _ejercicios = [];
  List<Ejercicio> get ejercicios => _ejercicios;

  Rutina? _rutinaDeHoy;
  Rutina? get rutinaDeHoy => _rutinaDeHoy;
  Rutina? _rutinaSeleccionada;
  Rutina? get rutinaSeleccionada => _rutinaSeleccionada;

  Future<void> initDB() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = join(await getDatabasesPath(), 'gym_app_v2.db');

    print('Database path: $dbPath');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE rutinas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            dia_semana TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE ejercicios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            rutina_id INTEGER,
            nombre TEXT,
            series TEXT,
            repeticiones TEXT,
            FOREIGN KEY(rutina_id) REFERENCES rutinas(id) ON DELETE CASCADE
          )
        ''');
      },
    );
    await cargarRutinas();
  }

  Future<void> cargarRutinas() async {
    if (_database == null) return;
    final maps = await _database!.query('rutinas');
    _rutinas = List.generate(maps.length, (i) => Rutina.fromMap(maps[i]));
    notifyListeners();
  }

  Future<void> agregarRutina(Rutina rutina) async {
    if (_database == null) return;
    await _database!.insert('rutinas', rutina.toMap());
    await cargarRutinas();
  }

  Future<void> borrarRutina(int id) async {
    if (_database == null) return;
    await _database!.delete('rutinas', where: 'id = ?', whereArgs: [id]);
    await cargarRutinas();
  }

  Future<void> cargarEjercicios(int rutinaId) async {
    if (_database == null) return;
    final maps = await _database!.query(
      'ejercicios',
      where: 'rutina_id = ?',
      whereArgs: [rutinaId],
    );
    _ejercicios = List.generate(maps.length, (i) => Ejercicio.fromMap(maps[i]));
    notifyListeners();
  }

  Future<void> agregarEjercicio(Ejercicio ejercicio) async {
    if (_database == null) return;
    await _database!.insert('ejercicios', ejercicio.toMap());
    await cargarEjercicios(ejercicio.rutinaId);
  }

  Future<void> borrarEjercicio(int id, int rutinaId) async {
    if (_database == null) return;
    await _database!.delete('ejercicios', where: 'id = ?', whereArgs: [id]);
    await cargarEjercicios(rutinaId);
  }

  Future<void> comprobarRutinaDeHoy() async {
    if (_database == null) return;
    final now = DateTime.now();
    final List<String> diasSemana = [
      '',
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    final String hoyTexto = diasSemana[now.weekday];

    final maps = await _database!.query(
      'rutinas',
      where: 'dia_semana = ?',
      whereArgs: [hoyTexto],
    );

    if (maps.isNotEmpty) {
      _rutinaDeHoy = Rutina.fromMap(maps.first);
    } else {
      _rutinaDeHoy = null;
    }
    notifyListeners();
  }

  Future<void> buscarRutinaPorDia(String diaNombre) async {
    if (_database == null) return;

    final maps = await _database!.query(
      'rutinas',
      where: 'dia_semana = ?',
      whereArgs: [diaNombre],
    );

    if (maps.isNotEmpty) {
      _rutinaSeleccionada = Rutina.fromMap(maps.first);
    } else {
      _rutinaSeleccionada = null;
    }
    notifyListeners();
  }
}
