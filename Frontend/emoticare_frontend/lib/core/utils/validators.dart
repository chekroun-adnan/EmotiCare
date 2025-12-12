class Validators {
  static String? required(String? value, {String message = 'Required'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'Email required';
    // Use a JavaScript-compatible regex pattern
    // Hyphen must be at the end or escaped to avoid being interpreted as a range
    final regex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value)) return 'Invalid email';
    return null;
  }

  static String? minLength(String? value, {int min = 6}) {
    if (value == null || value.length < min) return 'Min $min chars';
    return null;
  }
}
