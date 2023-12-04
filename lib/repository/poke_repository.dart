import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/utils/extension/iterable_extension.dart';

import '../models/pokemon.dart';

import 'api/poke_api.dart';

class PokeRepository {
  List<Pokemon>? _pokemons;

  /// Fetches a list of [Pokemon] from the [PokeApi].
  Future<List<Pokemon>> fetchPokemons({int chunkSize = 50}) async {
    // repository should return local data if available and not expired
    if (_pokemons != null) {
      return Future.value(_pokemons!);
    }
    _pokemons = await pokeApi.fetchPokemons(chunkSize: chunkSize);
    return Future.value(_pokemons!);
  }

  Future<List<PokemonType>> fetchPokemonTypes() async {
    final pokemons = await fetchPokemons();
    final types = pokemons
        .expand((pokemon) => pokemon.types)
        .distinctBy((e) => e.name)
        .toList(growable: false)
      ..sort((a, b) => a.name.toUpperCase().compareTo(b.name.toUpperCase()));
    return types;
  }

  Future<void> addPokemon(Pokemon pokemon) async {
    pokemon.id = (_pokemons?.length ?? 0) + 1;
    _pokemons
      ?..add(pokemon)
      ..sortByName();
  }

  Future<void> updatePokemon(Pokemon pokemon) async {
    final index = _pokemons?.indexWhere((p) => p.id == pokemon.id);
    if (index != null && index >= 0) {
      _pokemons?[index] = pokemon;
    }
    _pokemons?.sortByName();
  }
}

final pokeRepository = PokeRepository();
