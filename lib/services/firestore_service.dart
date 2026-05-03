import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audio_player_app/core/constants/app_constants.dart';
import 'package:audio_player_app/data/models/app_user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection(AppConstants.usersCollection);

  CollectionReference<Map<String, dynamic>> _favoritesCollection(String userId) =>
      _firestore.collection(AppConstants.usersCollection)
          .doc(userId).collection(AppConstants.favoritesCollection);

  CollectionReference<Map<String, dynamic>> _statsCollection(String userId) =>
      _firestore.collection(AppConstants.usersCollection)
          .doc(userId).collection(AppConstants.listeningStatsCollection);

  Future<void> createUser(AppUser user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return AppUser.fromMap(doc.data()!, uid);
    }
    return null;
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _usersCollection.doc(uid).update(data);
  }

  Future<void> setBiometricEnabled(String uid, bool enabled) async {
    await _usersCollection.doc(uid).update({'isBiometricEnabled': enabled});
  }

  Future<void> addFavorite(String userId, Map<String, dynamic> track) async {
    await _favoritesCollection(userId).doc(track['id'] as String).set(track);
  }

  Future<void> removeFavorite(String userId, String trackId) async {
    await _favoritesCollection(userId).doc(trackId).delete();
  }

  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    final snapshot = await _favoritesCollection(userId).get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Future<bool> isFavorite(String userId, String trackId) async {
    final doc = await _favoritesCollection(userId).doc(trackId).get();
    return doc.exists;
  }

  Stream<List<Map<String, dynamic>>> getFavoritesStream(String userId) {
    return _favoritesCollection(userId).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  Future<void> recordListening(String userId, String trackId, Duration duration) async {
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final hours = duration.inMinutes / 60.0;

    final batch = _firestore.batch();
    final statsDoc = _statsCollection(userId).doc('monthly_stats');
    final doc = await statsDoc.get();

    if (doc.exists) {
      final data = doc.data()!;
      final currentHours = (data[monthKey] as num?)?.toDouble() ?? 0.0;
      final totalSeconds = (data['totalSeconds'] as num?)?.toInt() ?? 0;

      batch.update(statsDoc, {
        monthKey: currentHours + hours,
        'totalSeconds': totalSeconds + duration.inSeconds,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      batch.set(statsDoc, {
        monthKey: hours,
        'totalSeconds': duration.inSeconds,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    batch.update(statsDoc, {'trackCounts.$trackId': FieldValue.increment(1)});
    await batch.commit();
  }

  Future<Map<String, dynamic>> getListeningStats(String userId) async {
    final doc = await _statsCollection(userId).doc('monthly_stats').get();
    return doc.data() ?? {};
  }

  Stream<Map<String, dynamic>> getListeningStatsStream(String userId) {
    return _statsCollection(userId).doc('monthly_stats').snapshots()
        .map((snapshot) => snapshot.data() ?? {});
  }
}
