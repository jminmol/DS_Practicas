import '../interfaces/ServicioTuristico.dart';
import '../interfaces/PoliticaHotel.dart';

class Hotel implements ServicioTuristico {
  String nombre;
  double precioNoche;
  int noches;
  PoliticaHotel politica;

  // constructor del hotel
  Hotel(this.nombre, this.precioNoche, this.noches, this.politica);

  // método para obtener el precio de un hotel según su política
  @override
  double getPrecio() => politica.calcular(precioNoche, noches);
}