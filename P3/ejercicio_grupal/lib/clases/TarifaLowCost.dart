import '../interfaces/PoliticaVuelo.dart';

class TarifaLowCost implements PoliticaVuelo {
  final double _RECARGO_FIJO = 60.0;

  // método calcular tarifa low cost
  @override
  double calcular(double basePrecio) => basePrecio + _RECARGO_FIJO;
}