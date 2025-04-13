import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/candidate_controller.dart';
import '../../../data/models/job_posting_model.dart';
import '../../home/views/jobs_view.dart';
import '../../home/views/notifications_view.dart';

class CandidateDashboardView extends GetView<CandidateController> {
  const CandidateDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const JobsView(),
      const NotificationsView(),
    ];

    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.work),
              label: 'Jobs',
            ),
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
