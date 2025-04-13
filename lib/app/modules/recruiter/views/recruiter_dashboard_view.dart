import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/recruiter_controller.dart';
import '../../../data/models/job_posting_model.dart';

class RecruiterDashboardView extends GetView<RecruiterController> {
  const RecruiterDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recruiter Dashboard'),
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
                _buildJobPostingsList(),
              ],
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.showCreateJobDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildJobPostingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Job Postings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.jobPostings.length,
              itemBuilder: (context, index) {
                final JobPosting job = controller.jobPostings[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(job.title),
                    subtitle: Text(
                      '${job.employmentType} • ${job.salaryRange}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => controller.showEditJobDialog(job),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => controller.deleteJobPosting(job.id),
                        ),
                      ],
                    ),
                    onTap: () => controller.showJobDetails(job),
                  ),
                );
              },
            )),
      ],
    );
  }
} 