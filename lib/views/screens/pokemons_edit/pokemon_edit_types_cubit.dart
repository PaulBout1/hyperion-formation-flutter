import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/repository/poke_repository.dart';

class PokemonEditTypesState extends Equatable {
  final List<PokemonType>? allTypes;
  final List<PokemonType> selectedTypes;

  const PokemonEditTypesState({
    required this.allTypes,
    required this.selectedTypes,
  });

  @override
  List<Object?> get props => [allTypes, selectedTypes];

  PokemonEditTypesState copyWith({
    List<PokemonType>? allTypes,
    List<PokemonType>? selectedTypes,
  }) {
    return PokemonEditTypesState(
      allTypes: allTypes ?? this.allTypes,
      selectedTypes: selectedTypes ?? this.selectedTypes,
    );
  }
}

class PokemonEditTypesCubit extends Cubit<PokemonEditTypesState> {
  final PokeRepository _repo;

  PokemonEditTypesCubit(
    this._repo, {
    required List<PokemonType> selectedTypes,
  }) : super(
          PokemonEditTypesState(
            allTypes: null,
            selectedTypes: selectedTypes,
          ),
        );

  void fetchAllTypes() {
    _repo.fetchPokemonTypes().then((value) {
      emit(state.copyWith(allTypes: value));
    });
  }

  void setSelected(PokemonType type, bool selected) {
    final types = List<PokemonType>.from(state.selectedTypes);
    if (selected) {
      types.add(type);
    } else {
      types.remove(type);
    }
    emit(state.copyWith(selectedTypes: types));
  }
}
