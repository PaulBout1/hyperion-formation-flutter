import 'package:flutter/material.dart';
import 'package:pokemon/models/pokemon_type.dart';

class PokemonTypeChip extends StatefulWidget {
  final PokemonType _type;
  final bool initialValue;
  final Function(bool) onChanged;

  const PokemonTypeChip(
    this._type, {
    required this.onChanged,
    this.initialValue = false,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _PokemonTypeChipState();
}

class _PokemonTypeChipState extends State<PokemonTypeChip> {
  bool _isSelected = false;

  _onChange(bool value) {
    widget.onChanged(value);
    setState(() => _isSelected = value);
  }

  @override
  void initState() {
    _isSelected = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      onSelected: _onChange,
      selected: _isSelected,
      label: Text(widget._type.name),
      avatar: Image.network(widget._type.imageUrl),
    );
  }
}
