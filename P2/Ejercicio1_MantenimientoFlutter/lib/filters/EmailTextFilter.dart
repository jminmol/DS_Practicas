import '../interfaces/Filter.dart';

// filtro que valida el formato del email
class EmailTextFilter implements Filter {
  @override
  String? execute(Map<String, String> request) {
    final email = request['email'] ?? '';
    final parts = email.split('@');
    
    if (parts[0].isEmpty) {
      return "El correo debe tener texto antes del @";
    }
    return null;
  }
}