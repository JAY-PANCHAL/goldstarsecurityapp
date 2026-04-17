import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/core/utils/pii_masker.dart';

class PiiText extends StatelessWidget {
  final String? value;
  final bool isAadhaar;
  final TextStyle? style;

  const PiiText({
    super.key,
    required this.value,
    this.isAadhaar = true,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final masked = isAadhaar
        ? PiiMasker.maskAadhaar(value)
        : PiiMasker.maskPan(value);
    return Text(masked, style: style);
  }
}
