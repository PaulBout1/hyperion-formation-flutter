import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/utils/extension/context_extension.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_edit_cubit.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_edit_types_cubit.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_edit_types_widget.dart';

enum PokemonEditScreenResult { canceled, added, updated }

class PokemonEditScreen extends StatelessWidget {
  final Pokemon? initialPokemon;

  const PokemonEditScreen({
    this.initialPokemon,
    super.key,
  });

  void onSave(BuildContext context) {
    context.read<PokemonEditCubit>().save();
    Navigator.of(context).pop(
      initialPokemon == null
          ? PokemonEditScreenResult.added
          : PokemonEditScreenResult.updated,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(context.intl.appName)),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PokemonEditCubit(
                context.read<PokeRepository>(),
                pokemon: initialPokemon,
              ),
            ),
            BlocProvider(
              create: (context) => PokemonEditTypesCubit(
                context.read<PokeRepository>(),
                selectedTypes: initialPokemon?.types ?? [],
              )..fetchAllTypes(),
            ),
          ],
          child: Builder(
            builder: (context) {
              return Row(
                children: [
                  Flexible(
                    child: Hero(
                      tag: 'pokemon:${initialPokemon?.id ?? 0}',
                      child: CachedNetworkImage(
                        imageUrl: initialPokemon?.imageUrl ??
                            Pokemon.empty().imageUrl,
                      ),
                    ),
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Flexible(
                    flex: 2,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                initialValue:
                                    context.read<PokemonEditCubit>().state.name,
                                decoration:
                                    const InputDecoration(label: Text('name')),
                                onChanged:
                                    context.read<PokemonEditCubit>().updateName,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  label: const Text('image'),
                                  contentPadding:
                                      const EdgeInsets.only(left: 5),
                                  suffixIcon: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {},
                                    icon: const Icon(Icons.download),
                                  ),
                                ),
                                initialValue: context
                                    .read<PokemonEditCubit>()
                                    .state
                                    .imageUrl,
                                onChanged: context
                                    .read<PokemonEditCubit>()
                                    .updateImageUrl,
                              ),
                              const SizedBox(height: 20),
                              BlocListener<PokemonEditTypesCubit,
                                  PokemonEditTypesState>(
                                listener: (context, state) {
                                  context
                                      .read<PokemonEditCubit>()
                                      .updateTypes(state.selectedTypes);
                                },
                                child: PokemonEditTypesWidget(
                                  pokemon: initialPokemon,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FilledButton.icon(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () => Navigator.of(context)
                                        .pop(PokemonEditScreenResult.canceled),
                                    label: const Text('cancel'),
                                  ),
                                  FilledButton.icon(
                                    icon: const Icon(Icons.save),
                                    onPressed: () => onSave(context),
                                    label: const Text('Save'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
