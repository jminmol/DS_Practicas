import '../interfaces/PoliticaHotel.dart';

class TodoIncluido implements PoliticaHotel {
  final double _SUPLEMENTO_DIARIO = 0.75;

  // método calcular el precio todo incluido
  @override
  double calcular(double precioNoche, int noches) {
    double base = precioNoche * noches;
    return base + (base * _SUPLEMENTO_DIARIO);
  }
}