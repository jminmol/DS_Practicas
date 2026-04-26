import '../interfaces/PoliticaVuelo.dart';

class TarifaBusiness implements PoliticaVuelo {
  final double _MULTIPLICADOR = 3.0;

  // método calcular tarifa business
  @override
  double calcular(double basePrecio) => basePrecio * _MULTIPLICADOR;
}