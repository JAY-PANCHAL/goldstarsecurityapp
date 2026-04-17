import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/app/themes/glassmorphism.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Glassmorphism.cardDecoration(radius: radius),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
