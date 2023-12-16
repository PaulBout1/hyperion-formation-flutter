import 'package:flutter/material.dart';

class PokeDismissible extends StatelessWidget {
  final Widget child;
  final void Function() onDelete;

  const PokeDismissible({
    required this.onDelete,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => onDelete(),
      direction: DismissDirection.startToEnd,
      background: const ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: child,
    );
  }
}
