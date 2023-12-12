import 'package:flutter/material.dart';
import 'package:pokemon/views/poke_app.dart';

void main() {
  runApp(const PokeApp());
}

/// flutter create --empty --org=fr.formation --platforms=android,web --project-name pokemon .
///
/// default folders
///
/// pubspec flutter_lints
///
/// ## Widget
/// * Text / Image
/// ### Layout widget
/// * Container
/// * Padding / Center
/// * Column / Expanded / Row
/// * Flexible
/// * Stack
/// * SingleChildScrollView
/// ### Material widget
/// * Material App / Scaffold
/// * Scaffold / AppBar
/// * Scaffold / FloatingActionButton
/// * SafeArea
/// ### Widgets relatifs aux listes
/// * ListView
/// * GridView
/// * ListTile
/// * Gesture detector
/// ### Assemblage
/// * Découpage
/// * Widgets avec états (pokemon tile with heart / loading)

/// intl  :: https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization#adding-your-own-localized-messages
/// theming :: ThemeOf..
/// navigation -- https://docs.flutter.dev/ui/navigation
///   * TabBar (list/grid)
///   * push / pop (edit pokemon buttons)
///   * go router
/// snackbar
/// network image provider

/// devtools,  / debugger
///  * https://docs.flutter.dev/tools/devtools/inspector
///  * memory
///  * network 
///  * logging 
///  * performance (profile)
/// hero animation :: https://www.youtube.com/watch?v=Be9UH1kXFDw