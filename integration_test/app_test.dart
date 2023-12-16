import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pokemon/repository/poke_repository.dart';
import 'package:pokemon/views/poke_app.dart';

import '../test/test/models/pokemon_test.dart';
import '../test/test_ressources/fakes/fake_poke_firestore_api.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final repository = PokeRepository(
    api: MockPokeApi(),
    fireStore: FakePokeFirestoreApi(),
  );

  group('end-to-end test', () {
    testWidgets('app', (tester) async {
      await tester.pumpWidget(PokeApp(repository: repository));

      expect(find.byType(FloatingActionButton), findsOneWidget);
      // await tester.tap(find.byType(FloatingActionButton));
      // await tester.pumpAndSettle();
    });
  });
}
