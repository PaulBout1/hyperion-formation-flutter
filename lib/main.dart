// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pokemon/widgets/home_screen/home_screen.dart';

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

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: /*HomeScreen()*/ Center(child: Text('Hello World')),
      ),
    );
  }
}

class PokeListView extends StatelessWidget {
  const PokeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.withAlpha(100),
      child: ListView(
        reverse: false,
        scrollDirection: Axis.vertical,
        children: const [
          Text('pikachu 1'),
          Text('pikachu 2'),
        ], // List.generate(50, (index) => Text('Pokemon $index')),
      ),
    );
  }
}

class PokeGridView extends StatelessWidget {
  const PokeGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(
        50,
        (index) => Card(
          child: Column(
            children: [
              Image.network(
                  'https://www.pokepedia.fr/images/thumb/7/76/Pikachu-DEPS.png/800px-Pikachu-DEPS.png')
            ],
          ),
        ),
      ),
    );
  }
}

class PokeListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            'https://www.pokepedia.fr/images/thumb/7/76/Pikachu-DEPS.png/800px-Pikachu-DEPS.png'),
      ),
      title: Text('Pikachu'),
      subtitle: Text('Electric'),
      trailing: IconButton(
        icon: Icon(Icons.favorite_border),
        onPressed: () {},
      ),
    );
  }
}

class PokeListTileStateFullWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PokeListTileStateFullWidgetState();
}

class _PokeListTileStateFullWidgetState
    extends State<PokeListTileStateFullWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
