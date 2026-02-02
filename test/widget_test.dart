<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gimnasioapp/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gimnasioapp/main.dart';
import 'package:gimnasioapp/viewmodels/rutina_provider.dart';
import 'package:gimnasioapp/viewmodels/config_providers.dart';

// Sobrescribimos las funciones que usan base de datos para que no hagan nada y no den error
class MockRutinaProvider extends RutinaProvider {
  @override
  Future<void> buscarRutinaPorDia(String dia) async {
    // Fingimos que buscamos, pero no hacemos nada.
    // Así no tocamos la variable _database que es null.
    notifyListeners();
  }

  @override
  Future<bool> verificarSiHuboEntreno(DateTime fecha) async {
    return false; // Fingimos que no hubo entreno
  }
}

void main() {
  testWidgets('La app arranca y muestra el menú inferior', (
    WidgetTester tester,
  ) async {
    // Construir la app usando el MOCK en vez del provider real
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<RutinaProvider>(
            create: (_) => MockRutinaProvider(),
          ),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('es')],
          home: MainScreen(),
        ),
      ),
    );

    // Esperar a que cargue
    await tester.pumpAndSettle();

    // Verificar que aparecen los iconos
    expect(find.byIcon(Icons.calendar_month), findsOneWidget);
    expect(find.byIcon(Icons.fitness_center), findsOneWidget);

    // Verificar la barra de navegación
    expect(find.byType(NavigationBar), findsOneWidget);
=======
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gimnasioapp/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
>>>>>>> 1f22535c640f342beccea23448d9a54fd46bd5e6
  });
}
