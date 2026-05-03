import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final FlutterSecureStorage _secureStorage;

  AuthService({
    FirebaseAuth? firebaseAuth,
    FlutterSecureStorage? secureStorage,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signUp({required String email, required String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(), password: password,
    );
  }

  Future<UserCredential> signIn({required String email, required String password}) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(), password: password,
    );
  }

  Future<void> signOut() async => await _firebaseAuth.signOut();

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> storeSecurely(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecure(String key) async => await _secureStorage.read(key: key);

  Future<void> deleteSecure(String key) async => await _secureStorage.delete(key: key);
}
