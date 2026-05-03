import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final DateTime createdAt;
  final bool isBiometricEnabled;

  AppUser({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.createdAt,
    this.isBiometricEnabled = false,
  });

  String get fullName => '$firstName $lastName';

  int get age {
    final now = DateTime.now();
    return now.year - dateOfBirth.year -
        ((now.month < dateOfBirth.month ||
                (now.month == dateOfBirth.month && now.day < dateOfBirth.day))
            ? 1
            : 0);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'createdAt': Timestamp.fromDate(createdAt),
      'isBiometricEnabled': isBiometricEnabled,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isBiometricEnabled: map['isBiometricEnabled'] ?? false,
    );
  }

  AppUser copyWith({
    String? uid, String? email, String? firstName, String? lastName,
    DateTime? dateOfBirth, DateTime? createdAt, bool? isBiometricEnabled,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}
