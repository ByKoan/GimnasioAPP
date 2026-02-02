import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @tituloApp.
  ///
  /// In es, this message translates to:
  /// **'Gym App'**
  String get tituloApp;

  /// No description provided for @calendario.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get calendario;

  /// No description provided for @rutinas.
  ///
  /// In es, this message translates to:
  /// **'Rutinas'**
  String get rutinas;

  /// No description provided for @progreso.
  ///
  /// In es, this message translates to:
  /// **'Progreso'**
  String get progreso;

  /// No description provided for @perfil.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get perfil;

  /// No description provided for @modoOscuro.
  ///
  /// In es, this message translates to:
  /// **'Modo Oscuro'**
  String get modoOscuro;

  /// No description provided for @apariencia.
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get apariencia;

  /// No description provided for @guardar.
  ///
  /// In es, this message translates to:
  /// **'GUARDAR'**
  String get guardar;

  /// No description provided for @peso.
  ///
  /// In es, this message translates to:
  /// **'Peso (kg)'**
  String get peso;

  /// No description provided for @altura.
  ///
  /// In es, this message translates to:
  /// **'Altura (cm)'**
  String get altura;

  /// No description provided for @estadisticas.
  ///
  /// In es, this message translates to:
  /// **'Estadísticas'**
  String get estadisticas;

  /// No description provided for @evolucionPeso.
  ///
  /// In es, this message translates to:
  /// **'Evolución de Peso'**
  String get evolucionPeso;

  /// No description provided for @progresoCargas.
  ///
  /// In es, this message translates to:
  /// **'Progresión de Cargas'**
  String get progresoCargas;

  /// No description provided for @pesoCorporal.
  ///
  /// In es, this message translates to:
  /// **'Peso Corporal'**
  String get pesoCorporal;

  /// No description provided for @ejercicios.
  ///
  /// In es, this message translates to:
  /// **'Ejercicios'**
  String get ejercicios;

  /// No description provided for @eligeEjercicio.
  ///
  /// In es, this message translates to:
  /// **'Elige ejercicio'**
  String get eligeEjercicio;

  /// No description provided for @sinDatos.
  ///
  /// In es, this message translates to:
  /// **'Sin datos registrados'**
  String get sinDatos;

  /// No description provided for @semanaDel.
  ///
  /// In es, this message translates to:
  /// **'Semana del {diaInicio} al {diaFin}'**
  String semanaDel(Object diaFin, Object diaInicio);

  /// No description provided for @volverHoy.
  ///
  /// In es, this message translates to:
  /// **'Volver a hoy'**
  String get volverHoy;

  /// No description provided for @descanso.
  ///
  /// In es, this message translates to:
  /// **'Descanso'**
  String get descanso;

  /// No description provided for @sinRutina.
  ///
  /// In es, this message translates to:
  /// **'No hay rutina'**
  String get sinRutina;

  /// No description provided for @planificado.
  ///
  /// In es, this message translates to:
  /// **'PLANIFICADO'**
  String get planificado;

  /// No description provided for @entrenoCompletado.
  ///
  /// In es, this message translates to:
  /// **'¡COMPLETADO!'**
  String get entrenoCompletado;

  /// No description provided for @noRealizado.
  ///
  /// In es, this message translates to:
  /// **'NO REALIZADO'**
  String get noRealizado;

  /// No description provided for @verEjercicios.
  ///
  /// In es, this message translates to:
  /// **'VER EJERCICIOS'**
  String get verEjercicios;

  /// No description provided for @copiar.
  ///
  /// In es, this message translates to:
  /// **'Copiar'**
  String get copiar;

  /// No description provided for @borrar.
  ///
  /// In es, this message translates to:
  /// **'Borrar'**
  String get borrar;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @seguroBorrar.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro?'**
  String get seguroBorrar;

  /// No description provided for @advertenciaBorrar.
  ///
  /// In es, this message translates to:
  /// **'Esto no se puede deshacer.'**
  String get advertenciaBorrar;

  /// No description provided for @rutinaCopiada.
  ///
  /// In es, this message translates to:
  /// **'Rutina copiada'**
  String get rutinaCopiada;

  /// No description provided for @rutinaEliminada.
  ///
  /// In es, this message translates to:
  /// **'Eliminada'**
  String get rutinaEliminada;

  /// No description provided for @anadirEjercicio.
  ///
  /// In es, this message translates to:
  /// **'Añadir Ejercicio'**
  String get anadirEjercicio;

  /// No description provided for @nombreEjercicio.
  ///
  /// In es, this message translates to:
  /// **'Nombre Ejercicio'**
  String get nombreEjercicio;

  /// No description provided for @series.
  ///
  /// In es, this message translates to:
  /// **'Series'**
  String get series;

  /// No description provided for @repes.
  ///
  /// In es, this message translates to:
  /// **'Repeticiones'**
  String get repes;

  /// No description provided for @registrarSerie.
  ///
  /// In es, this message translates to:
  /// **'Registrar Serie'**
  String get registrarSerie;

  /// No description provided for @repesHechas.
  ///
  /// In es, this message translates to:
  /// **'Repes hechas'**
  String get repesHechas;

  /// No description provided for @nuevoDia.
  ///
  /// In es, this message translates to:
  /// **'Elige el nuevo día'**
  String get nuevoDia;

  /// No description provided for @misDatos.
  ///
  /// In es, this message translates to:
  /// **'Mis Datos'**
  String get misDatos;

  /// No description provided for @datosGuardados.
  ///
  /// In es, this message translates to:
  /// **'Datos guardados'**
  String get datosGuardados;

  /// No description provided for @nuevaRutina.
  ///
  /// In es, this message translates to:
  /// **'Nueva Rutina'**
  String get nuevaRutina;

  /// No description provided for @nombreRutina.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la rutina'**
  String get nombreRutina;

  /// No description provided for @seleccionaDia.
  ///
  /// In es, this message translates to:
  /// **'Selecciona el día'**
  String get seleccionaDia;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
