class ValidationService {
  static String? validateNotEmpty(String? v) {
    if (v == null || v.isEmpty) return "Requerido";
    return null;
  }

  static String? validateNumber(String? v) {
    if (v == null || v.isEmpty) return "Requerido";
    if (double.tryParse(v) == null) return "Debe ser número";
    return null;
  }
}
