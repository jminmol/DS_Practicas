// interfaz filter
abstract class Filter {
  // recibe un mapa con las credenciales (email y password)
  String? execute(Map<String, String> request);
}