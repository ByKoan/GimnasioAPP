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
  });
}
