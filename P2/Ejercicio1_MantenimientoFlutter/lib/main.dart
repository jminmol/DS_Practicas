import 'package:flutter/material.dart';
import 'core/AuthenticationService.dart';
import 'core/FilterManager.dart';
import 'filters/EmailTextFilter.dart';
import 'filters/EmailDomainFilter.dart';
import 'filters/DuplicateEmailFilter.dart';
import 'filters/PasswordLengthFilter.dart';
import 'filters/PasswordNumberFilter.dart';
import 'filters/PasswordSpecialFilter.dart';
import 'Cliente.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filtros Flutter',
      debugShowCheckedModeBanner: false, // quitamos la etiqueta de "DEBUG"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // controladores para capturar el texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  // variable: controla si la contraseña está oculta o visible
  bool _ocultarPassword = true;

  void _validarRegistro() {
    // 1. configuramos el sistema
    final authService = AuthenticationService();
    final manager = FilterManager(authService);
    
    manager.addFilter(EmailTextFilter());
    manager.addFilter(EmailDomainFilter());
    manager.addFilter(DuplicateEmailFilter()); // mantenimiento preventivo
    manager.addFilter(PasswordLengthFilter());
    manager.addFilter(PasswordNumberFilter());
    manager.addFilter(PasswordSpecialCharFilter());

    final cliente = Cliente(manager);

    // creamos la petición
    final request = {
      'email': _emailController.text,
      'password': _passController.text,
    };

    // ocultamos el teclado virtual del móvil al darle al botón
    FocusScope.of(context).unfocus();

    // ejecutamos y capturamos el resultado
    final error = cliente.sendRequest(request);

    // sistema de notificaciones
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text('RECHAZADO: $error')),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    } else {
      // guardamos el correo si se autenticó con exito
      DuplicateEmailFilter.database.add(_emailController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('¡ÉXITO: Correo verificado y guardado!'),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100, // fondo gris claro para contrastar con la tarjeta
      body: Center(
        child: SingleChildScrollView( // permite hacer scroll si el teclado tapa la pantalla
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // icono decorativo de cabecera
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.security_rounded, 
                      size: 48, 
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // títulos
                  const Text(
                    'Validación de Filtros',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Introduce los datos a verificar',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 32),

                  // email
                  TextField(
                    controller: _emailController, 
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    )
                  ),
                  const SizedBox(height: 16),

                  // contraseña
                  TextField(
                    controller: _passController, 
                    obscureText: _ocultarPassword, 
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarPassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarPassword = !_ocultarPassword;
                          });
                        },
                      ),
                    ), 
                  ),
                  const SizedBox(height: 32),

                  // botón validar
                  SizedBox(
                    width: double.infinity, // ocupa todo el ancho disponible
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _validarRegistro, 
                      child: const Text(
                        'Ejecutar Filtros',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}