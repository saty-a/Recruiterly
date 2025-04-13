import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../controllers/app_controller.dart';
import '../../../data/models/job_posting_model.dart';
import '../../../data/models/candidate_profile_model.dart';
import '../../../routes/app_pages.dart';

class CandidateController extends GetxController {
  final AppController _appController = Get.find<AppController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final searchController = TextEditingController();

  // Navigation state
  final RxInt currentIndex = 0.obs;

  RxBool isLoading = false.obs;
  RxList<JobPosting> allJobs = <JobPosting>[].obs;
  RxList<JobPosting> filteredJobs = <JobPosting>[].obs;
  RxSet<String> appliedJobs = <String>{}.obs;

  // Filter states
  RxString selectedLocation = ''.obs;
  RxString selectedJobRole = ''.obs;
  RxString selectedExperienceLevel = ''.obs;
  RxList<String> selectedSkills = <String>[].obs;

  // Available filter options
  RxList<String> availableLocations = <String>[].obs;
  RxList<String> availableJobRoles = <String>[].obs;
  RxList<String> availableExperienceLevels = <String>[].obs;
  RxList<String> availableSkills = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadJobs();
    _loadFilterOptions();
    _loadCandidateProfile();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> _loadJobs() async {
    try {
      isLoading.value = true;
      final querySnapshot = await _firestore
          .collection('job_postings')
          .where('isActive', isEqualTo: true)
          .get();

      allJobs.value = querySnapshot.docs
          .map((doc) => JobPosting.fromFirestore(doc))
          .toList();
      _applyFilters();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load jobs',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadFilterOptions() async {
    try {
      final jobRolesDoc = await _firestore.collection('predefined_lists').doc('jobRoles').get();
      if (jobRolesDoc.exists) {
        availableJobRoles.value = List<String>.from(jobRolesDoc.data()?['items'] ?? []);
      }

      final experienceLevelsDoc = await _firestore.collection('predefined_lists').doc('experienceLevels').get();
      if (experienceLevelsDoc.exists) {
        availableExperienceLevels.value = List<String>.from(experienceLevelsDoc.data()?['items'] ?? []);
      }

      final skillsDoc = await _firestore.collection('predefined_lists').doc('skills').get();
      if (skillsDoc.exists) {
        availableSkills.value = List<String>.from(skillsDoc.data()?['items'] ?? []);
      }

      // Extract unique locations from jobs
      availableLocations.value = allJobs
          .map((job) => job.location)
          .toSet()
          .toList();
    } catch (e) {
      print('Error loading filter options: $e');
    }
  }

  Future<void> _loadCandidateProfile() async {
    try {
      final userId = _appController.currentUser?.uid;
      if (userId == null) return;

      final doc = await _firestore
          .collection('candidate_profiles')
          .doc(userId)
          .get();

      if (doc.exists) {
        final profile = CandidateProfileModel.fromFirestore(doc);
        appliedJobs.value = profile.appliedJobs.toSet();
      }
    } catch (e) {
      print('Error loading candidate profile: $e');
    }
  }

  void onSearchChanged(String query) {
    _applyFilters();
  }

  void _applyFilters() {
    final searchQuery = searchController.text.toLowerCase();
    
    filteredJobs.value = allJobs.where((job) {
      final matchesSearch = searchQuery.isEmpty ||
          job.title.toLowerCase().contains(searchQuery) ||
          job.description.toLowerCase().contains(searchQuery);

      final matchesLocation = selectedLocation.isEmpty ||
          job.location == selectedLocation.value;

      final matchesJobRole = selectedJobRole.isEmpty ||
          job.employmentType == selectedJobRole.value;

      final matchesExperience = selectedExperienceLevel.isEmpty ||
          job.employmentType == selectedExperienceLevel.value;

      final matchesSkills = selectedSkills.isEmpty ||
          selectedSkills.every((skill) => job.skills.contains(skill));

      return matchesSearch &&
          matchesLocation &&
          matchesJobRole &&
          matchesExperience &&
          matchesSkills;
    }).toList();
  }

  Future<void> showFilterDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text('Filter Jobs'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedLocation.value.isEmpty ? null : selectedLocation.value,
                decoration: const InputDecoration(labelText: 'Location'),
                items: [
                  const DropdownMenuItem(value: '', child: Text('Any Location')),
                  ...availableLocations.map(
                    (location) => DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    ),
                  ),
                ],
                onChanged: (value) {
                  selectedLocation.value = value ?? '';
                  _applyFilters();
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedJobRole.value.isEmpty ? null : selectedJobRole.value,
                decoration: const InputDecoration(labelText: 'Job Role'),
                items: [
                  const DropdownMenuItem(value: '', child: Text('Any Role')),
                  ...availableJobRoles.map(
                    (role) => DropdownMenuItem(
                      value: role,
                      child: Text(role),
                    ),
                  ),
                ],
                onChanged: (value) {
                  selectedJobRole.value = value ?? '';
                  _applyFilters();
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedExperienceLevel.value.isEmpty
                    ? null
                    : selectedExperienceLevel.value,
                decoration: const InputDecoration(labelText: 'Experience Level'),
                items: [
                  const DropdownMenuItem(
                      value: '', child: Text('Any Experience')),
                  ...availableExperienceLevels.map(
                    (level) => DropdownMenuItem(
                      value: level,
                      child: Text(level),
                    ),
                  ),
                ],
                onChanged: (value) {
                  selectedExperienceLevel.value = value ?? '';
                  _applyFilters();
                },
              ),
              const SizedBox(height: 16),
              const Text('Skills'),
              Wrap(
                spacing: 8,
                children: availableSkills
                    .map(
                      (skill) => FilterChip(
                        label: Text(skill),
                        selected: selectedSkills.contains(skill),
                        onSelected: (selected) {
                          if (selected) {
                            selectedSkills.add(skill);
                          } else {
                            selectedSkills.remove(skill);
                          }
                          _applyFilters();
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              selectedLocation.value = '';
              selectedJobRole.value = '';
              selectedExperienceLevel.value = '';
              selectedSkills.clear();
              _applyFilters();
              Get.back();
            },
            child: const Text('Clear All'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void clearFilter(String filterType) {
    switch (filterType) {
      case 'location':
        selectedLocation.value = '';
        break;
      case 'jobRole':
        selectedJobRole.value = '';
        break;
      case 'experienceLevel':
        selectedExperienceLevel.value = '';
        break;
    }
    _applyFilters();
  }

  void removeSkill(String skill) {
    selectedSkills.remove(skill);
    _applyFilters();
  }

  bool isJobApplied(String jobId) {
    return appliedJobs.contains(jobId);
  }

  Future<void> applyForJob(JobPosting job) async {
    try {
      isLoading.value = true;
      final userId = _appController.currentUser?.uid;
      if (userId == null) return;

      final candidateRef = _firestore.collection('candidate_profiles').doc(userId);
      final jobApplicationRef = _firestore.collection('job_applications').doc();

      await _firestore.runTransaction((transaction) async {
        final candidateDoc = await transaction.get(candidateRef);
        
        if (!candidateDoc.exists) {
          throw 'Candidate profile not found';
        }

        final profile = CandidateProfileModel.fromFirestore(candidateDoc);
        final updatedAppliedJobs = [...profile.appliedJobs, job.id];

        transaction.update(candidateRef, {
          'appliedJobs': updatedAppliedJobs,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        transaction.set(jobApplicationRef, {
          'jobId': job.id,
          'candidateId': userId,
          'status': 'pending',
          'appliedAt': FieldValue.serverTimestamp(),
        });
      });

      appliedJobs.add(job.id);
      Get.snackbar(
        'Success',
        'Application submitted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit application',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void showJobDetails(JobPosting job) {
    Get.toNamed('/candidate/job/${job.id}');
  }

  void showProfile() {
    Get.toNamed(Routes.COMMON_CHAT, arguments: [true, _appController.currentUser?.uid, 'Profile']);
  }

  Future<void> signOut() async {
    await _appController.signOut();
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
} 