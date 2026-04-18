import '../interfaces/Filter.dart';

// filtro encargado de la longitud de la contraseña (menos de 8 digitos)
class PasswordLengthFilter implements Filter {
  @override
  String? execute(Map<String, String> request) {
    final password = request['password'] ?? '';
    if (password.length < 8) {
      return "Contraseña demasiado corta (mínimo 8 caracteres)";
    }
    return null;
  }
}