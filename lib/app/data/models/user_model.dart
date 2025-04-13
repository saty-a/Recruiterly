import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  admin,
  recruiter,
  candidate,
}

class UserModel {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.toString() == 'UserRole.${data['role'] ?? 'candidate'}',
        orElse: () => UserRole.candidate,
      ),
      profileImage: data['profileImage'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'profileImage': profileImage,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserModel copyWith({
    String? email,
    String? name,
    UserRole? role,
    String? profileImage,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
} 