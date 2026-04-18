import 'FilterChain.dart';
import '../interfaces/Filter.dart';
import 'AuthenticationService.dart';

class FilterManager {
  late FilterChain _filterChain;

  FilterManager(AuthenticationService target) {
    _filterChain = FilterChain();
    _filterChain.setTarget(target);
  }

  void addFilter(Filter filter) {
    _filterChain.addFilter(filter);
  }

  // procesa la petición y devuelve el resultado de la validación
  String? filterRequest(Map<String, String> request) {
    return _filterChain.execute(request);
  }
}