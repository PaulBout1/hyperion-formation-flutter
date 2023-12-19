import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PokeThemeCubit extends Cubit<ThemeData> {
  PokeThemeCubit() : super(PokeTheme.themeLight);

  void switchTheme() => emit(
        state.isDark ? PokeTheme.themeLight : PokeTheme.themeDark,
      );
}

extension ThemeDataExt on ThemeData {
  bool get isDark => brightness == Brightness.dark;
}

class PokeTheme {
  const PokeTheme._();

  static final themeLight = ThemeData(
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red,
      accentColor: Colors.blueAccent.shade700,
      backgroundColor: Colors.lightBlue.shade50,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.rosario(
        fontSize: 80,
        fontWeight: FontWeight.bold,
        color: Colors.deepOrange.shade900,
      ),
    ),
    listTileTheme: ListTileThemeData(
      selectedColor: Colors.red.shade900,
      selectedTileColor: Colors.lightGreen.shade50,
    ),
  );

  static final themeDark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}
