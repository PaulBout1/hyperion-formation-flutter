import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/utils/extension/context_extension.dart';
import 'package:pokemon/views/poke_theme.dart';
import 'package:pokemon/views/screens/pokemons/detail/pokemon_detail.dart';
import 'package:pokemon/views/screens/pokemons/list/pokemon_list.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_screen_bloc.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_screen_event.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_screen_state.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_edit_screen.dart';
import 'package:pokemon/views/widgets/confirm_dialog.dart';

class PokemonsScreen extends StatelessWidget {
  const PokemonsScreen({super.key});

  Future<void> _editPokemon(BuildContext context, [Pokemon? pokemon]) async {
    // GoRouter.of(context).go('/edit', extra: pokemon);

    final screenResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PokemonEditScreen(initialPokemon: pokemon),
      ),
    );

    late String message;
    switch (screenResult ?? PokemonEditScreenResult.canceled) {
      case PokemonEditScreenResult.canceled:
        message = 'Cancelled';
      case PokemonEditScreenResult.added:
        message = 'Successfully added';
      case PokemonEditScreenResult.updated:
        message = 'Successfully updated';
    }
    if (context.mounted && screenResult != PokemonEditScreenResult.canceled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text(message),
        ),
      );
    }
  }

  Future<void> _deletePokemonList(BuildContext context) async {
    final dialogResult = await showPokeConfirmDialog(
      context: context,
      title: 'Delete pokemon list ?',
      content: 'Are you sure ?',
    );
    if (dialogResult != true) return;

    if (context.mounted) {
      context.read<PokemonsScreenBloc>().add(PokemonsDeleteAll());
    }
  }

  Future<void> _generatePokemonList(BuildContext context) async {
    final dialogResult = await showPokeConfirmDialog(
      context: context,
      title: 'Generate pokemon list ?',
      content: 'Are you sure ?',
    );

    if (dialogResult != true) return;

    if (context.mounted) {
      context.read<PokemonsScreenBloc>().add(PokemonsRestoreAll());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PokemonsScreenBloc(repo: context.read<PokeRepository>())
            ..add(PokemonsStreamRequested()),
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: const Icon(Icons.home),
                title: Text(context.intl.appName),
                actions: [
                  Builder(
                    builder: (context) => IconButton(
                      onPressed: context.read<PokeThemeCubit>().switchTheme,
                      icon: context.watch<PokeThemeCubit>().state.isDark
                          ? const Icon(Icons.light_mode)
                          : const Icon(Icons.dark_mode),
                    ),
                  ),
                  IconButton(
                    onPressed: () => throw Exception('PokeCrash'),
                    icon: const Icon(Icons.bug_report),
                  ),
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
              body: Row(
                children: [
                  Flexible(
                    child: BlocBuilder<PokemonsScreenBloc, PokemonsScreenState>(
                      builder: (context, state) {
                        return PokemonList(
                          state.pokemons,
                          selectedPokemon: state.selectedPokemon,
                          onTap: (pokemon) => context
                              .read<PokemonsScreenBloc>()
                              .add(PokemonsSelected(pokemon)),
                          onDelete: (pokemon) => context
                              .read<PokemonsScreenBloc>()
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
                          (PokemonsScreenBloc bloc) =>
                              bloc.state.selectedPokemon,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => _editPokemon(
                  context,
                  context.read<PokemonsScreenBloc>().state.selectedPokemon,
                ),
                label: const Text('Edit'),
                icon: const Icon(Icons.edit),
              ),
            ),
          );
        },
      ),
    );
  }
}
