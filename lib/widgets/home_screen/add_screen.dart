import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/repository/poke_repository.dart';

class AddScreen extends StatefulWidget {
  final Pokemon? initialPokemon;

  const AddScreen({this.initialPokemon, super.key});

  @override
  State<StatefulWidget> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  List<PokemonType>? _allPokemonTypes;
  late Pokemon _pokemon;
  late TextEditingController _nameController;
  late TextEditingController _imageController;

  @override
  void initState() {
    _pokemon = widget.initialPokemon ?? Pokemon.empty();

    _nameController = TextEditingController(text: _pokemon.name);
    _imageController = TextEditingController(text: _pokemon.imageUrl);

    _nameController.addListener(() {
      _pokemon.name = _nameController.text;
    });
    _imageController.addListener(() {
      _pokemon.imageUrl = _imageController.text;
    });

    pokeRepository
        .fetchPokemonTypes()
        .then((value) => setState(() => _allPokemonTypes = value));

    super.initState();
  }

  _onTypeChanged(PokemonType type, bool selected) {
    if (selected) {
      _pokemon.types.add(type);
    } else {
      _pokemon.types.remove(type);
    }
    setState(() {});
  }

  _saveTapped() async {
    if (!_pokemon.isValid()) return;
    if (_pokemon.id == 0) {
      await pokeRepository.addPokemon(_pokemon);
    } else {
      await pokeRepository.updatePokemon(_pokemon);
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Pokemons')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Pokemon',
                          style: Theme.of(context).textTheme.displayLarge),
                      TextField(
                        decoration: const InputDecoration(label: Text('name')),
                        controller: _nameController,
                      ),
                      TextField(
                        decoration: const InputDecoration(label: Text('image')),
                        controller: _imageController,
                      ),
                      if (_allPokemonTypes != null) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Types',
                        ),
                        Wrap(
                          spacing: 5,
                          children: _allPokemonTypes
                                  ?.map(
                                    (type) => TypeChip(
                                      type,
                                      initialValue:
                                          _pokemon.types.contains(type),
                                      onChanged: (value) =>
                                          _onTypeChanged(type, value),
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                      ],
                      FilledButton(
                        onPressed: _pokemon.isValid() ? _saveTapped : null,
                        child: const Text('Save'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TypeChip extends StatefulWidget {
  final PokemonType _type;
  final bool initialValue;
  final Function(bool) onChanged;

  const TypeChip(
    this._type, {
    required this.onChanged,
    this.initialValue = false,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _TypeChipState();
}

class _TypeChipState extends State<TypeChip> {
  bool _isSelected = false;

  _onChange(bool value) {
    widget.onChanged(value);
    setState(() => _isSelected = value);
  }

  @override
  void initState() {
    _isSelected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      onSelected: _onChange,
      selected: _isSelected,
      label: Text(widget._type.name),
      avatar: Image.network(widget._type.imageUrl),
    );
  }
}
