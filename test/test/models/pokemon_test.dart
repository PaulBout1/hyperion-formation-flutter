import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/api/poke_api.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_bloc.dart';

import '../../test_ressources/fakes/fake_poke_repository.dart';

class MockPokeApi extends Mock implements PokeApi {}

// flutter pub add dev:test
// flutter pub add dev:mocktail
// ...
// flutter test

void main() {
  group('Pokemon model', () {
    late PokeApi pokeApi;
    late List<Pokemon> pokemons;

    setUpAll(() {
      pokeApi = MockPokeApi();
      when(() => pokeApi.fetchPokemons()).thenAnswer(
        (_) => Future.value(
          [
            Pokemon.fromJson(
              jsonDecode(bullBizarreJson) as Map<String, dynamic>,
            ),
          ],
        ),
      );
    });

    setUp(() async => pokemons = await pokeApi.fetchPokemons());

    test('should parse Bulbizarre from json', () async {
      expect(pokemons.length, 1);
      final bulbizarre = pokemons.first;
      expect(bulbizarre.id, 1);
      expect(bulbizarre.name, 'Bulbizarre');
      expect(
        bulbizarre.imageUrl,
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
      );
      expect(bulbizarre.types.length, 2);
    });

    test('should return the correct type', () {
      final bulbizarre = pokemons.first;
      expect(bulbizarre.types[0].name, 'Poison');
      expect(bulbizarre.types[1].name, 'Plante');
    });
  });

  group('Equatable in a Set must be uniq', () {
    test('double equatable model in a set is managed', () {
      final aSet = <PokemonsState>{}
        ..add(const PokemonsState())
        ..add(const PokemonsState());
      expect(aSet.length, 1);
    });

    test('double model in a set is not managed', () {
      final aSet = <Pokemon>{}
        ..add(Pokemon.empty())
        ..add(Pokemon.empty());
      expect(aSet.length, 2);
    });
  });
}

// result of https://pokebuildapi.fr/api/v1/pokemon/limit/1
