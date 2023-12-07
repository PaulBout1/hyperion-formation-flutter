import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokemon/models/pokemon.dart';

final pokeFireStore = FirebaseFirestore.instance;

class PokemonFireStoreApi {
  Stream<List<Pokemon>> fetchPokemonsStream() {
    return pokeFireStore.collection('pokemons').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Pokemon.fromJson(doc.data())).toList();
    });
  }

  Future<List<Pokemon>> fetchPokemons() async {
    final pokemons = await pokeFireStore.collection('pokemons').get();
    return pokemons.docs.map((e) => Pokemon.fromJson(e.data())).toList();
  }

  Future<void> addPokemon(Pokemon pokemon) async {
    await pokeFireStore.collection('pokemons').add(pokemon.toJson());
  }

  Future<void> addPokemons(List<Pokemon> pokemons) async {
    final batch = pokeFireStore.batch();
    for (var pokemon in pokemons) {
      batch.set(
        pokeFireStore.collection('pokemons').doc(pokemon.id.toString()),
        pokemon.toJson(),
      );
    }
    await batch.commit();
  }

  Future<void> updatePokemon(Pokemon pokemon) async {
    await pokeFireStore
        .collection('pokemons')
        .doc(pokemon.id.toString())
        .update(pokemon.toJson());
  }

  Future<void> deletePokemon(Pokemon pokemon) async {
    await pokeFireStore
        .collection('pokemons')
        .doc(pokemon.id.toString())
        .delete();
  }
}
