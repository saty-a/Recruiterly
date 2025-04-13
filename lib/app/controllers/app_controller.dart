import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../data/models/user_model.dart';
import '../routes/app_pages.dart';

class AppController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  RxBool isLoading = false.obs;
  RxString currentRoute = '/'.obs;

  @override
  void onInit() {
    super.onInit();
    ever(_authService.userModel, _handleUserRoleChange);
  }

  void _handleUserRoleChange(UserModel? user) {
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      switch (user.role) {
        case UserRole.admin:
          Get.offAllNamed(Routes.ADMIN_DASHBOARD);
          break;
        case UserRole.recruiter:
          Get.offAllNamed(Routes.DASHBOARD);
          break;
        case UserRole.candidate:
          Get.offAllNamed(Routes.DASHBOARD);
          break;
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      await _authService.signInWithGoogle();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in with Google',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateCurrentRoute(String route) {
    currentRoute.value = route;
  }

  bool get isAuthenticated => _authService.currentUser.value != null;
  bool get isAdmin => _authService.isAdmin;
  bool get isRecruiter => _authService.isRecruiter;
  bool get isCandidate => _authService.isCandidate;
  UserModel? get currentUser => _authService.userModel.value;
} 