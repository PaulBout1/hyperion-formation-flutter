import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/utils/extension/context_extension.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_type_chip.dart';

class PokemonEditScreen extends StatefulWidget {
  final Pokemon? initialPokemon;

  const PokemonEditScreen({this.initialPokemon, super.key});

  @override
  State<StatefulWidget> createState() => _PokemonEditScreenState();
}

class _PokemonEditScreenState extends State<PokemonEditScreen> {
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
        appBar: AppBar(title: Text(context.intl.appName)),
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
                                    (type) => PokemonTypeChip(
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
