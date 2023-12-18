import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/api/pokemon_firestore_api.dart';

class FakePokeFirestoreApi extends Fake implements PokemonFireStoreApi {
  @override
  Stream<List<Pokemon>> fetchPokemonsStream() async* {
    yield [const Pokemon(id: 0, name: 'Bulbizarre', imageUrl: '', types: [])];
  }
}
