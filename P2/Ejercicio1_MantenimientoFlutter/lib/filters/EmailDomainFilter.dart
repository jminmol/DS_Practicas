import '../interfaces/Filter.dart';

// filtro que valida el dominio del email
class EmailDomainFilter implements Filter {
  static const allowedDomains = ["gmail.com", "hotmail.com"];

  @override
  String? execute(Map<String, String> request) {
    final email = request['email'] ?? '';
    final parts = email.split('@');
    
    if (parts.length < 2 || !allowedDomains.contains(parts[1])) {
      return "Dominio de correo no permitido";
    }
    return null;
  }
}