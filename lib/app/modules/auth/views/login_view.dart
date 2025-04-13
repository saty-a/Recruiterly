import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../data/models/user_model.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the role from arguments or use a default value
    final role = Get.arguments?['role'] as UserRole? ?? UserRole.candidate;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
              const SizedBox(height: 40),
              // Role Icon
              Hero(
                tag: 'role_${role.toString()}',
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    role == UserRole.candidate
                        ? Icons.person_outline
                        : role == UserRole.recruiter
                            ? Icons.business_outlined
                            : Icons.admin_panel_settings_outlined,
                    size: 50,
                    color: role == UserRole.candidate
                        ? Colors.orange
                        : role == UserRole.recruiter
                            ? Colors.green
                            : Colors.purple,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                role == UserRole.candidate
                    ? 'Candidate Login'
                    : role == UserRole.recruiter
                        ? 'Recruiter Login'
                        : 'Admin Login',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                role == UserRole.candidate
                    ? 'Find your dream job'
                    : role == UserRole.recruiter
                        ? 'Find the perfect candidates'
                        : 'Manage the platform',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const Spacer(),
              // Login Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (controller.isLoading.value)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
                      else ...[
                        SvgPicture.asset(
                          'assets/google-48.svg',
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 