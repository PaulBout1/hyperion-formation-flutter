import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/widgets/home_screen/add_screen.dart';
import 'package:pokemon/widgets/home_screen/pokemon_detail.dart';
import 'package:pokemon/widgets/home_screen/pokemon_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pokemon>? _pokemons;
  Pokemon? _selectedPokemon;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _pokemons = null;
      _selectedPokemon = null;
    });
    final pokemons = await pokeRepository.fetchPokemons();
    setState(() {
      _pokemons = pokemons;
      _selectedPokemon = pokemons.firstOrNull;
    });
  }

  _onTap(Pokemon pokemon) {
    setState(() => _selectedPokemon = pokemon);
  }

  _onDissmissed(Pokemon pokemon) {
    _pokemons?.remove(pokemon);
    if (_selectedPokemon == pokemon) _selectedPokemon = _pokemons?.firstOrNull;
    setState(() {});
  }

  _editPokemon([Pokemon? pokemon]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddScreen(
          initialPokemon: pokemon,
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.home),
          title: const Text('Pokemons'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.sort)),
            IconButton(onPressed: _editPokemon, icon: const Icon(Icons.add)),
          ],
        ),
        body: Row(children: [
          Flexible(
            flex: 1,
            child: PokemonList(
              _pokemons,
              selectedPokemon: _selectedPokemon,
              onTap: _onTap,
              onRefresh: _fetchData,
              onDismissed: _onDissmissed,
            ),
          ),
          const VerticalDivider(
            color: Colors.grey,
            width: 4,
            thickness: 1,
          ),
          Flexible(
            flex: 2,
            child: PokemonDetail(_selectedPokemon),
          )
        ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _editPokemon(_selectedPokemon),
          label: const Text('Edit'),
          icon: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
