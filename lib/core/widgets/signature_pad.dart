import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePad extends StatelessWidget {
  final SignatureController controller;

  const SignaturePad({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Signature(
      controller: controller,
      backgroundColor: Colors.white.withOpacity(0.05),
    );
  }
}
