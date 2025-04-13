import 'package:cloud_firestore/cloud_firestore.dart';

class JobPosting {
  final String id;
  final String title;
  final String company;
  final String description;
  final String location;
  final String recruiterId;
  final List<String> requirements;
  final List<String> skills;
  final String employmentType;
  final String salaryRange;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  
  // Additional fields for candidate view
  final String? companyLogo;
  final String? companyDisplayName;
  final int? experienceRequired;

  JobPosting({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.location,
    required this.recruiterId,
    required this.requirements,
    required this.skills,
    required this.employmentType,
    required this.salaryRange,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    this.companyLogo,
    this.companyDisplayName,
    this.experienceRequired,
  });
  
  // Getters for compatibility with the view
  String get companyName => companyDisplayName ?? company;

  factory JobPosting.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JobPosting(
      id: doc.id,
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      recruiterId: data['recruiterId'] ?? '',
      requirements: List<String>.from(data['requirements'] ?? []),
      skills: List<String>.from(data['skills'] ?? []),
      employmentType: data['employmentType'] ?? '',
      salaryRange: data['salaryRange'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
      companyLogo: data['companyLogo'],
      companyDisplayName: data['companyName'],
      experienceRequired: data['experienceRequired'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'description': description,
      'location': location,
      'recruiterId': recruiterId,
      'requirements': requirements,
      'skills': skills,
      'employmentType': employmentType,
      'salaryRange': salaryRange,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  JobPosting copyWith({
    String? title,
    String? company,
    String? description,
    String? location,
    String? recruiterId,
    List<String>? requirements,
    List<String>? skills,
    String? employmentType,
    String? salaryRange,
    bool? isActive,
  }) {
    return JobPosting(
      id: id,
      title: title ?? this.title,
      company: company ?? this.company,
      description: description ?? this.description,
      location: location ?? this.location,
      recruiterId: recruiterId ?? this.recruiterId,
      requirements: requirements ?? this.requirements,
      skills: skills ?? this.skills,
      employmentType: employmentType ?? this.employmentType,
      salaryRange: salaryRange ?? this.salaryRange,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isActive: isActive ?? this.isActive,
    );
  }
} 