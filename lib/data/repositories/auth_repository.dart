import 'package:audio_player_app/data/models/app_user.dart';
import 'package:audio_player_app/services/auth_service.dart';
import 'package:audio_player_app/services/firestore_service.dart';

class AuthRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthRepository({required AuthService authService, required FirestoreService firestoreService})
      : _authService = authService, _firestoreService = firestoreService;

  Stream<bool> get authStateChanges => _authService.authStateChanges.map((user) => user != null);
  bool get isAuthenticated => _authService.currentUser != null;

  Future<AppUser> signUp({
    required String email, required String password,
    required String firstName, required String lastName,
    required DateTime dateOfBirth,
  }) async {
    final credential = await _authService.signUp(email: email, password: password);
    final user = AppUser(
      uid: credential.user!.uid, email: email, firstName: firstName,
      lastName: lastName, dateOfBirth: dateOfBirth, createdAt: DateTime.now(),
    );
    await _firestoreService.createUser(user);
    return user;
  }

  Future<AppUser> signIn({required String email, required String password}) async {
    final credential = await _authService.signIn(email: email, password: password);
    final user = await _firestoreService.getUser(credential.user!.uid);
    if (user == null) throw Exception('User data not found');
    return user;
  }

  Future<void> signOut() async => await _authService.signOut();
  Future<void> resetPassword(String email) async => await _authService.sendPasswordResetEmail(email);

  Future<AppUser?> getCurrentUser() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return null;
    return await _firestoreService.getUser(currentUser.uid);
  }
}
