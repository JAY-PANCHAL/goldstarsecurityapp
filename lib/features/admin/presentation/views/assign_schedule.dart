import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';

class AssignSchedule extends StatelessWidget {
  const AssignSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assign Schedule')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: const Center(
          child: Text(
            'Assign Schedule - Local Only',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
