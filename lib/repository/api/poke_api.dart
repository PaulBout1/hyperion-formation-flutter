import 'package:dio/dio.dart';

import 'package:pokemon/models/pokemon.dart';

class PokeApi {
  late final Dio _dio;

  PokeApi([Dio? dio]) : _dio = dio ?? Dio();

  Future<List<Pokemon>> fetchPokemons({int chunkSize = 20}) async {
    final response = await _dio.get<List<dynamic>>(
        'https://pokebuildapi.fr/api/v1/pokemon/limit/$chunkSize',);
    if (response.statusCode == 200) {
      final pokemons = response.data
          ?.cast<Map<String, dynamic>>()
          .map(Pokemon.fromJson)
          .toList()
        ?..sort((a, b) => a.name.compareTo(b.name));
      return pokemons ?? [];
    } else {
      throw Exception('Failed to fetch Pokemon');
    }
  }
}
