import '../interfaces/Filter.dart';
import '../interfaces/Filter.dart';

// filtro que valida que haya al menos un carácter especial
class PasswordSpecialCharFilter implements Filter {
  @override
  String? execute(Map<String, String> request) {
    final password = request['password'] ?? '';
    
    // lista de caracteres especiales
    // usamos hasMatch para comprobar si la contraseña tiene alguno
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>\-_]').hasMatch(password)) {
      return "Debe contener al menos un carácter especial";
    }
    
    return null;
  }
}