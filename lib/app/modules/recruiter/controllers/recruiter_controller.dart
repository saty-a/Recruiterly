import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../controllers/app_controller.dart';
import '../../../data/models/job_posting_model.dart';
import '../../../data/models/candidate_profile_model.dart';
import '../../../services/job_posting_service.dart';

class RecruiterController extends GetxController {
  final JobPostingService _jobPostingService = Get.find<JobPostingService>();
  final AppController _appController = Get.find<AppController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<JobPosting> get jobPostings => _jobPostingService.jobPostings;
  RxBool get isLoading => _jobPostingService.isLoading;
  
  // Navigation state
  final RxInt currentIndex = 0.obs;
  
  // Candidates list
  final RxList<CandidateProfileModel> candidates = <CandidateProfileModel>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadJobPostings();
    loadCandidates();
  }
  
  void changePage(int index) {
    currentIndex.value = index;
  }

  Future<void> loadJobPostings() async {
    await _jobPostingService.loadJobPostings(
      recruiterId: _appController.currentUser?.uid,
    );
  }
  
  Future<void> loadCandidates() async {
    try {
      isLoading.value = true;
      final querySnapshot = await _firestore.collection('candidate_profiles').get();
      
      candidates.value = querySnapshot.docs
          .map((doc) => CandidateProfileModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error loading candidates: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void showCandidateDetails(CandidateProfileModel candidate) {
    // Show candidate details dialog or navigate to details page
    Get.dialog(
      AlertDialog(
        title: Text(candidate.name ?? 'Candidate Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Role: ${candidate.currentRole ?? 'Not specified'}'),
              Text('Experience: ${candidate.totalExperience ?? 0} years'),
              Text('Notice Period: ${candidate.noticePeriod ?? 0} days'),
              Text('Current CTC: \$${candidate.currentCtc ?? 0}'),
              Text('Expected CTC: \$${candidate.expectedCtc ?? 0}'),
              const SizedBox(height: 8),
              const Text('Skills:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: (candidate.skills ?? []).map((skill) => Chip(
                  label: Text(skill),
                )).toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void shortlistCandidate(CandidateProfileModel candidate) {
    // Implement shortlist logic
    Get.snackbar(
      'Candidate Shortlisted',
      '${candidate.name} has been shortlisted for the position.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void rejectCandidate(CandidateProfileModel candidate) {
    // Implement reject logic
    Get.snackbar(
      'Candidate Rejected',
      '${candidate.name} has been rejected for the position.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> createJobPosting({
    required String title,
    required String company,
    required String description,
    required String location,
    required String employmentType,
    required String salaryRange,
    required List<String> requirements,
    required List<String> skills,
  }) async {
    final jobPosting = JobPosting(
      id: '',
      title: title,
      company: company,
      description: description,
      location: location,
      recruiterId: _appController.currentUser?.uid ?? '',
      requirements: requirements,
      skills: skills,
      employmentType: employmentType,
      salaryRange: salaryRange,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );
    await _jobPostingService.createJobPosting(jobPosting);
  }

  Future<void> updateJobPosting(JobPosting jobPosting) async {
    await _jobPostingService.updateJobPosting(jobPosting);
  }

  Future<void> deleteJobPosting(String jobId) async {
    await _jobPostingService.deleteJobPosting(jobId);
  }

  Future<void> showCreateJobDialog() async {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    final salaryMinController = TextEditingController();
    final salaryMaxController = TextEditingController();
    String? selectedJobRole;
    String? selectedExperienceLevel;
    final selectedSkills = <String>[].obs;

    await Get.dialog(
      AlertDialog(
        title: const Text('Create Job Posting'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Job Title'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Please enter a title' : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Please enter a description' : null,
                ),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Please enter a location' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: salaryMinController,
                        decoration: const InputDecoration(labelText: 'Min Salary'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty == true
                            ? 'Please enter minimum salary'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: salaryMaxController,
                        decoration: const InputDecoration(labelText: 'Max Salary'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty == true
                            ? 'Please enter maximum salary'
                            : null,
                      ),
                    ),
                  ],
                ),
                // TODO: Add dropdowns for job role, experience level, and skills
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() == true) {
                createJobPosting(
                  title: titleController.text,
                  company: '',
                  description: descriptionController.text,
                  location: locationController.text,
                  employmentType: '',
                  salaryRange: '${double.parse(salaryMinController.text)} - ${double.parse(salaryMaxController.text)}',
                  requirements: [],
                  skills: selectedSkills,
                );
                Get.back();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> showEditJobDialog(JobPosting job) async {
    // TODO: Implement edit job dialog similar to create job dialog
  }

  void showJobDetails(JobPosting job) {
    Get.toNamed('/recruiter/job/${job.id}');
  }

  Future<void> signOut() async {
    await _appController.signOut();
  }
} 