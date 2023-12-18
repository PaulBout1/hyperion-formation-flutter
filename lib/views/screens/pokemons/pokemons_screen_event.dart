import 'package:pokemon/models/pokemon.dart';

sealed class PokemonsScreenEvent {
  const PokemonsScreenEvent();
}

class PokemonsStreamRequested extends PokemonsScreenEvent {}

class PokemonsDeleted extends PokemonsScreenEvent {
  final Pokemon pokemon;

  const PokemonsDeleted(this.pokemon);
}

class PokemonsSelected extends PokemonsScreenEvent {
  final Pokemon pokemon;

  const PokemonsSelected(this.pokemon);
}

class PokemonsDeleteAll extends PokemonsScreenEvent {}

class PokemonsRestoreAll extends PokemonsScreenEvent {}
