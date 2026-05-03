import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'package:audio_player_app/core/theme/app_theme.dart';
import 'package:audio_player_app/core/router/app_router.dart';
import 'package:audio_player_app/services/auth_service.dart';
import 'package:audio_player_app/services/biometric_service.dart';
import 'package:audio_player_app/services/audio_service.dart';
import 'package:audio_player_app/services/firestore_service.dart';
import 'package:audio_player_app/services/local_storage_service.dart';
import 'package:audio_player_app/data/repositories/auth_repository.dart';
import 'package:audio_player_app/data/repositories/audio_repository.dart';
import 'package:audio_player_app/data/repositories/favorites_repository.dart';
import 'package:audio_player_app/data/repositories/user_repository.dart';
import 'package:audio_player_app/data/remote/quran_api_client.dart';
import 'package:audio_player_app/providers/auth_provider.dart';
import 'package:audio_player_app/providers/audio_provider.dart';
import 'package:audio_player_app/providers/user_provider.dart';
import 'package:audio_player_app/providers/favorites_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localStorage = await LocalStorageService.getInstance();
  final audioService = AudioServiceHandler();
  await audioService.init();

  final authService = AuthService();
  final firestoreService = FirestoreService();
  final biometricService = BiometricService();
  final quranApiClient = QuranApiClient();

  final authRepository = AuthRepository(authService: authService, firestoreService: firestoreService);
  final audioRepository = AudioRepository(apiClient: quranApiClient);
  final favoritesRepository = FavoritesRepository(firestoreService: firestoreService);
  final userRepository = UserRepository(firestoreService: firestoreService, localStorage: localStorage);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider(authRepository: authRepository, biometricService: biometricService, localStorage: localStorage)),
    ChangeNotifierProvider(create: (_) => AudioProvider(audioRepository: audioRepository, audioService: audioService)),
    ChangeNotifierProvider(create: (_) => UserProvider(userRepository: userRepository, monthlyGoalHours: localStorage.monthlyGoalHours)),
    ChangeNotifierProvider(create: (_) => FavoritesProvider(favoritesRepository: favoritesRepository)),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Audio Player',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
