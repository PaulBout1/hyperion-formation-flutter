// ignore_for_file: unnecessary_await_in_return

import 'package:flutter/material.dart';

class _ColorPicker extends StatelessWidget {
  const _ColorPicker();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pick a color'),
      content: SizedBox(
        height: 200,
        width: 200,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          children: [
            for (final color in Colors.primaries)
              InkWell(
                onTap: () => Navigator.of(context).pop(color),
                child: Container(
                  width: 50,
                  height: 50,
                  color: color,
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

Future<Color?> showPokeColorPicker({
  required BuildContext context,
}) async {
  return await showDialog<Color>(
    context: context,
    builder: (context) => const _ColorPicker(),
  );
}
