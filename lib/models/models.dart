/// Representa una rutina de entrenamiento asignada a un día específico.
///
/// Esta clase mapea la tabla 'rutinas' de la base de datos SQLite.
class Rutina {
  /// Identificador único en la base de datos.
  final int? id;

  /// Nombre descriptivo de la rutina (ej: "Pecho y Bíceps").
  final String nombre;

  /// Día de la semana asignado (ej: "Lunes", "Martes"...).
  final String diaSemana;

  Rutina({this.id, required this.nombre, required this.diaSemana});

  /// Convierte este objeto [Rutina] en un Map para insertar en SQLite.
  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'dia_semana': diaSemana};
  }

  /// Convierte un Map de SQLite en un objeto [Rutina].
  factory Rutina.fromMap(Map<String, dynamic> map) {
    return Rutina(
      id: map['id'],
      nombre: map['nombre'],
      diaSemana: map['dia_semana'],
    );
  }
}
