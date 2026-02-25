import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../cocktails/cocktails_provider.dart';
import 'settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plus'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          // Theme section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Apparence',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Mode sombre'),
            subtitle: const Text('Activer le th\u00e8me sombre'),
            secondary: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
            ),
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).setThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light,
                  );
            },
          ),
          const Divider(),
          // Actions section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Donn\u00e9es',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded),
            title: const Text('Vider les favoris'),
            subtitle: const Text('Supprimer tous les cocktails favoris'),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Vider les favoris ?'),
                  content: const Text(
                    'Cette action est irr\u00e9versible.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Annuler'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Confirmer'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                final favNotifier =
                    ref.read(favoriteCocktailsProvider.notifier);
                for (final name in ref.read(favoriteCocktailsProvider)) {
                  await favNotifier.toggle(name);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Favoris vid\u00e9s')),
                  );
                }
              }
            },
          ),
          const Divider(),
          // Contact & About
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '\u00c0 propos',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline_rounded),
            title: const Text('Contacter le d\u00e9veloppeur'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.go('/contact'),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text('Is it Ap\u00e9ro Time ?'),
            subtitle: Text('Version 2.0.0 \u2022 Aur\u00e9lien Moote'),
          ),
          ListTile(
            leading: const Icon(Icons.gavel_rounded),
            title: const Text('Licences'),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: 'Is it Ap\u00e9ro Time ?',
                applicationVersion: '2.0.0',
              );
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "L'abus d'alcool est dangereux pour la sant\u00e9.\n\u00c0 consommer avec mod\u00e9ration.",
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
