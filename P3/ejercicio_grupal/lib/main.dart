// main.dart
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
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
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
  Paquete? paqueteRaiz;

  // controladores de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _nochesController = TextEditingController();

  // crea el paquete principal con el nombre introducido
  void _crearPaquete() {
    if (_nombreController.text.isNotEmpty) {
      setState(() {
        paqueteRaiz = Paquete(_nombreController.text);
      });
    }
  }

  // muestra un pop-up para añadir un vuelo con precio dinámico
  void _mostrarDialogoVuelo(PoliticaVuelo politica, String tipo) {
    _precioController.text = "100.0"; // valor por defecto
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Configurar Vuelo $tipo"),
        content: TextField(
          controller: _precioController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Precio Base (€)", border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              final precio = double.tryParse(_precioController.text) ?? 100.0;
              try {
                // Creamos el vuelo
                final nuevoVuelo = Vuelo(tipo, precio, politica);
                setState(() {
                  paqueteRaiz?.servicios.add(nuevoVuelo);
                });
                Navigator.pop(context); // Cerramos pop-up si todo va bien
              } catch (e) {
                // Si el precio era negativo y avisamos al usuario
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error: El precio no puede ser negativo.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Añadir"),
          ),
        ],
      ),
    );
  }

  // muestra un pop-up para añadir un hotel con precio y noches dinámicos
  void _mostrarDialogoHotel(PoliticaHotel politica, String tipo) {
    _precioController.text = "50.0"; // valor por defecto
    _nochesController.text = "1";    // noches por defecto
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Configurar Hotel $tipo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Precio/Noche (€)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nochesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Número de Noches", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              final precio = double.tryParse(_precioController.text) ?? 50.0;
              final noches = int.tryParse(_nochesController.text) ?? 1;
              try {
                // Creamos el hotel
                final nuevoHotel = Hotel(tipo, precio, noches, politica);
                setState(() {
                  paqueteRaiz?.servicios.add(nuevoHotel);
                });
                Navigator.pop(context); // Cerramos pop-up si todo va bien
              } catch (e) {
                // Error por las noches si son 0 o negativas
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error: Revisa que las noches sean mayores a 0.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Añadir"),
          ),
        ],
      ),
    );
  }

  // limpia todos los servicios y destruye el paquete actual
  void _resetearTodo() {
    setState(() {
      paqueteRaiz = null;
      _nombreController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(paqueteRaiz == null ? "Crear Nuevo Viaje" : paqueteRaiz!.nombre),
        centerTitle: true,
        actions: paqueteRaiz != null
            ? [
          // boton para vaciar el paquete y volver al inicio
          IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _resetearTodo,
              tooltip: 'Vaciar paquete'
          )
        ]
            : null,
      ),
      // Si no hay paquete, mostramos creación, si lo hay, mostramos gestión
      body: paqueteRaiz == null ? _buildPantallaCreacion() : _buildPantallaGestion(),
    );
  }

  // --- WIDGET DE CREACIÓN ---
  Widget _buildPantallaCreacion() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.travel_explore, size: 64, color: Colors.teal),
                const SizedBox(height: 16),
                const Text("¡Bienvenido!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text("Introduce el nombre de tu paquete vacacional"),
                const SizedBox(height: 20),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre del Viaje', border: OutlineInputBorder(), prefixIcon: Icon(Icons.edit)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _crearPaquete,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                  child: const Text("Comenzar a Planificar"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET DE GESTIÓN ---
  Widget _buildPantallaGestion() {
    return Column(
      children: [
        // muestra el precio total actualizado
        Container(
          padding: const EdgeInsets.all(20),
          color: Colors.teal.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total del Paquete:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                "${paqueteRaiz!.getPrecio().toStringAsFixed(2)} €",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
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
              _buildBotonAccion("Vuelo LowCost", Icons.flight_takeoff, () => _mostrarDialogoVuelo(TarifaLowCost(), "LowCost")),
              _buildBotonAccion("Vuelo Business", Icons.flight, () => _mostrarDialogoVuelo(TarifaBusiness(), "Business")),
              _buildBotonAccion("Solo Alojamiento", Icons.hotel, () => _mostrarDialogoHotel(SoloAlojamiento(), "Básico")),
              _buildBotonAccion("Todo Incluido", Icons.room_service, () => _mostrarDialogoHotel(TodoIncluido(), "Premium")),
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
            itemCount: paqueteRaiz!.servicios.length,
            itemBuilder: (context, index) {
              final servicio = paqueteRaiz!.servicios[index];
              String titulo = "Servicio";
              IconData icono = Icons.card_travel;

              // comprobamos el tipo de servicio
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
                trailing: Text("${servicio.getPrecio().toStringAsFixed(2)} €", style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          ),
        ),
      ],
    );
  }

  // ayuda para construir los botones
  Widget _buildBotonAccion(String etiqueta, IconData icono, VoidCallback accion) {
    return ElevatedButton.icon(
      icon: Icon(icono, size: 18),
      label: Text(etiqueta),
      onPressed: accion,
    );
  }
}