import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/utils/extension/context_extension.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_type_chip.dart';

enum PokemonEditScreenResult { canceled, added, updated }

class PokemonEditScreen extends StatefulWidget {
  final PokeRepository _repo;
  final Pokemon? initialPokemon;

  const PokemonEditScreen(
    this._repo, {
    this.initialPokemon,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PokemonEditScreenState();
}

class _PokemonEditScreenState extends State<PokemonEditScreen> {
  List<PokemonType>? _allPokemonTypes;
  late Pokemon _pokemon;
  late TextEditingController _nameController;
  late TextEditingController _imgController;

  @override
  void initState() {
    _pokemon = widget.initialPokemon ?? Pokemon.empty();

    _nameController = TextEditingController(text: _pokemon.name)
      ..addListener(() => _pokemon.name = _nameController.text);
    _imgController = TextEditingController(text: _pokemon.imageUrl)
      ..addListener(() => _pokemon.imageUrl = _imgController.text);

    widget._repo
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

  _onCancel() {
    Navigator.of(context).pop(PokemonEditScreenResult.canceled);
  }

  _onSave() async {
    if (_pokemon.id == 0) {
      await widget._repo.addPokemon(_pokemon);
      if (mounted) Navigator.of(context).pop(PokemonEditScreenResult.added);
    } else {
      await widget._repo.updatePokemon(_pokemon);
      if (mounted) Navigator.of(context).pop(PokemonEditScreenResult.updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(context.intl.appName)),
        body: Row(
          children: [
            Flexible(
              child: Hero(
                tag: "pokemon:${_pokemon.id}",
                child: CachedNetworkImage(imageUrl: _pokemon.imageUrl),
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Flexible(
              flex: 2,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          decoration:
                              const InputDecoration(label: Text('name')),
                          controller: _nameController,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            label: const Text('image'),
                            contentPadding: const EdgeInsets.only(left: 5),
                            suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: const Icon(Icons.download),
                            ),
                          ),
                          controller: _imgController,
                        ),
                        if (_allPokemonTypes != null) ...[
                          const SizedBox(height: 20),
                          const Text('Types'),
                          Wrap(
                            spacing: 5,
                            children: _allPokemonTypes
                                    ?.map(
                                      (type) => PokemonTypeChip(
                                        type,
                                        initialValue: _pokemon.types
                                            .where((element) =>
                                                element.isEqual(type))
                                            .isNotEmpty,
                                        onChanged: (value) =>
                                            _onTypeChanged(type, value),
                                      ),
                                    )
                                    .toList() ??
                                [],
                          ),
                        ],
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FilledButton.icon(
                              icon: const Icon(Icons.cancel),
                              onPressed: _onCancel,
                              label: const Text('cancel'),
                            ),
                            FilledButton.icon(
                              icon: const Icon(Icons.save),
                              onPressed: _pokemon.isValid() ? _onSave : null,
                              label: const Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
