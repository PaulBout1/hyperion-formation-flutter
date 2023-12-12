import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/utils/extension/context_extension.dart';
import 'package:pokemon/views/screens/pokemons/detail/pokemon_type_widget.dart';
import 'package:pokemon/views/widgets/poke_text_button.dart';

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
                  style: context.textTheme.displayLarge,
                ),
                PokeTextButton(onPressed: () {}, child: const Text('PokeText')),
                Expanded(
                  child: Hero(
                    tag: "pokemon:${_pokemon.id}",
                    child: CachedNetworkImage(imageUrl: _pokemon.imageUrl),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Wrap(
                        children: _pokemon.types
                            .map((type) => PokeTypeWidget(type))
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
