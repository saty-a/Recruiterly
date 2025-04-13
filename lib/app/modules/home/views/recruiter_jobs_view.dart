import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/candidate_profile_model.dart';
import '../../recruiter/controllers/recruiter_controller.dart';

class RecruiterJobsView extends GetView<RecruiterController> {
  const RecruiterJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (controller.candidates.isEmpty) {
        return const Center(
          child: Text('No candidates found.'),
        );
      }
      
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.candidates.length,
        itemBuilder: (context, index) {
          final candidate = controller.candidates[index];
          return CandidateCard(candidate: candidate);
        },
      );
    });
  }
}

class CandidateCard extends StatelessWidget {
  final CandidateProfileModel candidate;
  
  const CandidateCard({super.key, required this.candidate});
  
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
            // Candidate profile image and name
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: candidate.profileImage != null 
                      ? NetworkImage(candidate.profileImage!) 
                      : null,
                  child: candidate.profileImage == null 
                      ? const Icon(Icons.person, size: 30) 
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        candidate.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        candidate.currentRole ?? 'Not specified',
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
            
            // Candidate details in a card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(Icons.work, 'Current Role', candidate.currentRole ?? 'Not specified'),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.timer, 'Experience', '${candidate.totalExperience ?? 0} years'),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.calendar_today, 'Notice Period', '${candidate.noticePeriod ?? 0} days'),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.attach_money, 'Current CTC', '\$${candidate.currentCtc ?? 0}'),
                  const SizedBox(height: 8),
                  _buildDetailRow(Icons.attach_money, 'Expected CTC', '\$${candidate.expectedCtc ?? 0}'),
                  const SizedBox(height: 8),
                  _buildSkillsChips(candidate.skills),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // More details button
            Center(
              child: TextButton(
                onPressed: () => Get.find<RecruiterController>().showCandidateDetails(candidate),
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
                  label: 'Reject',
                  onPressed: () {
                    Get.find<RecruiterController>().rejectCandidate(candidate);
                  },
                ),
                _buildActionButton(
                  icon: Icons.check,
                  color: Colors.green,
                  label: 'Apply',
                  onPressed: () {
                    Get.find<RecruiterController>().shortlistCandidate(candidate);
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