import '../interfaces/Filter.dart';

// filtro que detecta si un correo se registro previamente
class DuplicateEmailFilter implements Filter {
  // lista de correos que se van a registrar
  static final List<String> database = [];

  @override
  String? execute(Map<String, String> request) {
    final email = request['email'] ?? '';
    if (database.contains(email)) {
      return "El correo ya está registrado";
    }
    return null;
  }
}