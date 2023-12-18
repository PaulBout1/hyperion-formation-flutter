import 'package:equatable/equatable.dart';
import 'package:pokemon/models/pokemon.dart';

enum PokesStatusEnum {
  initial._(),
  loading._(),
  loaded._(),
  failure._();

  const PokesStatusEnum._();

  bool get isLoading => this == PokesStatusEnum.loading;
  bool get isLoaded => this == PokesStatusEnum.loaded;
  bool get isFailure => this == PokesStatusEnum.failure;
}

/// bloc state
final class PokemonsScreenState extends Equatable {
  final PokesStatusEnum status;
  final List<Pokemon>? pokemons;
  final Pokemon? selectedPokemon;

  const PokemonsScreenState({
    this.pokemons,
    this.selectedPokemon,
    this.status = PokesStatusEnum.initial,
  });

  @override
  List<Object?> get props => [pokemons, selectedPokemon, status];

  PokemonsScreenState copyWith({
    List<Pokemon>? pokemons,
    Pokemon? selectedPokemon,
    PokesStatusEnum? status,
  }) {
    return PokemonsScreenState(
      pokemons: pokemons ?? this.pokemons,
      selectedPokemon: selectedPokemon ?? this.selectedPokemon,
      status: status ?? this.status,
    );
  }
}
