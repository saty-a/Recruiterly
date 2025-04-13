import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/job_posting_model.dart';
import '../../candidate/controllers/candidate_controller.dart';

class CandidateJobsView extends GetView<CandidateController> {
  const CandidateJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (controller.filteredJobs.isEmpty) {
        return const Center(
          child: Text('No jobs found. Try adjusting your filters.'),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.filteredJobs.length,
        itemBuilder: (context, index) {
          final job = controller.filteredJobs[index];
          return JobCard(job: job);
        },
      );
    });
  }
}

class JobCard extends StatelessWidget {
  final JobPosting job;
  
  const JobCard({super.key, required this.job});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company logo and name
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: job.companyLogo != null 
                      ? NetworkImage(job.companyLogo!) 
                      : null,
                  child: job.companyLogo == null 
                      ? const Icon(Icons.business, size: 30) 
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.companyName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.location,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Job title
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Job details in a card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(Icons.work, 'Role', job.employmentType),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.attach_money, 'Budget', '\$${job.salaryRange}'),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.timer, 'Experience', '${job.experienceRequired} years'),
                  const SizedBox(height: 8),
                  _buildSkillsChips(job.skills),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // More details button
            Center(
              child: TextButton(
                onPressed: () => Get.find<CandidateController>().showJobDetails(job),
                child: const Text('More Details'),
              ),
            ),
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.close,
                  color: Colors.red,
                  label: 'Not Interested',
                  onPressed: () {
                    // Handle not interested action
                  },
                ),
                _buildActionButton(
                  icon: Icons.check,
                  color: Colors.green,
                  label: 'Apply',
                  onPressed: () {
                    Get.find<CandidateController>().applyForJob(job);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        Text(value),
      ],
    );
  }
  
  Widget _buildSkillsChips(List<String> skills) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) => Chip(
        label: Text(skill),
        backgroundColor: Colors.blue[50],
        labelStyle: TextStyle(color: Colors.blue[700]),
      )).toList(),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.2),
          child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
} 