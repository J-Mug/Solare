import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/router.dart';
import 'core/auth/auth_provider.dart';
import 'core/firebase/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();

  runApp(const ProviderScope(child: SolareApp()));
}

class SolareApp extends ConsumerStatefulWidget {
  const SolareApp({super.key});

  @override
  ConsumerState<SolareApp> createState() => _SolareAppState();
}

class _SolareAppState extends ConsumerState<SolareApp> {
  // Read once — GoRouter must not be recreated after creation.
  late final _router = ref.read(routerProvider);

  @override
  void initState() {
    super.initState();
    // Kick off silent sign-in; routerProvider's notifier handles redirect.
    Future.microtask(() => ref.read(authProvider.notifier).init());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Solare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
    );
  }
}
