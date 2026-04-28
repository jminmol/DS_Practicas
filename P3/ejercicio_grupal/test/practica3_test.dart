// Importamos la librería de tests de Flutter
import 'package:flutter_test/flutter_test.dart';

// Importamos nuestras políticas
import '../lib/clases/TarifaLowCost.dart';
import '../lib/clases/TarifaBusiness.dart';
import '../lib/clases/SoloAlojamiento.dart';
import '../lib/clases/TodoIncluido.dart';
import '../lib/clases/Hotel.dart';
import '../lib/clases/Vuelo.dart';
import '../lib/clases/Paquete.dart';

void main() {

  // ==========================================================
  // GRUPO 1: Políticas de Precio
  // ==========================================================
  group('Grupo Políticas de Precio', () {

    test('TarifaLowCost añade su recargo de gestión constante al precio base', () {
      // Preparación (Arrange)
      final tarifa = TarifaLowCost();
      // Ejecución (Act)
      final precioFinal = tarifa.calcular(100.0);
      // Comprobación (Assert): 100 base + 60 recargo fijo = 160.0
      expect(precioFinal, equals(160.0));
    });

    test('TarifaBusiness aplica su multiplicador interno de clase superior correctamente', () {
      final tarifa = TarifaBusiness();
      final precioFinal = tarifa.calcular(100.0);
      // 100 base * 3.0 multiplicador = 300.0
      expect(precioFinal, equals(300.0));
    });

    test('RegimenSoloAlojamiento calcula el producto exacto de noches por precio', () {
      final regimen = SoloAlojamiento();
      final precioFinal = regimen.calcular(50.0, 3); // 50€ x 3 noches
      // 50.0 * 3 = 150.0
      expect(precioFinal, equals(150.0));
    });

    test('RegimenTodoIncluido incorpora su suplemento diario interno al coste de la estancia', () {
      final regimen = TodoIncluido();
      final precioFinal = regimen.calcular(50.0, 3); // 50€ x 3 noches
      // Base = 150.0
      // Suplemento = 150.0 * 0.75 = 112.5
      // Total = 150.0 + 112.5 = 262.5
      expect(precioFinal, equals(262.5));
    });

  });
  // ==========================================================
  // GRUPO 2: Servicios Individuales
  // ==========================================================
  group('Grupo Servicios Individuales (Hojas)', () {

    test('El constructor de Vuelo lanza una excepción ante un precio base negativo', () {
      // Comprobamos que al intentar crear un vuelo con -50€, salta el error esperado
      expect(
              () => Vuelo("Vuelo Imposible", -50.0, TarifaLowCost()),
          throwsArgumentError
      );
    });

    test('El constructor de Hotel impide la creación de estancias con cero o menos noches', () {
      // Comprobamos que con 0 noches o -1 noches, salta el error
      expect(
              () => Hotel("Hotel Fantasma", 100.0, 0, SoloAlojamiento()),
          throwsArgumentError
      );
    });

    test('El método getPrecio() de Vuelo delega el cálculo en su política asignada', () {
      final vuelo = Vuelo("V1", 100.0, TarifaBusiness());
      // Debería delegar en Business (100 * 3.0 = 300)
      expect(vuelo.getPrecio(), equals(300.0));
    });

    test('El método getPrecio() de Hotel retorna el valor procesado por su política de régimen', () {
      final hotel = Hotel("H1", 50.0, 3, TodoIncluido());
      // Debería delegar en TodoIncluido: Base(150) + Suplemento(112.5) = 262.5
      expect(hotel.getPrecio(), equals(262.5));
    });

  });

  // ==========================================================
  // GRUPO 3: Agrupación de Paquetes
  // ==========================================================
  group('Grupo Agrupación de Paquetes', () {

    test('Un Paquete recién instanciado sin servicios devuelve un precio total de cero', () {
      final paqueteVacio = Paquete("Caja Vacía");
      expect(paqueteVacio.getPrecio(), equals(0.0));
    });

    test('El método getPrecio() de Paquete realiza la suma aritmética de todos sus componentes directos', () {
      final paquete = Paquete("Pack Básico");
      paquete.servicios.add(Vuelo("V1", 100.0, TarifaLowCost())); // 160.0
      paquete.servicios.add(Hotel("H1", 50.0, 3, SoloAlojamiento())); // 150.0

      // Total esperado: 160.0 + 150.0 = 310.0
      expect(paquete.getPrecio(), equals(310.0));
    });

    test('La estructura recursiva permite que un paquete raíz sume correctamente el importe de paquetes anidados', () {
      final paqueteRaiz = Paquete("Viaje Familiar");
      final paqueteHijo = Paquete("Escapada Pareja");

      paqueteHijo.servicios.add(Hotel("H1", 50.0, 3, SoloAlojamiento())); // 150.0
      paqueteRaiz.servicios.add(Vuelo("V1", 100.0, TarifaLowCost())); // 160.0
      paqueteRaiz.servicios.add(paqueteHijo); // Metemos el paquete dentro del paquete

      // Total esperado: 160.0 (Vuelo) + 150.0 (Paquete anidado) = 310.0
      expect(paqueteRaiz.getPrecio(), equals(310.0));
    });

    test('La modificación de la política de un servicio contenido actualiza el precio total del paquete raíz', () {
      final paquete = Paquete("Viaje Dinámico");
      final vuelo = Vuelo("V1", 100.0, TarifaBusiness()); // Empieza costando 300.0

      paquete.servicios.add(vuelo);
      expect(paquete.getPrecio(), equals(300.0)); // Comprobación inicial

      // Cambiamos la política dinámicamente de Business a LowCost
      vuelo.politica = TarifaLowCost();

      // El total del paquete debería actualizarse automáticamente a 160.0
      expect(paquete.getPrecio(), equals(160.0));
    });

  });
}