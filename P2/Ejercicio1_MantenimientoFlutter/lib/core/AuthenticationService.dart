// clase encargada de indicar que la autenticación es correcta
class AuthenticationService {
  void execute(Map<String, String> request) {
    print("Autenticación correcta para ${request['email']}");
  }
}