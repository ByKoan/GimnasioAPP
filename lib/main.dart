import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show
        GlobalMaterialLocalizations,
        GlobalWidgetsLocalizations,
        GlobalCupertinoLocalizations;
import 'package:gimnasioapp/l10n/app_localizations.dart';
import 'package:gimnasioapp/viewmodels/config_providers.dart';
import 'package:gimnasioapp/views/config_screen.dart';
import 'package:gimnasioapp/views/home_screen.dart';
import 'package:gimnasioapp/views/progreso_screen.dart';
import 'package:gimnasioapp/viewmodels/rutina_provider.dart';
import 'package:gimnasioapp/views/rutinas_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// --- TUS IMPORTACIONES ---
// Asegúrate de que las rutas coinciden con tus carpetas

void main() async {
  // 1. Asegurar que el motor gráfico está listo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Configuración para Windows (CRUCIAL para que no falle sqflite)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // 3. Inicializar Providers y Base de Datos
  final rutinaProvider = RutinaProvider();

  // Bloque de seguridad para arrancar aunque la BBDD falle
  print("Iniciando base de datos...");
  try {
    await rutinaProvider.initDB();
    print("Base de datos iniciada correctamente");
  } catch (e) {
    print("ERROR al iniciar BBDD: $e");
  }

  // 4. Arrancar la App
  runApp(
    MultiProvider(
      providers: [
        // Provider de Rutinas (Base de datos principal)
        ChangeNotifierProvider.value(value: rutinaProvider),

        // Provider de Tema y Configuración
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gym App',
      locale: themeProvider.locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('es'), Locale('en')],

      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueAccent,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueAccent,
        brightness: Brightness.dark,
      ),
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(themeProvider.textScale),
          ),
          child: child!,
        );
      },
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    RutinasScreen(),
    ProgresoScreen(),
    ConfigScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calendar_month),
            label: l10n.calendario,
          ),
          NavigationDestination(
            icon: const Icon(Icons.fitness_center),
            label: l10n.rutinas,
          ),
          NavigationDestination(
            icon: const Icon(Icons.show_chart),
            label: l10n.progreso,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: l10n.perfil,
          ),
        ],
      ),
    );
  }
}
