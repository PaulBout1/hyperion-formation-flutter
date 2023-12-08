import 'package:flutter/material.dart';

class PokeDismissible extends StatelessWidget {
  final Widget child;
  final Function() onDelete;

  const PokeDismissible({
    super.key,
    required this.onDelete,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => onDelete(),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: child,
    );
  }
}
