import 'package:pokemon/models/pokemon.dart';

sealed class PokemonsEvent {
  const PokemonsEvent();
}

class PokemonsStreamRequested extends PokemonsEvent {}

class PokemonsDeleted extends PokemonsEvent {
  final Pokemon pokemon;

  const PokemonsDeleted(this.pokemon);
}

class PokemonsSelected extends PokemonsEvent {
  final Pokemon pokemon;

  const PokemonsSelected(this.pokemon);
}
