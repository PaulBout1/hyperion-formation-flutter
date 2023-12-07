part of 'pokemon_list.dart';

class _ListView extends StatelessWidget {
  final List<Pokemon> _pokemons;
  final Pokemon? selectedPokemon;
  final Function(Pokemon pokemon) onTap;
  final Function(Pokemon pokemon) onDelete;

  const _ListView(
    this._pokemons, {
    required this.selectedPokemon,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        itemCount: _pokemons.length,
        itemBuilder: (context, index) => PokeDismissible(
          key: ValueKey(_pokemons[index].id),
          onDelete: () => onDelete(_pokemons[index]),
          child: ListTile(
            selected: selectedPokemon == _pokemons[index],
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                _pokemons[index].imageUrl,
                maxHeight: 100,
                maxWidth: 100,
              ),
            ),
            title: Text(_pokemons[index].name),
            subtitle: Text(_pokemons[index].types.map((t) => t.name).join(',')),
            trailing: IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () => onTap(_pokemons[index]),
            ),
            onTap: () => onTap(_pokemons[index]),
          ),
        ),
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List<Pokemon> _pokemons;
  final Function(Pokemon pokemon) onTap;
  final Function(Pokemon pokemon) onDelete;

  const _GridView(
    this._pokemons, {
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: GridView.builder(
        itemCount: _pokemons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) => PokeDismissible(
          key: ValueKey(_pokemons[index].id),
          onDelete: () => onDelete(_pokemons[index]),
          child: GridTile(
            child: Card(
              child: InkWell(
                onTap: () => onTap(_pokemons[index]),
                child: Column(
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: _pokemons[index].imageUrl,
                        fit: BoxFit.cover,
                        memCacheHeight: 100,
                        memCacheWidth: 100,
                      ),
                    ),
                    Text(_pokemons[index].name),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
