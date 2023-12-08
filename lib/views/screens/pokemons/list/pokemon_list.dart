import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/utils/extension/context_extension.dart';
import 'package:pokemon/views/widgets/dismissable.dart';
import 'package:pokemon/views/widgets/loading_widget.dart';

part '_pokemon_list_grid.dart';

class PokemonList extends StatefulWidget {
  final List<Pokemon>? _pokemons;
  final Pokemon? selectedPokemon;
  final Function(Pokemon pokemon) onTap;
  final Function(Pokemon pokemon) onDelete;

  const PokemonList(
    this._pokemons, {
    required this.selectedPokemon,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget._pokemons == null
        ? const LoadingWidget()
        : Column(
            children: [
              TabBar(
                tabs: const [
                  Tab(icon: Icon(Icons.list, size: 50)),
                  Tab(icon: Icon(Icons.grid_view, size: 50)),
                ],
                controller: _tabController,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _ListView(
                      widget._pokemons!,
                      selectedPokemon: widget.selectedPokemon,
                      onTap: widget.onTap,
                      onDelete: widget.onDelete,
                    ),
                    _GridView(
                      widget._pokemons!,
                      onTap: widget.onTap,
                      onDelete: widget.onDelete,
                    ),
                  ],
                ),
              ),
              Text(
                  context.intl.pokemonListFooter(widget._pokemons?.length ?? 0))
            ],
          );
  }
}
