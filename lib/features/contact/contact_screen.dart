import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/email_service.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/mylogo.png',
                  height: 100,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.local_bar_rounded,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Une question ? Une suggestion ?\nContactez le d\u00e9veloppeur !',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Name field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Votre nom ou email',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),
            // Message field
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Votre message',
                prefixIcon: Icon(Icons.message_outlined),
                alignLabelWithHint: true,
              ),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: null,
            ),
            const SizedBox(height: 24),
            // Send button
            FilledButton.icon(
              onPressed: _sendEmail,
              icon: const Icon(Icons.send_rounded),
              label: const Text('Envoyer'),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            // Buy me a coffee
            OutlinedButton.icon(
              onPressed: () {
                ref
                    .read(emailServiceProvider)
                    .openUrl('https://paypal.me/aurelienmoo');
              },
              icon: const Icon(Icons.coffee_rounded),
              label: const Text('Offrez-moi un caf\u00e9 !'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendEmail() async {
    final name = _nameController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs'),
        ),
      );
      return;
    }

    final success = await ref.read(emailServiceProvider).sendContactEmail(
          senderName: name,
          message: message,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Client mail ouvert !'
                : 'Impossible d\'ouvrir le client mail',
          ),
        ),
      );
    }
  }
}
