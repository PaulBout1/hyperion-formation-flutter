import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/widgets/components/loading_widget.dart';

class PokemonList extends StatelessWidget {
  final List<Pokemon>? _pokemons;
  final Pokemon? _selectedPokemon;
  final Function(Pokemon pokemon) onTap;
  final Future<void> Function() onRefresh;
  final Function(Pokemon pokemon) onDismissed;

  const PokemonList(
    this._pokemons, {
    required Pokemon? selectedPokemon,
    required this.onTap,
    required this.onRefresh,
    required this.onDismissed,
    super.key,
  }) : _selectedPokemon = selectedPokemon;

  @override
  Widget build(BuildContext context) {
    return _pokemons == null
        ? const LoadingWidget()
        : RefreshIndicator(
            onRefresh: onRefresh,
            child: Scrollbar(
              child: ListView.builder(
                
                itemCount: _pokemons.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(_pokemons[index].id),
                    onDismissed: (direction) => onDismissed(_pokemons[index]),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          )),
                    ),
                    child: ListTile(
                      selected: _selectedPokemon == _pokemons[index],
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(_pokemons[index].imageUrl),
                      ),
                      title: Text(_pokemons[index].name),
                      subtitle: Text(
                          _pokemons[index].types.map((t) => t.name).join(',')),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () => onTap(_pokemons[index]),
                      ),
                      onTap: () => onTap(_pokemons[index]),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
