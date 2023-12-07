import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/utils/extension/context_extension.dart';
import 'package:pokemon/views/screens/pokemons/detail/pokemon_detail.dart';
import 'package:pokemon/views/screens/pokemons/list/pokemon_list.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_edit_screen.dart';

class PokemonsScreen extends StatefulWidget {
  const PokemonsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PokemonsScreenState();
}

class _PokemonsScreenState extends State<PokemonsScreen> {
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

  _onDeletePokemon(Pokemon pokemon) {
    _pokemons?.remove(pokemon);
    if (_selectedPokemon == pokemon) _selectedPokemon = _pokemons?.firstOrNull;
    setState(() {});
  }

  _editPokemon(BuildContext context, [Pokemon? pokemon]) async {
    // GoRouter.of(context).go('/edit', extra: pokemon);

    PokemonEditScreenResult screenResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PokemonEditScreen(initialPokemon: pokemon),
      ),
    );

    late String message;
    switch (screenResult) {
      case PokemonEditScreenResult.canceled:
        message = "Cancelled";
        break;
      case PokemonEditScreenResult.added:
        message = "Successfully added";
        break;
      case PokemonEditScreenResult.updated:
        message = "Successfully updated";
        break;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text(message),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: Text(context.intl.appName),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () => _editPokemon(context),
              icon: const Icon(Icons.add)),
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
            onDelete: _onDeletePokemon,
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
        onPressed: () => _editPokemon(context, _selectedPokemon),
        label: const Text('Edit'),
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
