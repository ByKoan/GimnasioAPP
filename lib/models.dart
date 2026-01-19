class Rutina {
  final int? id;
  final String nombre;
  final String diaSemana;

  Rutina({this.id, required this.nombre, required this.diaSemana});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'dia_semana': diaSemana};
  }

  factory Rutina.fromMap(Map<String, dynamic> map) {
    return Rutina(
      id: map['id'],
      nombre: map['nombre'],
      diaSemana: map['dia_semana'],
    );
  }
}
