import 'package:go_router/go_router.dart';
import 'package:pokemon/models/pokemon.dart';
import 'package:pokemon/views/screens/pokemons/pokemons_screen.dart';
import 'package:pokemon/views/screens/pokemons_edit/pokemon_edit_screen.dart';

final pokeRoutes = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PokemonsScreen(),
      routes: [
        GoRoute(
          path: 'edit',
          builder: (context, state) => PokemonEditScreen(
            initialPokemon: state.extra as Pokemon?,
          ),
        ),
      ],
    ),
  ],
);
