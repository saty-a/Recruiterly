import 'package:get/get.dart';
import '../controllers/candidate_controller.dart';

class CandidateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CandidateController>(
      () => CandidateController(),
    );
  }
} 