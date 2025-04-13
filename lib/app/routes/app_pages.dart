import 'package:get/get.dart';
import 'package:recruiterly/app/modules/auth/views/login_view.dart';
import 'package:recruiterly/app/modules/auth/views/role_selection_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/admin/bindings/admin_binding.dart';
import '../modules/admin/views/admin_dashboard_view.dart';
import '../modules/recruiter/bindings/recruiter_binding.dart';
import '../modules/candidate/bindings/candidate_binding.dart';
import '../modules/home/views/dashboard_view.dart';
import '../modules/home/views/settings_view.dart';
import '../modules/common/bindings/chat_binding.dart';
import '../modules/common/views/chat_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ROLE_SELECTION;

  static final routes = [
    GetPage(
      name: Routes.ROLE_SELECTION,
      page: () => const RoleSelectionView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: CandidateBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
    ),
    GetPage(
      name: Routes.COMMON_CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
  ];
}
