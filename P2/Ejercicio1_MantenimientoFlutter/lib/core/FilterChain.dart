import '../interfaces/Filter.dart';
import 'AuthenticationService.dart';

class FilterChain {
  final List<Filter> _filters = [];
  AuthenticationService? _target;

  void addFilter(Filter filter) {
    _filters.add(filter);
  }

  void setTarget(AuthenticationService target) {
    _target = target;
  }

  // devuelve un String con el error si algo falla, 
  // o null si todo salió bien y se ejecutó el target
  String? execute(Map<String, String> request) {
    for (var filter in _filters) {
      String? errorMessage = filter.execute(request);
      
      if (errorMessage != null) {
        // si un filtro falla, devolvemos el mensaje inmediatamente
        return errorMessage; 
      }
    }

    // si todos los filtros pasaron (devolvieron null), ejecutamos el target
    _target?.execute(request);
    return null; 
  }
}