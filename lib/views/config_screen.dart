import 'package:flutter/material.dart';
import 'package:gimnasioapp/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../viewmodels/config_providers.dart';
import '../viewmodels/rutina_provider.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.perfil)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.misDatos,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _pesoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.peso,
                      prefixIcon: const Icon(Icons.monitor_weight),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _alturaCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.altura,
                      prefixIcon: const Icon(Icons.height),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                        if (peso > 0)
                          context.read<RutinaProvider>().registrarPesoCorporal(
                            peso,
                          );
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.datosGuardados)),
                        );
                      },
                      child: Text(l10n.guardar),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: 25),
          Text(
            l10n.apariencia,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.dark_mode, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.modoOscuro),
                          Consumer<ThemeProvider>(
                            builder: (context, provider, _) => Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: provider.isDark,
                                onChanged: (val) => provider.toggleTheme(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Consumer<ThemeProvider>(
                          builder: (context, provider, _) {
                            return DropdownButton<Locale>(
                              value: provider.locale,
                              underline: const SizedBox(),
                              icon: const Icon(Icons.language, size: 18),
                              items: const [
                                DropdownMenuItem(
                                  value: Locale('es'),
                                  child: Text(
                                    "ESPAÑOL",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: Locale('en'),
                                  child: Text(
                                    "ENGLISH",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                              onChanged: (Locale? newLocale) {
                                if (newLocale != null)
                                  provider.setLocale(newLocale);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Tamaño de texto",
                              style: TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                Icon(Icons.text_fields, size: 16),
                                SizedBox(width: 100),
                                Icon(Icons.text_fields, size: 24),
                              ],
                            ),
                          ],
                        ),
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, child) {
                            return Slider(
                              value: themeProvider.textScale,
                              min: 0.8,
                              max: 1.5,
                              divisions: 7,
                              label:
                                  "${(themeProvider.textScale * 100).round()}%",
                              onChanged: (double value) =>
                                  themeProvider.setTextScale(value),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
