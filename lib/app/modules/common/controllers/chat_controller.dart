import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/app_controller.dart';
import '../../../data/models/chat_message_model.dart';

class ChatController extends GetxController {
  final AppController _appController = Get.find<AppController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final messageController = TextEditingController();

  late final bool isProfile;
  late final String userId;
  late final String groupName;

  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as List<dynamic>;
    isProfile = args[0] as bool;
    userId = args[1] as String;
    groupName = args[2] as String;
    _loadMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<void> _loadMessages() async {
    try {
      isLoading.value = true;
      final chatId = _getChatId();
      
      _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) {
        messages.value = snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load messages',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _getChatId() {
    final currentUserId = _appController.currentUser?.uid;
    if (currentUserId == null) return '';
    
    // Sort user IDs to ensure consistent chat ID
    final List<String> userIds = [currentUserId, userId]..sort();
    return '${userIds[0]}_${userIds[1]}';
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    try {
      isLoading.value = true;
      final currentUser = _appController.currentUser;
      if (currentUser == null) return;

      final chatId = _getChatId();
      final message = ChatMessage(
        id: '',
        senderId: currentUser.uid,
        senderName: currentUser.name,
        senderImage: currentUser.profileImage,
        content: messageController.text.trim(),
        timestamp: DateTime.now(),
        isRead: false,
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toMap());

      messageController.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
} 