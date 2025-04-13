import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/base_layout.dart';
import '../controllers/recruiter_controller.dart';
import '../../../data/models/job_posting_model.dart';

class JobPostingFormView extends GetView<RecruiterController> {
  final JobPosting? jobPosting;

  const JobPostingFormView({Key? key, this.jobPosting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: jobPosting?.title);
    final companyController = TextEditingController(text: jobPosting?.company);
    final descriptionController = TextEditingController(text: jobPosting?.description);
    final locationController = TextEditingController(text: jobPosting?.location);
    final salaryRangeController = TextEditingController(text: jobPosting?.salaryRange);
    final employmentTypeController = TextEditingController(text: jobPosting?.employmentType);
    final requirementsController = TextEditingController(
      text: jobPosting?.requirements.join('\n'),
    );
    final skillsController = TextEditingController(
      text: jobPosting?.skills.join(', '),
    );

    return BaseLayout(
      title: jobPosting == null ? 'Create Job Posting' : 'Edit Job Posting',
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Job Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a job title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: companyController,
              decoration: const InputDecoration(
                labelText: 'Company Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a company name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Job Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a job description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: employmentTypeController,
              decoration: const InputDecoration(
                labelText: 'Employment Type',
                border: OutlineInputBorder(),
                hintText: 'e.g., Full-time, Part-time, Contract',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an employment type';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: salaryRangeController,
              decoration: const InputDecoration(
                labelText: 'Salary Range',
                border: OutlineInputBorder(),
                hintText: r'e.g., $50,000 - $80,000',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a salary range';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: requirementsController,
              decoration: const InputDecoration(
                labelText: 'Requirements (one per line)',
                border: OutlineInputBorder(),
                hintText: 'e.g.,\n3+ years of experience\nBachelor\'s degree\nStrong communication skills',
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter at least one requirement';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: skillsController,
              decoration: const InputDecoration(
                labelText: 'Required Skills (comma-separated)',
                border: OutlineInputBorder(),
                hintText: 'e.g., Flutter, Dart, Firebase',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter at least one skill';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  final requirements = requirementsController.text
                      .split('\n')
                      .where((line) => line.isNotEmpty)
                      .toList();

                  final skills = skillsController.text
                      .split(',')
                      .map((skill) => skill.trim())
                      .where((skill) => skill.isNotEmpty)
                      .toList();

                  if (jobPosting == null) {
                    controller.createJobPosting(
                      title: titleController.text,
                      company: companyController.text,
                      description: descriptionController.text,
                      location: locationController.text,
                      employmentType: employmentTypeController.text,
                      salaryRange: salaryRangeController.text,
                      requirements: requirements,
                      skills: skills,
                    );
                  } else {
                    controller.updateJobPosting(
                      jobPosting!.copyWith(
                        title: titleController.text,
                        company: companyController.text,
                        description: descriptionController.text,
                        location: locationController.text,
                        employmentType: employmentTypeController.text,
                        salaryRange: salaryRangeController.text,
                        requirements: requirements,
                        skills: skills,
                      ),
                    );
                  }
                }
              },
              child: Text(jobPosting == null ? 'Create Job Posting' : 'Update Job Posting'),
            ),
          ],
        ),
      ),
    );
  }
} 