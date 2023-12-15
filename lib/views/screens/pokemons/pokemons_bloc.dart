import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_event.dart';

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

/// events

/// bloc state
final class PokemonsState extends Equatable {
  final PokesStatusEnum status;
  final List<Pokemon>? pokemons;
  final Pokemon? selectedPokemon;

  const PokemonsState({
    this.pokemons,
    this.selectedPokemon,
    this.status = PokesStatusEnum.initial,
  });

  @override
  List<Object?> get props => [pokemons, selectedPokemon, status];

  PokemonsState copyWith({
    List<Pokemon>? pokemons,
    Pokemon? selectedPokemon,
    PokesStatusEnum? status,
  }) {
    return PokemonsState(
      pokemons: pokemons ?? this.pokemons,
      selectedPokemon: selectedPokemon ?? this.selectedPokemon,
      status: status ?? this.status,
    );
  }
}

/// bloc
class PokemonsBloc extends Bloc<PokemonsEvent, PokemonsState> {
  final PokeRepository _pokeRepo;

  StreamSubscription? _pokemonsSS;

  PokemonsBloc({required PokeRepository repo})
      : _pokeRepo = repo,
        super(const PokemonsState()) {
    on<PokemonsStreamRequested>(_handlePokemonsStreamRequested);
    on<PokemonsDeleted>(_handlePokemonDeleted);
    on<PokemonsSelected>(_handlePokemonSelected);
  }

  _handlePokemonsStreamRequested(
    PokemonsStreamRequested event,
    Emitter emit,
  ) {
    // 1st load
    emit(state.copyWith(status: PokesStatusEnum.loading));
    // listen to stream
    _pokemonsSS = _pokeRepo
        .pokeStream()
        .listen((pokes) => _handlePokemonStreamData(pokes, emit));
  }

  _handlePokemonStreamData(List<Pokemon> pokes, Emitter emit) {
    // refresh data status if needed
    final newStatus = !state.status.isLoaded ? PokesStatusEnum.loaded : null;
    Pokemon? currPokemon = state.selectedPokemon;
    Pokemon? newPokemon;
    if (currPokemon == null) {
      // if no selected pokemon, select the first one
      newPokemon = pokes.firstOrNull;
    } else if (!pokes.any((poke) => poke.id == currPokemon.id)) {
      // if selected pokemon is not in the list (removed?), select the first one
      newPokemon = pokes.firstOrNull;
    }
    // emit new state
    emit(state.copyWith(
      pokemons: pokes,
      status: newStatus,
      selectedPokemon: newPokemon,
    ));
  }

  // delete pokemon from repo
  _handlePokemonDeleted(PokemonsDeleted event, Emitter emit) =>
      _pokeRepo.deletePokemon(event.pokemon);

  _handlePokemonSelected(PokemonsSelected event, Emitter emit) {
    emit(state.copyWith(selectedPokemon: event.pokemon));
  }

  @override
  Future<void> close() {
    _pokemonsSS?.cancel();
    return super.close();
  }
}
