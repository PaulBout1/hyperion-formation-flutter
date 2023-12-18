import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_screen_event.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_screen_state.dart';

/// bloc
class PokemonsScreenBloc
    extends Bloc<PokemonsScreenEvent, PokemonsScreenState> {
  final PokeRepository _pokeRepo;

  StreamSubscription? _pokemonsSS;

  PokemonsScreenBloc({required PokeRepository repo})
      : _pokeRepo = repo,
        super(const PokemonsScreenState()) {
    on<PokemonsStreamRequested>(_handlePokemonsStreamRequested);
    on<PokemonsDeleted>(_handlePokemonDeleted);
    on<PokemonsSelected>(_handlePokemonSelected);
    on<PokemonsDeleteAll>(_handlePokemonDeleteAll);
    on<PokemonsRestoreAll>(_handlePokemonRestoreAll);
  }

  Future<void> _handlePokemonsStreamRequested(
    PokemonsStreamRequested event,
    Emitter emit,
  ) async {
    // 1st load
    emit(state.copyWith(status: PokesStatusEnum.loading));
    // listen to stream
    await for (final pokes in _pokeRepo.pokeStream()) {
      _handlePokemonStreamData(pokes, emit);
    }
  }

  void _handlePokemonStreamData(List<Pokemon> pokes, Emitter emit) {
    // refresh data status if needed
    final newStatus = !state.status.isLoaded ? PokesStatusEnum.loaded : null;
    final currPokemon = state.selectedPokemon;
    Pokemon? newPokemon;
    if (currPokemon == null) {
      // if no selected pokemon, select the first one
      newPokemon = pokes.firstOrNull;
    } else if (!pokes.any((poke) => poke.id == currPokemon.id)) {
      // if selected pokemon is not in the list (removed?), select the first one
      newPokemon = pokes.firstOrNull;
    }
    // emit new state
    emit(
      state.copyWith(
        pokemons: pokes,
        status: newStatus,
        selectedPokemon: newPokemon,
      ),
    );
  }

  // delete pokemon from repo
  void _handlePokemonDeleted(PokemonsDeleted event, Emitter emit) =>
      _pokeRepo.deletePokemon(event.pokemon);

  void _handlePokemonSelected(PokemonsSelected event, Emitter emit) {
    emit(state.copyWith(selectedPokemon: event.pokemon));
  }

  void _handlePokemonDeleteAll(PokemonsDeleteAll event, Emitter emit) =>
      _pokeRepo.deleteAllPokemons();

  void _handlePokemonRestoreAll(PokemonsRestoreAll event, Emitter emit) =>
      _pokeRepo.feedFireStore();

  @override
  Future<void> close() {
    _pokemonsSS?.cancel();
    return super.close();
  }
}
