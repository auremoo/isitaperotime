import 'package:flutter/material.dart';

class AlcoholDisclaimer extends StatelessWidget {
  const AlcoholDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "L'abus d'alcool est dangereux pour la sant\u00e9. \u00c0 consommer avec mod\u00e9ration.",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
