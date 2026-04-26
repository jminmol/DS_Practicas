import 'package:flutter/material.dart';
import 'interfaces/PoliticaHotel.dart';
import 'interfaces/PoliticaVuelo.dart';
import 'interfaces/ServicioTuristico.dart';
import 'clases/Hotel.dart';
import 'clases/Vuelo.dart';
import 'clases/TarifaBusiness.dart';
import 'clases/TarifaLowCost.dart';
import 'clases/SoloAlojamiento.dart';
import 'clases/TodoIncluido.dart';
import 'clases/Paquete.dart';

// punto de entrada
void main() {
  runApp(const MyApp());
}

// widget principal
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema de Reservas',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const PantallaReservas(),
    );
  }
}

// pantalla de reservas con estado
class PantallaReservas extends StatefulWidget {
  const PantallaReservas({Key? key}) : super(key: key);

  @override
  State<PantallaReservas> createState() => _PantallaReservasState();
}

class _PantallaReservasState extends State<PantallaReservas> {
  // paquete principal
  final Paquete paqueteRaiz = Paquete("Viaje de Ensueño");

  // añade un vuelo con precio base de 100
  void _agregarVuelo(PoliticaVuelo politica, String tipo) {
    setState(() {
      paqueteRaiz.servicios.add(Vuelo("Vuelo $tipo", 100.0, politica));
    });
  }

  // añade un hotel de 50 la noche por 3 noches
  void _agregarHotel(PoliticaHotel politica, String tipo) {
    setState(() {
      paqueteRaiz.servicios.add(Hotel("Hotel $tipo", 50.0, 3, politica));
    });
  }

  // limpia todos los servicios del paquete
  void _limpiarPaquete() {
    setState(() {
      paqueteRaiz.servicios.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(paqueteRaiz.nombre),
        actions: [
          // boton para vaciar el paquete
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _limpiarPaquete,
            tooltip: 'Vaciar paquete',
          )
        ],
      ),
      body: Column(
        children: [
          // muestra el precio total actualizado
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.teal.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total del Paquete:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${paqueteRaiz.getPrecio().toStringAsFixed(2)} €",
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),

          // botones para configurar servicios
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.flight_takeoff),
                  label: const Text("Añadir Vuelo (LowCost)"),
                  onPressed: () => _agregarVuelo(TarifaLowCost(), "Low Cost"),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.flight),
                  label: const Text("Añadir Vuelo (Business)"),
                  onPressed: () => _agregarVuelo(TarifaBusiness(), "Business"),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.hotel),
                  label: const Text("Añadir Hotel (Solo Alojam.)"),
                  onPressed: () => _agregarHotel(SoloAlojamiento(), "Básico"),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.room_service),
                  label: const Text("Añadir Hotel (Todo Incluido)"),
                  onPressed: () => _agregarHotel(TodoIncluido(), "Lujo"),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // titulo de la seccion
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Servicios en el paquete:", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          
          // lista dinamica de los servicios añadidos
          Expanded(
            child: ListView.builder(
              itemCount: paqueteRaiz.servicios.length,
              itemBuilder: (context, index) {
                final servicio = paqueteRaiz.servicios[index];
                String titulo = "";
                IconData icono = Icons.card_travel;

                // verifica el tipo de servicio para cambiar icono y texto
                if (servicio is Vuelo) {
                  titulo = "${servicio.id} (Base: ${servicio.precioBase}€)";
                  icono = Icons.flight;
                } else if (servicio is Hotel) {
                  titulo = "${servicio.nombre} (${servicio.noches} noches a ${servicio.precioNoche}€)";
                  icono = Icons.hotel;
                }

                return ListTile(
                  leading: Icon(icono, color: Colors.teal),
                  title: Text(titulo),
                  trailing: Text(
                    "${servicio.getPrecio().toStringAsFixed(2)} €",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}