import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/app_controller.dart';
import '../routes/app_pages.dart';

class BaseLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const BaseLayout({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppController controller = Get.find<AppController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (actions != null) ...actions!,
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.signOut,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    controller.currentUser?.name ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    controller.currentUser?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              )),
            ),
            if (controller.isRecruiter) ...[
              ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Job Postings'),
                onTap: () => Get.toNamed('/recruiter/jobs'),
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Applications'),
                onTap: () => Get.toNamed('/recruiter/applications'),
              ),
            ] else if (controller.isCandidate) ...[
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Find Jobs'),
                onTap: () => Get.toNamed('/candidate/jobs'),
              ),
              ListTile(
                leading: const Icon(Icons.assignment),
                title: const Text('My Applications'),
                onTap: () => Get.toNamed('/candidate/applications'),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () => Get.toNamed(Routes.COMMON_CHAT, arguments: [true, controller.currentUser?.uid, 'Profile']),
              ),
            ] else if (controller.isAdmin) ...[
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Users'),
                onTap: () => Get.toNamed('/admin/users'),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => Get.toNamed('/admin/settings'),
              ),
            ],
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
} 