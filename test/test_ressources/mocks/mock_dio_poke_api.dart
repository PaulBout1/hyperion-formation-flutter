import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:pokemon/repository/api/poke_api.dart';

import '../data/test_ressources_data.dart';

Dio _getDio() {
  final dioWithStubs = Dio(BaseOptions());

  DioAdapter(dio: dioWithStubs).onGet(
    'https://pokebuildapi.fr/api/v1/pokemon/limit/0',
    (request) async =>
        request.reply(200, await TestRessourcesData.pokeApi.jsonDecode()),
  );
  return dioWithStubs;
}

class MockDioPokeApi extends PokeApi {
  MockDioPokeApi() : super(_getDio());
}
