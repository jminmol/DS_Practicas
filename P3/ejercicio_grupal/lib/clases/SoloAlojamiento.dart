import '../interfaces/PoliticaHotel.dart';

class SoloAlojamiento implements PoliticaHotel {
  // método calcular el precio de solo el alojamiento
  @override
  double calcular(double precioNoche, int noches) => precioNoche * noches;
}