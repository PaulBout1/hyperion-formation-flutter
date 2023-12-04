import 'package:json_annotation/json_annotation.dart';

part 'pokemon_type.g.dart';

@JsonSerializable()
class PokemonType {
  
  final String name;
  
  @JsonKey(name: 'image')
  final String imageUrl;

  PokemonType({required this.name, required this.imageUrl});

  factory PokemonType.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonTypeToJson(this);
}
