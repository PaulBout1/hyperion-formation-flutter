import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/models/pokemon_type.dart';

class PokemonTypeChipCubit extends Cubit<bool> {
  PokemonTypeChipCubit(super.initialValue);

  void setSelected(bool selected) => emit(selected);
}

class PokemonTypeChip extends StatelessWidget {
  final PokemonType _type;
  final bool initialValue;
  final void Function(bool selected) onChanged;

  const PokemonTypeChip(
    this._type, {
    required this.onChanged,
    this.initialValue = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonTypeChipCubit(initialValue),
      child: Builder(
        builder: (context) {
          return FilterChip(
            onSelected: (selected) {
              context.read<PokemonTypeChipCubit>().setSelected(selected);
              onChanged(selected);
            },
            selected: context.watch<PokemonTypeChipCubit>().state,
            label: Text(_type.name),
            avatar: CachedNetworkImage(imageUrl: _type.imageUrl),
          );
        },
      ),
    );
  }
}
