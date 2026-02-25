import 'package:flutter/material.dart';

class CocktailSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const CocktailSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Rechercher un cocktail...',
        border: InputBorder.none,
        filled: false,
      ),
      style: const TextStyle(fontSize: 18, color: Colors.white),
      onChanged: onChanged,
    );
  }
}
