// isitaperotime — Auteur : Aurélien Moote - Moo - 2026 — Licence MIT
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AperoApp(),
    ),
  );
}
