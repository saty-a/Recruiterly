import 'package:get/get.dart';
import '../controllers/recruiter_controller.dart';

class RecruiterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecruiterController>(
      () => RecruiterController(),
    );
  }
} 