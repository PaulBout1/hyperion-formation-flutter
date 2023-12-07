import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_type.dart';

class PokeTypeWidget extends StatelessWidget {
  final PokemonType _pokemonType;

  const PokeTypeWidget(this._pokemonType, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          _pokemonType.imageUrl,
          width: 50,
          height: 50,
        ),
        Text(_pokemonType.name, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
