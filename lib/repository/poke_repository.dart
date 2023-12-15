import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/repository/api/pokemon_firestore_api.dart';
import 'package:pokemon/utils/extension/iterable_extension.dart';

import '../models/pokemon.dart';

import 'api/poke_api.dart';

class PokeRepository {
  final _pokeApi = const PokeApi();
  final _pokeFireStore = PokemonFireStoreApi();

  List<Pokemon>? _pokemons;

  Future<void> feedFireStore() async {
    _pokemons = await _pokeApi.fetchPokemons();
    await _pokeFireStore.addPokemons(_pokemons!);
  }

  Stream<List<Pokemon>> pokeStream() {
    return _pokeFireStore.fetchPokemonsStream();
  }

  /// Fetches a list of [Pokemon] from the [_pokeApi].
  Future<List<Pokemon>> fetchPokemons({bool forceReload = false}) async {
    // repository should return local data if available and not expired
    if (_pokemons != null && !forceReload) {
      return Future.value(_pokemons!);
    }
    _pokemons = await _pokeFireStore.fetchPokemons();
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
    await _pokeFireStore.addPokemon(pokemon);
    pokemon.id = (_pokemons?.length ?? 0) + 1;
    _pokemons
      ?..add(pokemon)
      ..sortByName();
  }

  Future<void> updatePokemon(Pokemon pokemon) async {
    await _pokeFireStore.updatePokemon(pokemon);
    final index = _pokemons?.indexWhere((p) => p.id == pokemon.id);
    if (index != null && index >= 0) {
      _pokemons?[index] = pokemon;
    }
    _pokemons?.sortByName();
  }

  Future<void> deletePokemon(Pokemon pokemon) async {
    await _pokeFireStore.deletePokemon(pokemon);
    _pokemons?.removeWhere((p) => p.id == pokemon.id);
  }

  Future<void> deleteAllPokemons() async {
    await _pokeFireStore.deleteAllPokemons();
    _pokemons?.clear();
  }
}
