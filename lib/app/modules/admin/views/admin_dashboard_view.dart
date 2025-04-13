import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';

class AdminDashboardView extends GetView<AdminController> {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.signOut,
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSection(
                  title: 'Job Roles',
                  items: controller.jobRoles,
                  onAdd: () => controller.showAddDialog('jobRole'),
                  onEdit: (index) => controller.showEditDialog('jobRole', index),
                  onDelete: (index) => controller.deleteItem('jobRole', index),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Experience Levels',
                  items: controller.experienceLevels,
                  onAdd: () => controller.showAddDialog('experienceLevel'),
                  onEdit: (index) => controller.showEditDialog('experienceLevel', index),
                  onDelete: (index) => controller.deleteItem('experienceLevel', index),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: 'Skills',
                  items: controller.skills,
                  onAdd: () => controller.showAddDialog('skill'),
                  onEdit: (index) => controller.showEditDialog('skill', index),
                  onDelete: (index) => controller.deleteItem('skill', index),
                ),
              ],
            )),
    );
  }

  Widget _buildSection({
    required String title,
    required List<String> items,
    required VoidCallback onAdd,
    required Function(int) onEdit,
    required Function(int) onDelete,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onAdd,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => onEdit(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => onDelete(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 