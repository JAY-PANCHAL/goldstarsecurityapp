class Validators {
  static String? requiredField(String? value, {String message = 'Required'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Employee code is required';
    if (value.trim().length < 2)
      return 'Employee code must be at least 2 characters';
    return null;
  }
}
