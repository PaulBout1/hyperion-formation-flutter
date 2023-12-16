import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_type_chip.dart';

void main() {
  group('PokemonTypeChipCubit', () {
    blocTest(
      'Toggle selected State',
      build: () => PokemonTypeChipCubit(false),
      act: (bloc) => bloc
        ..setSelected(true)
        ..setSelected(false),
      expect: () => [true, false],
    );
  });
}
