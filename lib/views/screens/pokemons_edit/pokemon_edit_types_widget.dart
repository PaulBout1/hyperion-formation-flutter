import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_edit_types_cubit.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_type_chip.dart';

class PokemonEditTypesWidget extends StatelessWidget {
  final Pokemon? pokemon;

  const PokemonEditTypesWidget({required this.pokemon, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text('Types'),
        BlocBuilder<PokemonEditTypesCubit, PokemonEditTypesState>(
          builder: (context, state) {
            return Wrap(
              spacing: 5,
              children: state.allTypes
                      ?.map(
                        (type) => PokemonTypeChip(
                          type,
                          initialValue: pokemon?.types.contains(type) ?? false,
                          onChanged: (selected) => context
                              .read<PokemonEditTypesCubit>()
                              .setSelected(type, selected),
                        ),
                      )
                      .toList() ??
                  [],
            );
          },
        ),
      ],
    );
  }
}
