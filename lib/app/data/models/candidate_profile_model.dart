import 'package:cloud_firestore/cloud_firestore.dart';

class CandidateProfileModel {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final String location;
  final String currentRole;
  final String experienceLevel;
  final List<String> skills;
  final String bio;
  final String? profileImage;
  final String? resumeUrl;
  final List<String> appliedJobs;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Additional fields for recruiter view
  final int? totalExperience;
  final int? noticePeriod;
  final double? currentCtc;
  final double? expectedCtc;

  CandidateProfileModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.location,
    required this.currentRole,
    required this.experienceLevel,
    required this.skills,
    required this.bio,
    this.profileImage,
    this.resumeUrl,
    required this.appliedJobs,
    required this.createdAt,
    required this.updatedAt,
    this.totalExperience,
    this.noticePeriod,
    this.currentCtc,
    this.expectedCtc,
  });
  
  // Getters for compatibility with the view
  String get name => fullName;

  factory CandidateProfileModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return CandidateProfileModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      location: data['location'] ?? '',
      currentRole: data['currentRole'] ?? '',
      experienceLevel: data['experienceLevel'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      bio: data['bio'] ?? '',
      profileImage: data['profileImage'],
      resumeUrl: data['resumeUrl'],
      appliedJobs: List<String>.from(data['appliedJobs'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalExperience: data['totalExperience'],
      noticePeriod: data['noticePeriod'],
      currentCtc: (data['currentCtc'] as num?)?.toDouble(),
      expectedCtc: (data['expectedCtc'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'location': location,
      'currentRole': currentRole,
      'experienceLevel': experienceLevel,
      'skills': skills,
      'bio': bio,
      'profileImage': profileImage,
      'resumeUrl': resumeUrl,
      'appliedJobs': appliedJobs,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  CandidateProfileModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    String? email,
    String? phone,
    String? location,
    String? currentRole,
    String? experienceLevel,
    List<String>? skills,
    String? bio,
    String? profileImage,
    String? resumeUrl,
    List<String>? appliedJobs,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CandidateProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      currentRole: currentRole ?? this.currentRole,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      skills: skills ?? this.skills,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      appliedJobs: appliedJobs ?? this.appliedJobs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 