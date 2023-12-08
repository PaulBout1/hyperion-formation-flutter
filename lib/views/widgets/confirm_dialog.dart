import 'package:flutter/material.dart';

class _PokeConfirmDialog extends StatelessWidget {
  final String title;
  final String content;

  const _PokeConfirmDialog({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
      ],
    );
  }
}

Future<bool?> showPokeConfirmDialog({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => _PokeConfirmDialog(
      title: title,
      content: content,
    ),
  );
}
