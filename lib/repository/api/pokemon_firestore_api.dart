import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokemon/models/pokemon.dart';

final pokeFireStore = FirebaseFirestore.instance;

class PokemonFireStoreApi {
  CollectionReference<Map<String, dynamic>> get _pokemonsRef =>
      pokeFireStore.collection('pokemon');

  Stream<List<Pokemon>> fetchPokemonsStream() =>
      _pokemonsRef.orderBy('name').snapshots().map((snapshot) => snapshot.docs
          .map((doc) => doc.data())
          .map(Pokemon.fromJson)
          .toList());

  Future<List<Pokemon>> fetchPokemons() async {
    final pokemons = await _pokemonsRef.orderBy('name').get();
    return pokemons.docs
        .map((doc) => doc.data())
        .map(Pokemon.fromJson)
        .toList();
  }

  Future<void> addPokemon(Pokemon pokemon) async {
    await _pokemonsRef.add(pokemon.toJson());
  }

  Future<void> addPokemons(List<Pokemon> pokemons) async {
    final batch = pokeFireStore.batch();
    for (var pokemon in pokemons) {
      batch.set(
        _pokemonsRef.doc(pokemon.id.toString()),
        pokemon.toJson(),
      );
    }
    await batch.commit();
  }

  Future<void> updatePokemon(Pokemon pokemon) async {
    await pokeFireStore
        .collection('pokemons')
        .doc(pokemon.id.toString())
        .set(pokemon.toJson(), SetOptions(merge: true));
  }

  Future<void> deletePokemon(Pokemon pokemon) async {
    await pokeFireStore
        .collection('pokemons')
        .doc(pokemon.id.toString())
        .delete();
  }

  Future<void> deleteAllPokemons() async {
    final batch = pokeFireStore.batch();
    final pokemons = await _pokemonsRef.get();
    for (var pokemon in pokemons.docs) {
      batch.delete(pokemon.reference);
    }
    await batch.commit();
  }
}
