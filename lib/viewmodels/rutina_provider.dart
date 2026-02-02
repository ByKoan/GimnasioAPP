import 'package:flutter/material.dart';
import 'package:gimnasioapp/models/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

// El ejercicio "Global" (Catálogo)
class EjercicioGlobal {
  final int? id;
  final String nombre;

  EjercicioGlobal({this.id, required this.nombre});

  factory EjercicioGlobal.fromMap(Map<String, dynamic> map) =>
      EjercicioGlobal(id: map['id'], nombre: map['nombre']);
}

// El item dentro de la rutina (El enlace)
class ItemRutina {
  final int? id;
  final int rutinaId;
  final int ejercicioGlobalId;
  final String nombreEjercicio;
  final String series;
  final String repeticiones;

  ItemRutina({
    this.id,
    required this.rutinaId,
    required this.ejercicioGlobalId,
    required this.nombreEjercicio,
    required this.series,
    required this.repeticiones,
  });

  factory ItemRutina.fromMap(Map<String, dynamic> map) => ItemRutina(
    id: map['id'],
    rutinaId: map['rutina_id'],
    ejercicioGlobalId: map['ejercicio_id'],
    nombreEjercicio: map['nombre_cache'] ?? 'Ejercicio',
    series: map['series'],
    repeticiones: map['repes'],
  );
}

// El registro histórico (Progreso)
class HistorialSet {
  final int? id;
  final int ejercicioGlobalId;
  final String fecha;
  final double peso;
  final int repesRealizadas;

  HistorialSet({
    this.id,
    required this.ejercicioGlobalId,
    required this.fecha,
    required this.peso,
    required this.repesRealizadas,
  });
}

/// Clase principal que gestiona la lógica de negocio y la conexión a SQLite.
///
/// Utiliza el patrón [ChangeNotifier] para actualizar la interfaz
/// automáticamente cuando cambian los datos.
class RutinaProvider extends ChangeNotifier {
  Database? _database;

  List<Rutina> _rutinas = [];
  List<Rutina> get rutinas => _rutinas;

  // Catálogo completo de ejercicios disponibles
  List<EjercicioGlobal> _catalogoEjercicios = [];
  List<EjercicioGlobal> get catalogoEjercicios => _catalogoEjercicios;

  // Ejercicios de la rutina actual que estamos viendo
  List<ItemRutina> _itemsRutinaActual = [];
  List<ItemRutina> get itemsRutinaActual => _itemsRutinaActual;

  Rutina? _rutinaSeleccionada;
  Rutina? get rutinaSeleccionada => _rutinaSeleccionada;
  Rutina? _rutinaDeHoy;
  Rutina? get rutinaDeHoy => _rutinaDeHoy;

  /// Inicializa la base de datos SQLite.
  ///
  /// Si estamos en Windows/Linux, inicializa [sqfliteFfiInit].
  /// Crea las tablas: rutinas, catalogo, rutina_items, historial y peso_corporal.
  /// También inserta datos de prueba (Seed Data) si la BBDD es nueva.
  Future<void> initDB() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // CAMBIAMOS A v5 PARA QUE SE EJECUTE EL ONCREATE DE NUEVO
    final dbPath = join(await getDatabasesPath(), 'gym_app_v7.db');

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE rutinas(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, dia_semana TEXT)',
        );
        await db.execute(
          'CREATE TABLE catalogo(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT UNIQUE)',
        );

        await db.execute('''
          CREATE TABLE rutina_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            rutina_id INTEGER,
            ejercicio_id INTEGER,
            nombre_cache TEXT, 
            series TEXT,
            repes TEXT,
            FOREIGN KEY(rutina_id) REFERENCES rutinas(id) ON DELETE CASCADE,
            FOREIGN KEY(ejercicio_id) REFERENCES catalogo(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE historial(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ejercicio_id INTEGER,
            fecha TEXT,
            peso REAL,
            repes_realizadas INTEGER,
            FOREIGN KEY(ejercicio_id) REFERENCES catalogo(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE peso_corporal(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fecha TEXT,
            peso REAL
          )
        ''');

        // Insertamos 3 Ejercicios Globales en el Catálogo
        // ID 1: Press Banca, ID 2: Sentadilla, ID 3: Dominadas
        await db.rawInsert(
          "INSERT INTO catalogo(nombre) VALUES('Press de Banca')",
        );
        await db.rawInsert("INSERT INTO catalogo(nombre) VALUES('Sentadilla')");
        await db.rawInsert("INSERT INTO catalogo(nombre) VALUES('Dominadas')");

        // Insertamos 2 Rutinas
        // ID 1: Lunes, ID 2: Jueves
        await db.rawInsert(
          "INSERT INTO rutinas(nombre, dia_semana) VALUES('Pecho Fuerza', 'Lunes')",
        );
        await db.rawInsert(
          "INSERT INTO rutinas(nombre, dia_semana) VALUES('Pierna Hipertrofia', 'Jueves')",
        );

        // Vinculamos Ejercicios a las Rutinas
        // En la rutina 1 (Pecho) metemos Press Banca (ID 1)
        await db.rawInsert('''
          INSERT INTO rutina_items(rutina_id, ejercicio_id, nombre_cache, series, repes) 
          VALUES(1, 1, 'Press de Banca', '4', '6-8')
        ''');

        // En la rutina 2 (Pierna) metemos Sentadilla (ID 2)
        await db.rawInsert('''
          INSERT INTO rutina_items(rutina_id, ejercicio_id, nombre_cache, series, repes) 
          VALUES(2, 2, 'Sentadilla', '4', '10-12')
        ''');

        // Insertamos HISTORIAL para que la GRÁFICA salga bonita
        // Vamos a simular que entrenaste hace 3 semanas, hace 2, hace 1 y hoy.
        // Ejercicio ID 1 (Press Banca)

        final hoy = DateTime.now();
        final semana1 = hoy
            .subtract(const Duration(days: 21))
            .toIso8601String();
        final semana2 = hoy
            .subtract(const Duration(days: 14))
            .toIso8601String();
        final semana3 = hoy.subtract(const Duration(days: 7)).toIso8601String();
        final hoyIso = hoy.toIso8601String();

        // Progresión: 60kg -> 65kg -> 67.5kg -> 70kg
        await db.insert('historial', {
          'ejercicio_id': 1,
          'fecha': semana1,
          'peso': 60.0,
          'repes_realizadas': 8,
        });
        await db.insert('historial', {
          'ejercicio_id': 1,
          'fecha': semana2,
          'peso': 65.0,
          'repes_realizadas': 8,
        });
        await db.insert('historial', {
          'ejercicio_id': 1,
          'fecha': semana3,
          'peso': 67.5,
          'repes_realizadas': 7,
        });
        await db.insert('historial', {
          'ejercicio_id': 1,
          'fecha': hoyIso,
          'peso': 70.0,
          'repes_realizadas': 6,
        });

        print("Datos de prueba insertados correctamente");
      },
    );

    await cargarRutinas();
    await cargarCatalogo();
  }

  Future<void> cargarRutinas() async {
    if (_database == null) return;
    final maps = await _database!.query('rutinas');
    _rutinas = List.generate(maps.length, (i) => Rutina.fromMap(maps[i]));
    notifyListeners();
  }

  Future<void> agregarRutina(String nombre, String diaSemana) async {
    if (_database == null) return;
    await _database!.insert('rutinas', {
      'nombre': nombre,
      'dia_semana': diaSemana,
    });
    await cargarRutinas();
  }

  Future<void> borrarRutina(int id) async {
    await _database!.delete('rutinas', where: 'id = ?', whereArgs: [id]);
    await cargarRutinas();
  }

  Future<void> cargarCatalogo() async {
    final maps = await _database!.query('catalogo', orderBy: 'nombre');
    _catalogoEjercicios = List.generate(
      maps.length,
      (i) => EjercicioGlobal.fromMap(maps[i]),
    );
    notifyListeners();
  }

  // Crea un ejercicio global si no existe (ej: "Press Banca")
  Future<int> crearEjercicioGlobal(String nombre) async {
    final existe = await _database!.query(
      'catalogo',
      where: 'nombre = ?',
      whereArgs: [nombre],
    );
    if (existe.isNotEmpty) {
      return existe.first['id'] as int;
    }
    final id = await _database!.insert('catalogo', {'nombre': nombre});
    await cargarCatalogo();
    return id;
  }

  // Añade ese ejercicio global a una rutina específica
  Future<void> agregarEjercicioARutina(
    int rutinaId,
    int ejercicioGlobalId,
    String nombre,
    String series,
    String repes,
  ) async {
    await _database!.insert('rutina_items', {
      'rutina_id': rutinaId,
      'ejercicio_id': ejercicioGlobalId,
      'nombre_cache': nombre,
      'series': series,
      'repes': repes,
    });
    await cargarItemsDeRutina(rutinaId);
  }

  Future<void> cargarItemsDeRutina(int rutinaId) async {
    final maps = await _database!.query(
      'rutina_items',
      where: 'rutina_id = ?',
      whereArgs: [rutinaId],
    );
    _itemsRutinaActual = List.generate(
      maps.length,
      (i) => ItemRutina.fromMap(maps[i]),
    );
    notifyListeners();
  }

  Future<void> borrarItemRutina(int id, int rutinaId) async {
    await _database!.delete('rutina_items', where: 'id = ?', whereArgs: [id]);
    await cargarItemsDeRutina(rutinaId);
  }

  Future<void> registrarSerie(
    int ejercicioGlobalId,
    double peso,
    int repes,
  ) async {
    await _database!.insert('historial', {
      'ejercicio_id': ejercicioGlobalId,
      'fecha': DateTime.now().toIso8601String(),
      'peso': peso,
      'repes_realizadas': repes,
    });
    print("Progreso guardado: $peso kg en ejercicio ID $ejercicioGlobalId");
  }

  Future<void> buscarRutinaPorDia(String dia) async {
    final maps = await _database!.query(
      'rutinas',
      where: 'dia_semana = ?',
      whereArgs: [dia],
    );
    _rutinaSeleccionada = maps.isNotEmpty ? Rutina.fromMap(maps.first) : null;
    notifyListeners();
  }

  List<HistorialSet> _historialSeleccionado = [];
  List<HistorialSet> get historialSeleccionado => _historialSeleccionado;

  Future<void> cargarHistorialDeEjercicio(int ejercicioId) async {
    if (_database == null) return;

    final maps = await _database!.query(
      'historial',
      where: 'ejercicio_id = ?',
      whereArgs: [ejercicioId],
      orderBy: 'fecha ASC', // Ordenar cronológicamente
    );

    _historialSeleccionado = List.generate(maps.length, (i) {
      return HistorialSet(
        id: maps[i]['id'] as int,
        ejercicioGlobalId: maps[i]['ejercicio_id'] as int,
        fecha: maps[i]['fecha'] as String,
        peso: maps[i]['peso'] as double,
        repesRealizadas: maps[i]['repes_realizadas'] as int,
      );
    });
    notifyListeners();
  }

  /// Duplica una rutina existente y todos sus ejercicios a otro día.
  ///
  /// [rutinaOriginalId]: ID de la rutina fuente.
  /// [nuevoDia]: Nombre del día destino (ej: "Viernes").
  Future<void> duplicarRutina(int rutinaOriginalId, String nuevoDia) async {
    if (_database == null) return;

    // Obtenemos los datos de la rutina original
    final rutinas = await _database!.query(
      'rutinas',
      where: 'id = ?',
      whereArgs: [rutinaOriginalId],
    );
    if (rutinas.isEmpty) return;

    final nombreOriginal = rutinas.first['nombre'] as String;

    // Obtenemos los ejercicios (items) de esa rutina
    final items = await _database!.query(
      'rutina_items',
      where: 'rutina_id = ?',
      whereArgs: [rutinaOriginalId],
    );

    // Creamos la NUEVA rutina (le añadimos "Copia" al nombre para diferenciar)
    final nuevoId = await _database!.insert('rutinas', {
      'nombre': "$nombreOriginal (Copia)",
      'dia_semana': nuevoDia,
    });

    // Copiamos cada ejercicio a la nueva rutina
    for (var item in items) {
      await _database!.insert('rutina_items', {
        'rutina_id': nuevoId,
        'ejercicio_id': item['ejercicio_id'],
        'nombre_cache': item['nombre_cache'],
        'series': item['series'],
        'repes': item['repes'],
      });
    }

    // Recargamos la lista para que aparezca en pantalla
    await cargarRutinas();
  }

  Future<bool> verificarSiHuboEntreno(DateTime fecha) async {
    if (_database == null) return false;

    // Convertimos la fecha a texto YYYY-MM-DD para buscarla
    // substring(0,10) coge solo la parte de la fecha, ignorando la hora
    final fechaStr = fecha.toIso8601String().substring(0, 10);

    // Buscamos si hay ALGÚN registro en el historial con esa fecha
    final resultado = await _database!.rawQuery(
      "SELECT COUNT(*) as total FROM historial WHERE fecha LIKE '$fechaStr%'",
    );

    int total = Sqflite.firstIntValue(resultado) ?? 0;
    return total > 0;
  }

  List<Map<String, dynamic>> _historialPesoCorporal = [];
  List<Map<String, dynamic>> get historialPesoCorporal =>
      _historialPesoCorporal;

  Future<void> registrarPesoCorporal(double peso) async {
    if (_database == null) return;
    await _database!.insert('peso_corporal', {
      'fecha': DateTime.now().toIso8601String(),
      'peso': peso,
    });
  }

  Future<void> cargarHistorialPesoCorporal() async {
    if (_database == null) return;
    final res = await _database!.query('peso_corporal', orderBy: 'fecha ASC');
    _historialPesoCorporal = res;
    notifyListeners();
  }
}
