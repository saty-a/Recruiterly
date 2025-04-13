import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../data/models/job_posting_model.dart';
import '../controllers/app_controller.dart';

class JobPostingService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AppController _appController = Get.find<AppController>();

  RxList<JobPosting> jobPostings = <JobPosting>[].obs;
  RxBool isLoading = false.obs;

  Future<void> loadJobPostings({String? recruiterId}) async {
    try {
      isLoading.value = true;
      Query query = _firestore.collection('job_postings').orderBy('createdAt', descending: true);
      
      if (recruiterId != null) {
        query = query.where('recruiterId', isEqualTo: recruiterId);
      }

      final snapshot = await query.get();
      jobPostings.value = snapshot.docs.map((doc) => JobPosting.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load job postings',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createJobPosting(JobPosting jobPosting) async {
    try {
      isLoading.value = true;
      await _firestore.collection('job_postings').add(jobPosting.toMap());
      await loadJobPostings(recruiterId: _appController.currentUser?.uid);
      Get.back();
      Get.snackbar(
        'Success',
        'Job posting created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create job posting',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateJobPosting(JobPosting jobPosting) async {
    try {
      isLoading.value = true;
      await _firestore.collection('job_postings').doc(jobPosting.id).update(jobPosting.toMap());
      await loadJobPostings(recruiterId: _appController.currentUser?.uid);
      Get.back();
      Get.snackbar(
        'Success',
        'Job posting updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update job posting',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteJobPosting(String jobId) async {
    try {
      isLoading.value = true;
      await _firestore.collection('job_postings').doc(jobId).delete();
      await loadJobPostings(recruiterId: _appController.currentUser?.uid);
      Get.snackbar(
        'Success',
        'Job posting deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete job posting',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<JobPosting>> searchJobs({
    String? query,
    List<String>? skills,
    String? location,
    String? employmentType,
  }) async {
    try {
      isLoading.value = true;
      Query baseQuery = _firestore.collection('job_postings')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true);

      if (location != null && location.isNotEmpty) {
        baseQuery = baseQuery.where('location', isEqualTo: location);
      }

      if (employmentType != null && employmentType.isNotEmpty) {
        baseQuery = baseQuery.where('employmentType', isEqualTo: employmentType);
      }

      final snapshot = await baseQuery.get();
      var results = snapshot.docs.map((doc) => JobPosting.fromFirestore(doc)).toList();

      if (query != null && query.isNotEmpty) {
        final lowercaseQuery = query.toLowerCase();
        results = results.where((job) {
          return job.title.toLowerCase().contains(lowercaseQuery) ||
              job.description.toLowerCase().contains(lowercaseQuery) ||
              job.company.toLowerCase().contains(lowercaseQuery);
        }).toList();
      }

      if (skills != null && skills.isNotEmpty) {
        results = results.where((job) {
          return job.skills.any((skill) => skills.contains(skill));
        }).toList();
      }

      return results;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to search jobs',
        snackPosition: SnackPosition.BOTTOM,
      );
      return [];
    } finally {
      isLoading.value = false;
    }
  }
} 