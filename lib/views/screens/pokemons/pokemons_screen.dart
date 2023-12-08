import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/utils/extension/context_extension.dart';
import 'package:pokemon/views/poke_theme.dart';
import 'package:pokemon/views/screens/pokemons/detail/pokemon_detail.dart';
import 'package:pokemon/views/screens/pokemons/list/pokemon_list.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_edit_screen.dart';
import 'package:pokemon/views/widgets/confirm_dialog.dart';

class PokemonsScreen extends StatefulWidget {
  const PokemonsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PokemonsScreenState();
}

class _PokemonsScreenState extends State<PokemonsScreen> {
  List<Pokemon>? _pokemons;
  Pokemon? _selectedPokemon;

  late StreamSubscription _pokemonSS;

  @override
  void initState() {
    super.initState();
    _pokemonSS = pokeRepository.pokeStream().listen(_onFirestoreStreamEvent);
  }

  @override
  void dispose() {
    _pokemonSS.cancel();
    super.dispose();
  }

  _onFirestoreStreamEvent(List<Pokemon> snapshot) {
    _pokemons = snapshot;
    _selectedPokemon ??= _pokemons?.firstOrNull;
    setState(() {});
  }

  _onTap(Pokemon pokemon) {
    setState(() => _selectedPokemon = pokemon);
  }

  _onDeletePokemon(Pokemon pokemon) async {
    _pokemons?.remove(pokemon);
    await pokeRepository.deletePokemon(pokemon);
    if (_selectedPokemon == pokemon) {
      _selectedPokemon = _pokemons?.firstOrNull;
    }
    setState(() {});
  }

  _editPokemon(BuildContext context, [Pokemon? pokemon]) async {
    // GoRouter.of(context).go('/edit', extra: pokemon);

    PokemonEditScreenResult? screenResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PokemonEditScreen(initialPokemon: pokemon),
      ),
    );

    late String message;
    switch (screenResult ?? PokemonEditScreenResult.canceled) {
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
    if (mounted && screenResult != PokemonEditScreenResult.canceled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text(message),
        ),
      );
    }

    setState(() {});
  }

  _deletePokemonList(BuildContext context) async {
    final dialogResult = await showDialog<bool>(
      context: context,
      builder: (context) => const PokeConfirmDialog(
          title: 'Delete pokemon list ?', content: 'Are you sure ?'),
    );

    if (dialogResult != true) return;

    setState(() {
      _pokemons = null;
      _selectedPokemon = null;
    });

    await pokeRepository.deleteAllPokemons();

    setState(() {
      _pokemons = [];
    });
  }

  _generatePokemonList(BuildContext context) async {
    final dialogResult = await showDialog<bool>(
      context: context,
      builder: (context) => const PokeConfirmDialog(
          title: 'Generate pokemon list ?', content: 'Are you sure ?'),
    );

    if (dialogResult != true) return;

    _selectedPokemon = null;
    _pokemons = null;
    setState(() {});
    await pokeRepository.feedFireStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: Text(context.intl.appName),
        actions: [
          IconButton(
            onPressed: () => _deletePokemonList(context),
            icon: const Icon(Icons.clear_all),
          ),
          IconButton(
            onPressed: () => _generatePokemonList(context),
            icon: const Icon(Icons.upload),
          ),
          IconButton(
            onPressed: () => _editPokemon(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Row(children: [
        Flexible(
          flex: 1,
          child: Theme(
            data: PokeTheme.themeLight,
            child: PokemonList(
              _pokemons,
              selectedPokemon: _selectedPokemon,
              onTap: _onTap,
              onDelete: _onDeletePokemon,
            ),
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
