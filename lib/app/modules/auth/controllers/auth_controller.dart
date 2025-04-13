import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';

class AuthController extends GetxController {
  final Rx<UserRole?> selectedRole = Rx<UserRole?>(null);
  final RxBool isLoading = false.obs;
  final AuthService _authService = Get.find<AuthService>();

  void selectRole(UserRole role) {
    selectedRole.value = role;
    Get.toNamed(
      Routes.LOGIN,
      arguments: {'role': role},
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      final userCredential = await _authService.signInWithGoogle();
      
      if (userCredential == null) {
        Get.snackbar(
          'Sign-in Cancelled',
          'You cancelled the Google sign-in process or authentication failed',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      // The AuthService will handle redirection based on user role
      // No need to manually redirect here
      
    } catch (e) {
      print('Error in signInWithGoogle: $e');
      
      String errorMessage = 'Failed to sign in with Google';
      
      if (e.toString().contains('network_error')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('sign_in_canceled')) {
        errorMessage = 'Sign-in was cancelled. Please try again.';
      } else if (e.toString().contains('sign_in_failed')) {
        errorMessage = 'Sign-in failed. Please try again later.';
      } else if (e.toString().contains('account_exists_with_different_credential')) {
        errorMessage = 'An account already exists with the same email address but different sign-in credentials.';
      } else if (e.toString().contains('Null check operator used on a null value')) {
        errorMessage = 'Authentication failed. Please try again or use a different sign-in method.';
      } else if (e.toString().contains('access_denied')) {
        errorMessage = 'Access denied. Please check your Google account permissions.';
      } else if (e.toString().contains('invalid_client')) {
        errorMessage = 'Invalid client configuration. Please contact support.';
      } else if (e.toString().contains('invalid_grant')) {
        errorMessage = 'Invalid grant. Please try signing in again.';
      } else if (e.toString().contains('invalid_request')) {
        errorMessage = 'Invalid request. Please try again later.';
      } else if (e.toString().contains('invalid_scope')) {
        errorMessage = 'Invalid scope. Please contact support.';
      } else if (e.toString().contains('unauthorized_client')) {
        errorMessage = 'Unauthorized client. Please contact support.';
      } else if (e.toString().contains('unsupported_grant_type')) {
        errorMessage = 'Unsupported grant type. Please contact support.';
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
      // AuthService will handle redirection
    } catch (e) {
      print('Error in signOut: $e');
      Get.snackbar(
        'Error',
        'Failed to sign out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Test method to verify Google Sign-In configuration
  Future<void> testGoogleSignIn() async {
    try {
      isLoading.value = true;
      
      final result = await _authService.testGoogleSignInConfig();
      
      if (result) {
        Get.snackbar(
          'Success',
          'Google Sign-In configuration is valid',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Google Sign-In configuration is invalid',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error testing Google Sign-In: $e');
      Get.snackbar(
        'Error',
        'Failed to test Google Sign-In: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 