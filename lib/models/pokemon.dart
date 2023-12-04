import 'package:json_annotation/json_annotation.dart';

import 'pokemon_type.dart';

part 'pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  int id;

  String name;

  @JsonKey(name: 'image')
  String imageUrl;

  @JsonKey(name: 'apiTypes')
  final List<PokemonType> types;

  Pokemon({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.types,
  });

  bool isValid() => name.isNotEmpty && imageUrl.isNotEmpty && types.isNotEmpty;

  factory Pokemon.empty() => Pokemon(
        name: '',
        id: 0,
        imageUrl: 'https://i.etsystatic.com/33357979/r/il/e1dfcd/3584257734/il_570xN.3584257734_bfy9.jpg',
        types: [],
      );

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonToJson(this);

  @override
  String toString() {
    return '${name.padRight(15)} | [${types.map((t) => t.name).join(',')}]';
  }
}

extension PokemonsExtension on List<Pokemon> {
  void sortByName() {
    return sort((first, second) =>
        first.name.toLowerCase().compareTo(second.name.toLowerCase()));
  }
}
