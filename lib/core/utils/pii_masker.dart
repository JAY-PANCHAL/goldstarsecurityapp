class PiiMasker {
  static String maskAadhaar(String? value) {
    if (value == null || value.isEmpty) return '';
    final clean = value.replaceAll(RegExp(r'\s+'), '');
    if (clean.length <= 4) return clean;
    final last4 = clean.substring(clean.length - 4);
    return 'XXXX-XXXX-$last4';
  }

  static String maskPan(String? value) {
    if (value == null || value.isEmpty) return '';
    final clean = value.replaceAll(RegExp(r'\s+'), '');
    if (clean.length <= 4) return clean;
    final middle = clean.substring(1, clean.length - 1);
    final masked = middle.replaceAll(RegExp(r'.'), 'X');
    return '${clean[0]}$masked${clean[clean.length - 1]}';
  }
}
