import '../interfaces/Filter.dart';

// filtro que comprueba que la contraseña tenga al menos un número
class PasswordNumberFilter implements Filter {
  @override
  String? execute(Map<String, String> request) {
    // Asegúrate de que la llave es exactamente 'password'
    final password = request['password'] ?? '';
    
    // hasMatch devolverá true si encuentra al menos un número del 0 al 9
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "La contraseña debe contener al menos un número";
    }
    
    return null;
  }
}