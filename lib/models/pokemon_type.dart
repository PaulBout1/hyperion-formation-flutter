import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pokemon_type.g.dart';

@JsonSerializable()
class PokemonType extends Equatable {
  final String name;

  @JsonKey(name: 'image')
  final String imageUrl;

  const PokemonType({required this.name, required this.imageUrl});

  factory PokemonType.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonTypeToJson(this);

  @override
  List<Object?> get props => [name, imageUrl];

  @override
  String toString() => name;

  PokemonType copyWith({
    String? name,
    String? imageUrl,
  }) {
    return PokemonType(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
