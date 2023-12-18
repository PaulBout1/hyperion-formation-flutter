import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/repository/poke_repository.dart';

class PokemonEditCubit extends Cubit<Pokemon> {
  final PokeRepository _repo;

  PokemonEditCubit(this._repo, {Pokemon? pokemon})
      : super(pokemon ?? Pokemon.empty());

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateImageUrl(String imageUrl) {
    emit(state.copyWith(imageUrl: imageUrl));
  }

  void updateTypes(List<PokemonType> types) {
    emit(state.copyWith(types: List.from(types)));
  }

  void save() {
    if (state.id == 0) {
      _repo.addPokemon(state);
    } else {
      _repo.updatePokemon(state);
    }
  }
}
