import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/utils/extension/context_extension.dart';
import 'package:pokemon/views/screens/pokemons/detail/pokemon_detail.dart';
import 'package:pokemon/views/screens/pokemons/list/pokemon_list.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_bloc.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_event.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_edit_screen.dart';

class PokemonsScreen extends StatelessWidget {
  const PokemonsScreen({super.key});

  _editPokemon(BuildContext context, [Pokemon? pokemon]) async {
    // GoRouter.of(context).go('/edit', extra: pokemon);

    // PokemonEditScreenResult? screenResult =
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PokemonEditScreen(context.read<PokeRepository>(),
            initialPokemon: pokemon),
      ),
    );
    // todo snackbar
  }

  //   late String message;
  //   switch (screenResult ?? PokemonEditScreenResult.canceled) {
  //     case PokemonEditScreenResult.canceled:
  //       message = "Cancelled";
  //       break;
  //     case PokemonEditScreenResult.added:
  //       message = "Successfully added";
  //       break;
  //     case PokemonEditScreenResult.updated:
  //       message = "Successfully updated";
  //       break;
  //   }
  //   if (mounted && screenResult != PokemonEditScreenResult.canceled) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         showCloseIcon: true,
  //         content: Text(message),
  //       ),
  //     );
  //   }

  //   setState(() {});
  // }

  // _deletePokemonList(BuildContext context) async {
  //   final dialogResult = await showPokeConfirmDialog(
  //     context: context,
  //     title: 'Delete pokemon list ?',
  //     content: 'Are you sure ?',
  //   );
  //   if (dialogResult != true) return;

  //   setState(() {
  //     _pokemons = null;
  //     _selectedPokemon = null;
  //   });

  //   await pokeRepository.deleteAllPokemons();

  //   setState(() {
  //     _pokemons = [];
  //   });
  // }

  // _generatePokemonList(BuildContext context) async {
  //   final dialogResult = await showPokeConfirmDialog(
  //     context: context,
  //     title: 'Generate pokemon list ?',
  //     content: 'Are you sure ?',
  //   );

  //   if (dialogResult != true) return;

  //   _selectedPokemon = null;
  //   _pokemons = null;
  //   setState(() {});
  //   await pokeRepository.feedFireStore();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonsBloc(repo: context.read<PokeRepository>())
        ..add(PokemonsStreamRequested()),
      child: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              leading: const Icon(Icons.home),
              title: Text(context.intl.appName),
              actions: [
                IconButton(
                  onPressed: () => throw Exception('PokeCrash'),
                  icon: const Icon(Icons.bug_report),
                ),
                IconButton(
                  onPressed: () {}, //=> _deletePokemonList(context),
                  icon: const Icon(Icons.clear_all),
                ),
                IconButton(
                  onPressed: () {}, //=> _generatePokemonList(context),
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
                child: BlocBuilder<PokemonsBloc, PokemonsState>(
                  builder: (context, state) {
                    return PokemonList(
                      state.pokemons,
                      selectedPokemon: state.selectedPokemon,
                      onTap: (pokemon) => context
                          .read<PokemonsBloc>()
                          .add(PokemonsSelected(pokemon)),
                      onDelete: (pokemon) => context
                          .read<PokemonsBloc>()
                          .add(PokemonsDeleted(pokemon)),
                    );
                  },
                ),
              ),
              const VerticalDivider(
                color: Colors.grey,
                width: 4,
                thickness: 1,
              ),
              Flexible(
                flex: 2,
                child: Builder(
                  builder: (context) => PokemonDetail(
                    context.select(
                        (PokemonsBloc bloc) => bloc.state.selectedPokemon),
                  ),
                ),
              )
            ]),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _editPokemon(
                  context, context.read<PokemonsBloc>().state.selectedPokemon),
              label: const Text('Edit'),
              icon: const Icon(Icons.edit),
            ),
          ),
        );
      }),
    );
  }
}
