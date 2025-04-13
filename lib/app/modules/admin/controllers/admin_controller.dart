import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../controllers/app_controller.dart';

class AdminController extends GetxController {
  final AppController _appController = Get.find<AppController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;
  RxList<String> jobRoles = <String>[].obs;
  RxList<String> experienceLevels = <String>[].obs;
  RxList<String> skills = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadPredefinedLists();
  }

  Future<void> _loadPredefinedLists() async {
    try {
      isLoading.value = true;
      
      // Load job roles
      final jobRolesDoc = await _firestore.collection('predefined_lists').doc('jobRoles').get();
      if (jobRolesDoc.exists) {
        jobRoles.value = List<String>.from(jobRolesDoc.data()?['items'] ?? []);
      }

      // Load experience levels
      final experienceLevelsDoc = await _firestore.collection('predefined_lists').doc('experienceLevels').get();
      if (experienceLevelsDoc.exists) {
        experienceLevels.value = List<String>.from(experienceLevelsDoc.data()?['items'] ?? []);
      }

      // Load skills
      final skillsDoc = await _firestore.collection('predefined_lists').doc('skills').get();
      if (skillsDoc.exists) {
        skills.value = List<String>.from(skillsDoc.data()?['items'] ?? []);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load predefined lists',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> showAddDialog(String listType) async {
    final TextEditingController textController = TextEditingController();
    
    await Get.dialog(
      AlertDialog(
        title: Text('Add ${listType == 'jobRole' ? 'Job Role' : listType == 'experienceLevel' ? 'Experience Level' : 'Skill'}'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'Enter ${listType == 'jobRole' ? 'job role' : listType == 'experienceLevel' ? 'experience level' : 'skill'}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                addItem(listType, textController.text);
                Get.back();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> showEditDialog(String listType, int index) async {
    final TextEditingController textController = TextEditingController(
      text: listType == 'jobRole'
          ? jobRoles[index]
          : listType == 'experienceLevel'
              ? experienceLevels[index]
              : skills[index],
    );

    await Get.dialog(
      AlertDialog(
        title: Text('Edit ${listType == 'jobRole' ? 'Job Role' : listType == 'experienceLevel' ? 'Experience Level' : 'Skill'}'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: 'Enter ${listType == 'jobRole' ? 'job role' : listType == 'experienceLevel' ? 'experience level' : 'skill'}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                editItem(listType, index, textController.text);
                Get.back();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> addItem(String listType, String item) async {
    try {
      isLoading.value = true;
      final docRef = _firestore.collection('predefined_lists').doc(listType == 'jobRole' ? 'jobRoles' : listType == 'experienceLevel' ? 'experienceLevels' : 'skills');
      
      final List<String> currentList = listType == 'jobRole'
          ? jobRoles
          : listType == 'experienceLevel'
              ? experienceLevels
              : skills;

      currentList.add(item);
      
      await docRef.set({
        'items': currentList,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (listType == 'jobRole') {
        jobRoles.value = currentList;
      } else if (listType == 'experienceLevel') {
        experienceLevels.value = currentList;
      } else {
        skills.value = currentList;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editItem(String listType, int index, String newValue) async {
    try {
      isLoading.value = true;
      final docRef = _firestore.collection('predefined_lists').doc(listType == 'jobRole' ? 'jobRoles' : listType == 'experienceLevel' ? 'experienceLevels' : 'skills');
      
      final List<String> currentList = listType == 'jobRole'
          ? jobRoles
          : listType == 'experienceLevel'
              ? experienceLevels
              : skills;

      currentList[index] = newValue;
      
      await docRef.set({
        'items': currentList,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (listType == 'jobRole') {
        jobRoles.value = currentList;
      } else if (listType == 'experienceLevel') {
        experienceLevels.value = currentList;
      } else {
        skills.value = currentList;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to edit item',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteItem(String listType, int index) async {
    try {
      isLoading.value = true;
      final docRef = _firestore.collection('predefined_lists').doc(listType == 'jobRole' ? 'jobRoles' : listType == 'experienceLevel' ? 'experienceLevels' : 'skills');
      
      final List<String> currentList = listType == 'jobRole'
          ? jobRoles
          : listType == 'experienceLevel'
              ? experienceLevels
              : skills;

      currentList.removeAt(index);
      
      await docRef.set({
        'items': currentList,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (listType == 'jobRole') {
        jobRoles.value = currentList;
      } else if (listType == 'experienceLevel') {
        experienceLevels.value = currentList;
      } else {
        skills.value = currentList;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete item',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _appController.signOut();
  }
} 