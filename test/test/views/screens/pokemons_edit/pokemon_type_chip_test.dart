import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon/models/pokemon_type.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_type_chip.dart';

import '../../../../test_ressources/app_test_widget.dart';

// https://medium.com/flutter-community/assertions-in-dart-and-flutter-tests-an-ultimate-cheat-sheet-f6d91510fe6b

void main() {
  const feu = PokemonType(
    name: 'feu',
    imageUrl:
        'https://img.freepik.com/vecteurs-libre/logo-feu-orange_78370-543.jpg',
  );

  testWidgets('chip has a text and reacts to tap', (tester) async {
    /// Build our app and trigger a frame.
    await tester.pumpWidget(
      AppTest(
        child: PokemonTypeChip(feu, initialValue: true, onChanged: (_) {}),
      ),
    );

    /// Verify that 'feu' is present.
    expect(find.text('feu'), findsOneWidget);

    /// Verifie that chip is selected (initialValue: true)
    expect(
      tester.widget(find.byType(FilterChip)),
      isA<FilterChip>().having((chip) => chip.selected, 'selected', true),
    );

    /// Tap on chip
    await tester.tap(find.byType(FilterChip));
    await tester.pumpAndSettle();

    /// Verifie that chip is not selected
    expect(
      tester.widget(find.byType(FilterChip)),
      isA<FilterChip>().having((chip) => chip.selected, 'selected', false),
    );
  });
}
