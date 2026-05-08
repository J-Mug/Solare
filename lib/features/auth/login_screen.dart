import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Listen for state changes to navigate
    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go('/projects');
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Solare',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontFamily: 'Playfair Display',
              ),
            ),
            const SizedBox(height: 40),
            if (authState.status == AuthStatus.loading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: () => ref.read(authProvider.notifier).login(),
                icon: const Icon(Icons.login),
                label: const Text('Google로 시작하기'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            if (authState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  authState.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
