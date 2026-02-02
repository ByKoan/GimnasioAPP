// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get tituloApp => 'Gym App';

  @override
  String get calendario => 'Calendario';

  @override
  String get rutinas => 'Rutinas';

  @override
  String get progreso => 'Progreso';

  @override
  String get perfil => 'Perfil';

  @override
  String get modoOscuro => 'Modo Oscuro';

  @override
  String get apariencia => 'Apariencia';

  @override
  String get guardar => 'GUARDAR';

  @override
  String get peso => 'Peso (kg)';

  @override
  String get altura => 'Altura (cm)';

  @override
  String get estadisticas => 'Estadísticas';

  @override
  String get evolucionPeso => 'Evolución de Peso';

  @override
  String get progresoCargas => 'Progresión de Cargas';

  @override
  String get pesoCorporal => 'Peso Corporal';

  @override
  String get ejercicios => 'Ejercicios';

  @override
  String get eligeEjercicio => 'Elige ejercicio';

  @override
  String get sinDatos => 'Sin datos registrados';

  @override
  String semanaDel(Object diaFin, Object diaInicio) {
    return 'Semana del $diaInicio al $diaFin';
  }

  @override
  String get volverHoy => 'Volver a hoy';

  @override
  String get descanso => 'Descanso';

  @override
  String get sinRutina => 'No hay rutina';

  @override
  String get planificado => 'PLANIFICADO';

  @override
  String get entrenoCompletado => '¡COMPLETADO!';

  @override
  String get noRealizado => 'NO REALIZADO';

  @override
  String get verEjercicios => 'VER EJERCICIOS';

  @override
  String get copiar => 'Copiar';

  @override
  String get borrar => 'Borrar';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get seguroBorrar => '¿Estás seguro?';

  @override
  String get advertenciaBorrar => 'Esto no se puede deshacer.';

  @override
  String get rutinaCopiada => 'Rutina copiada';

  @override
  String get rutinaEliminada => 'Eliminada';

  @override
  String get anadirEjercicio => 'Añadir Ejercicio';

  @override
  String get nombreEjercicio => 'Nombre Ejercicio';

  @override
  String get series => 'Series';

  @override
  String get repes => 'Repeticiones';

  @override
  String get registrarSerie => 'Registrar Serie';

  @override
  String get repesHechas => 'Repes hechas';

  @override
  String get nuevoDia => 'Elige el nuevo día';

  @override
  String get misDatos => 'Mis Datos';

  @override
  String get datosGuardados => 'Datos guardados';

  @override
  String get nuevaRutina => 'Nueva Rutina';

  @override
  String get nombreRutina => 'Nombre de la rutina';

  @override
  String get seleccionaDia => 'Selecciona el día';
}
