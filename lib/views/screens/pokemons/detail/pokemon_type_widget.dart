import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_type.dart';

class PokeTypeWidget extends StatelessWidget {
  final PokemonType _pokemonType;

  const PokeTypeWidget(this._pokemonType, {super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: _pokemonType.imageUrl,
          width: 50,
          height: 50,
        ),
        Text(_pokemonType.name, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
