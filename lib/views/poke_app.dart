import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/views/poke_routes.dart';
import 'package:pokemon/views/poke_theme.dart';

class PokeApp extends StatelessWidget {
  const PokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PokeRepository(),
      child: MaterialApp.router(
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
        routerConfig: pokeRoutes,
      ),
    );
  }
}
