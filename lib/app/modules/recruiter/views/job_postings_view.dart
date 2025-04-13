import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/base_layout.dart';
import '../controllers/recruiter_controller.dart';
import '../../../data/models/job_posting_model.dart';

class JobPostingsView extends GetView<RecruiterController> {
  const JobPostingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Job Postings',
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/recruiter/jobs/create'),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.jobPostings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.work_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No job postings yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/recruiter/jobs/create'),
                  child: const Text('Create Job Posting'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.jobPostings.length,
          itemBuilder: (context, index) {
            final job = controller.jobPostings[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                title: Text(
                  job.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(job.company),
                    const SizedBox(height: 4),
                    Text(job.location),
                    const SizedBox(height: 4),
                    Text(job.employmentType),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: job.skills.map((skill) => Chip(
                        label: Text(skill),
                      )).toList(),
                    ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        Get.toNamed('/recruiter/jobs/edit/${job.id}');
                        break;
                      case 'delete':
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Delete Job Posting'),
                            content: const Text('Are you sure you want to delete this job posting?'),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                  controller.deleteJobPosting(job.id);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                      ),
                    ),
                  ],
                ),
                onTap: () => Get.toNamed('/recruiter/jobs/${job.id}'),
              ),
            );
          },
        );
      }),
    );
  }
} 