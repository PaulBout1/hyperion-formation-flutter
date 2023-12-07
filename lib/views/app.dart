import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemon/views/poke_theme.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      theme: PokeTheme.themeLight,
      darkTheme: PokeTheme.themeDark,
      themeMode: ThemeMode.light,
      home: const SafeArea(child: PokemonsScreen()),
    );
  }
}
