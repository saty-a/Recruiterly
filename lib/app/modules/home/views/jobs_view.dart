import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JobsView extends GetView {
  const JobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Jobs View',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
} 