import 'package:flutter_test/flutter_test.dart';
import 'package:gimnasioapp/models/models.dart';

void main() {
  group('Pruebas de Modelo Rutina', () {
    test('La Rutina debe crearse correctamente desde un Map (BBDD)', () {
      //Preparar
      final datosDeLaBaseDeDatos = {
        'id': 1,
        'nombre': 'Pecho y Tríceps',
        'dia_semana': 'Lunes',
      };

      //Actuar
      final rutina = Rutina.fromMap(datosDeLaBaseDeDatos);

      //Afirmar
      expect(rutina.id, 1);
      expect(rutina.nombre, 'Pecho y Tríceps');
      expect(rutina.diaSemana, 'Lunes');
    });

    test('La Rutina debe convertirse a Map correctamente para guardar', () {
      final rutina = Rutina(nombre: 'Pierna', diaSemana: 'Viernes');
      final mapa = rutina.toMap();

      expect(mapa['nombre'], 'Pierna');
      expect(mapa['dia_semana'], 'Viernes');
    });
  });
}
