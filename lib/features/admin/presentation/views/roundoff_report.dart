import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';

class RoundoffReport extends StatelessWidget {
  const RoundoffReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roundoff Report')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: const Center(
          child: Text(
            'Roundoff Report - Local Only',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
