import '../interfaces/ServicioTuristico.dart';
import '../interfaces/PoliticaHotel.dart';

class Hotel implements ServicioTuristico {
  String nombre;
  double precioNoche;
  int noches;
  PoliticaHotel politica;

  // constructor del hotel
  Hotel(this.nombre, this.precioNoche, this.noches, this.politica){
    if (noches <= 0) {
      throw ArgumentError('El número de noches debe ser mayor que cero.');
    }
  }

  // método para obtener el precio de un hotel según su política
  @override
  double getPrecio() => politica.calcular(precioNoche, noches);
}