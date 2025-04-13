import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/controllers/app_controller.dart';
import 'app/data/models/user_model.dart';
import 'app/data/dummy_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  
  final authService = await Get.putAsync(() => AuthService().init());
  Get.put(AppController());

  String initialRoute = AppPages.INITIAL;
  final storage = GetStorage();
  final userRole = storage.read<String>('userRole');
  
  if (userRole != null) {
    switch (userRole) {
      case 'admin':
        initialRoute = Routes.ADMIN_DASHBOARD;
        break;
      case 'recruiter':
      case 'candidate':
        initialRoute = Routes.DASHBOARD;
        break;
    }
  }

  // Create dummy data in debug mode
  if (!const bool.fromEnvironment('dart.vm.product')) {
    try {
      final dummyData = DummyData();
      await dummyData.createDummyData();
      print('Dummy data created successfully');
    } catch (e) {
      print('Error creating dummy data: $e');
    }
  }

  runApp(
    GetMaterialApp(
      title: "Recruiterly",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
      navigatorKey: Get.key,
    ),
  );
}
