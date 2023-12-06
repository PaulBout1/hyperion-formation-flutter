import 'package:flutter/material.dart';
import 'package:pokemon/views/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
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


/// intl 
/// theming
/// navigation
/// snackbar