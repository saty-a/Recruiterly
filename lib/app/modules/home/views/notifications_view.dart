import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class NotificationsView extends GetView {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final isRecruiter = authService.isRecruiter;
    
    // Placeholder for notifications
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Application Status Update',
        'message': 'Your application for Senior Developer position has been reviewed.',
        'time': '2 hours ago',
        'isRead': false,
      },
      {
        'title': 'New Job Match',
        'message': 'A new job matching your skills has been posted.',
        'time': '1 day ago',
        'isRead': true,
      },
      {
        'title': 'Interview Scheduled',
        'message': 'Your interview has been scheduled for tomorrow at 10:00 AM.',
        'time': '2 days ago',
        'isRead': true,
      },
    ];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            onPressed: () {
              // Mark all as read
            },
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text('No notifications'),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  title: notification['title'],
                  message: notification['message'],
                  time: notification['time'],
                  isRead: notification['isRead'],
                );
              },
            ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isRead;
  
  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isRead ? null : Colors.blue[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isRead ? Colors.grey[300] : Colors.blue[100],
          child: Icon(
            isRead ? Icons.notifications_none : Icons.notifications_active,
            color: isRead ? Colors.grey[600] : Colors.blue[700],
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: isRead
            ? null
            : IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  // Mark as read
                },
              ),
        onTap: () {
          // Handle notification tap
        },
      ),
    );
  }
} 