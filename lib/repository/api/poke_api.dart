import 'package:dio/dio.dart';

import '../../models/pokemon.dart';

class PokeApi {
  const PokeApi();

  Future<List<Pokemon>> fetchPokemons({int chunkSize = 1000}) async {
    final response = await Dio()
        .get<List>('https://pokebuildapi.fr/api/v1/pokemon/limit/$chunkSize');
    if (response.statusCode == 200) {
      final pokemons = response.data
          ?.cast<Map<String, dynamic>>()
          .map((json) => Pokemon.fromJson(json))
          .toList()
        ?..sort((a, b) => a.name.compareTo(b.name));
      return pokemons ?? [];
    } else {
      throw Exception('Failed to fetch Pokemon');
    }
  }
}
