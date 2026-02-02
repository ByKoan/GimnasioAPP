// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get tituloApp => 'Gym App';

  @override
  String get calendario => 'Calendar';

  @override
  String get rutinas => 'Routines';

  @override
  String get progreso => 'Progress';

  @override
  String get perfil => 'Profile';

  @override
  String get modoOscuro => 'Dark Mode';

  @override
  String get apariencia => 'Appearance';

  @override
  String get guardar => 'SAVE';

  @override
  String get peso => 'Weight (kg)';

  @override
  String get altura => 'Height (cm)';

  @override
  String get estadisticas => 'Statistics';

  @override
  String get evolucionPeso => 'Weight Evolution';

  @override
  String get progresoCargas => 'Load Progression';

  @override
  String get pesoCorporal => 'Body Weight';

  @override
  String get ejercicios => 'Exercises';

  @override
  String get eligeEjercicio => 'Choose exercise';

  @override
  String get sinDatos => 'No data';

  @override
  String semanaDel(Object diaFin, Object diaInicio) {
    return 'Week from $diaInicio to $diaFin';
  }

  @override
  String get volverHoy => 'Back to Today';

  @override
  String get descanso => 'Rest Day';

  @override
  String get sinRutina => 'No routine';

  @override
  String get planificado => 'PLANNED';

  @override
  String get entrenoCompletado => 'COMPLETED!';

  @override
  String get noRealizado => 'MISSED';

  @override
  String get verEjercicios => 'SEE EXERCISES';

  @override
  String get copiar => 'Copy';

  @override
  String get borrar => 'Delete';

  @override
  String get cancelar => 'Cancel';

  @override
  String get seguroBorrar => 'Are you sure?';

  @override
  String get advertenciaBorrar => 'This cannot be undone.';

  @override
  String get rutinaCopiada => 'Routine copied';

  @override
  String get rutinaEliminada => 'Deleted';

  @override
  String get anadirEjercicio => 'Add Exercise';

  @override
  String get nombreEjercicio => 'Exercise Name';

  @override
  String get series => 'Sets';

  @override
  String get repes => 'Reps';

  @override
  String get registrarSerie => 'Log Set';

  @override
  String get repesHechas => 'Reps done';

  @override
  String get nuevoDia => 'Choose new day';

  @override
  String get misDatos => 'My Data';

  @override
  String get datosGuardados => 'Data saved';

  @override
  String get nuevaRutina => 'New Routine';

  @override
  String get nombreRutina => 'Routine Name';

  @override
  String get seleccionaDia => 'Select Day';
}
