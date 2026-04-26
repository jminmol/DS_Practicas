import '../interfaces/ServicioTuristico.dart';

class Paquete implements ServicioTuristico {
  String nombre;
  List<ServicioTuristico> servicios = [];

  // constructor
  Paquete(this.nombre);

  // método que obtiene el precio de todo el paquete
  @override
  double getPrecio() {
    double total = 0;
    for (var s in servicios) {
      total += s.getPrecio();
    }
    return total;
  }
}