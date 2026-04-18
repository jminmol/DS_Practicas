import 'core/FilterManager.dart';

class Cliente {
  final FilterManager filterManager;

  Cliente(this.filterManager);

  // envía la solicitud y devuelve el String de error (si lo hay)
  String? sendRequest(Map<String, String> request) {
    return filterManager.filterRequest(request);
  }
}