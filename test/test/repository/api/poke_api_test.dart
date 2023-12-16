import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/api/poke_api.dart';

import '../../../test_ressources/data/test_ressources_data.dart';

void main() {
  final mockDioPokeApi = Dio(BaseOptions());

  DioAdapter(dio: mockDioPokeApi).onGet(
    'https://pokebuildapi.fr/api/v1/pokemon/limit/0',
    (request) async =>
        request.reply(200, await TestRessourcesData.pokeApi.jsonDecode()),
  );

  group('PokeApi', () {
    late PokeApi pokeApi;

    setUpAll(() => pokeApi = PokeApi(mockDioPokeApi));

    test(
      'Should create stub for Dio',
      () {
        expectLater(
          pokeApi.fetchPokemons(chunkSize: 0),
          allOf(
            completion(isA<List<Pokemon>>()), // parsing pokemons is OK
            completion(hasLength(898)), // ask for 0 pokemons get 898 from stub
          ),
        );
      },
    );
  });
}
