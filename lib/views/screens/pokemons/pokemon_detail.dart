import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/models/pokemon_type.dart';

class PokemonDetail extends StatelessWidget {
  final Pokemon? _pokemon;

  const PokemonDetail(this._pokemon, {super.key});

  @override
  Widget build(BuildContext context) {
    return _pokemon == null
        ? Container(color: Colors.grey.withAlpha(100))
        : Center(
            child: Column(
              children: [
                Text(
                  _pokemon.name,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                Expanded(child: Image.network(_pokemon.imageUrl)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Wrap(
                        children: _pokemon.types
                            .map((t) => PokeTypeWidget(t))
                            .toList(growable: false),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

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
