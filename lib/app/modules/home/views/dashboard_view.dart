import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../candidate/controllers/candidate_controller.dart';
import '../../recruiter/controllers/recruiter_controller.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_pages.dart';
import 'candidate_jobs_view.dart';
import 'recruiter_jobs_view.dart';
import 'notifications_view.dart';

class DashboardView extends GetView {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final user = authService.userModel.value;

    // Determine which controller to use based on user role
    final isRecruiter = authService.isRecruiter;

    // Create a controller for navigation if it doesn't exist
    final navigationController = Get.put(NavigationController());

    final List<Widget> pages = [
      isRecruiter ? const RecruiterJobsView() : const CandidateJobsView(),
      const NotificationsView(),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.SETTINGS),
              child: CircleAvatar(
                radius: 18,
                backgroundImage:
                    user?.profileImage != null
                        ? NetworkImage(user!.profileImage!)
                        : null,
                child:
                    user?.profileImage == null
                        ? Text(
                          user?.name.isNotEmpty == true
                              ? user!.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : null,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() => pages[navigationController.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navigationController.currentIndex.value,
          onTap: navigationController.changePage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
