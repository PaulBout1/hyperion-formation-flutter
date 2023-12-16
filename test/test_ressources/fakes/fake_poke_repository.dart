import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/poke_repository.dart';

class FakePokeRepository extends Fake implements PokeRepository {
  @override
  Future<List<Pokemon>> fetchPokemons({bool forceReload = false}) async {
    return Future.value(
      [Pokemon.fromJson(jsonDecode(bullBizarreJson) as Map<String, dynamic>)],
    );
  }
}

const bullBizarreJson = '''
{
    "id": 1,
    "pokedexId": 1,
    "name": "Bulbizarre",
    "image": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png",
    "sprite": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
    "slug": "Bulbizarre",
    "stats": {
        "HP": 45,
        "attack": 49,
        "defense": 49,
        "special_attack": 65,
        "special_defense": 65,
        "speed": 45
    },
    "apiTypes": [
        {
            "name": "Poison",
            "image": "https://static.wikia.nocookie.net/pokemongo/images/0/05/Poison.png"
        },
        {
            "name": "Plante",
            "image": "https://static.wikia.nocookie.net/pokemongo/images/c/c5/Grass.png"
        }
    ],
    "apiGeneration": 1,
    "resistanceModifyingAbilitiesForApi": [],
    "apiEvolutions": [
        {
            "name": "Herbizarre",
            "pokedexId": 2
        }
    ],
    "apiPreEvolution": "none",
    "apiResistancesWithAbilities": []
}
''';
