import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config_providers.dart';

class ConfigScreen extends StatefulWidget {
  ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  final _pesoCtrl = TextEditingController();
  final _alturaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuario = Provider.of<UsuarioProvider>(context, listen: false);
      if (usuario.peso > 0) _pesoCtrl.text = usuario.peso.toString();
      if (usuario.altura > 0) _alturaCtrl.text = usuario.altura.toString();
    });
  }

  @override
  void dispose() {
    _pesoCtrl.dispose();
    _alturaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configuración y Perfil")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Mis Datos",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _pesoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Peso (kg)",
                      prefixIcon: Icon(Icons.monitor_weight),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _alturaCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Altura (cm)",
                      prefixIcon: Icon(Icons.height),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final peso = double.tryParse(_pesoCtrl.text) ?? 0.0;
                        final altura = double.tryParse(_alturaCtrl.text) ?? 0.0;
                        context.read<UsuarioProvider>().guardarDatos(
                          peso,
                          altura,
                        );
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Datos actualizados correctamente"),
                          ),
                        );
                      },
                      child: Text("GUARDAR DATOS"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            "Apariencia",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Card(
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: Text("Modo Oscuro"),
                  subtitle: Text(
                    themeProvider.isDark ? "Activado" : "Desactivado",
                  ),
                  secondary: Icon(
                    themeProvider.isDark ? Icons.dark_mode : Icons.light_mode,
                  ),
                  value: themeProvider.isDark,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
