import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:pokemon/models/pokemon_type.dart';

part 'pokemon.g.dart';

@JsonSerializable(explicitToJson: true)
class Pokemon extends Equatable {
  final int id;

  final String name;

  @JsonKey(name: 'image')
  final String imageUrl;

  @JsonKey(name: 'apiTypes')
  final List<PokemonType> types;

  const Pokemon({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.types,
  });

  bool isValid() => name.isNotEmpty && imageUrl.isNotEmpty && types.isNotEmpty;

  factory Pokemon.empty() => const Pokemon(
        name: '',
        id: 0,
        imageUrl:
            'https://i.etsystatic.com/33357979/r/il/e1dfcd/3584257734/il_570xN.3584257734_bfy9.jpg',
        types: [],
      );

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonToJson(this);

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [id, name, imageUrl, types];

  Pokemon copyWith({
    int? id,
    String? name,
    String? imageUrl,
    List<PokemonType>? types,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      types: types ?? this.types,
    );
  }
}

extension PokemonsExtension on List<Pokemon> {
  void sortByName() {
    return sort(
      (first, second) =>
          first.name.toLowerCase().compareTo(second.name.toLowerCase()),
    );
  }
}
