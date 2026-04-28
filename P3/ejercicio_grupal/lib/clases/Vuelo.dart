import '../interfaces/ServicioTuristico.dart';
import '../interfaces/PoliticaVuelo.dart';

class Vuelo implements ServicioTuristico {
  String id;
  double precioBase;
  PoliticaVuelo politica;

  // constructor de un vuelo
  Vuelo(this.id, this.precioBase, this.politica){
    if (precioBase < 0) {
      throw ArgumentError('El precio base del vuelo no puede ser negativo.');
    }
  }

  // método para obtener el precio de un vuelo según su política
  @override
  double getPrecio() => politica.calcular(precioBase);
}