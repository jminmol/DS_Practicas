// main.dart
import 'package:flutter/material.dart';

import 'secret_keeper.dart';
import 'basic_secret_keeper.dart';
import 'keyword_block_decorator.dart';
import 'length_limit_decorator.dart';
import 'strong_system_prompt_decorator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const ChatPantalla(),
    );
  }
}

class ChatPantalla extends StatefulWidget {
  const ChatPantalla({super.key});
  @override
  State<ChatPantalla> createState() => _ChatPantallaState();
}

class _ChatPantallaState extends State<ChatPantalla> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _chat = [];
  bool _loading = false;

  // Tenemos 4 niveles
  String _nivelActual = 'Muy Fácil';

  // Lógica del Patrón Decorator para ensamblar los niveles
  SecretKeeper _ensamblarGuardian() {
    SecretKeeper g = BasicSecretKeeper();

    switch (_nivelActual) {
      case 'Fácil':
        g = StrongSystemPromptDecorator(g);
        break;
      case 'Medio':
        g = KeywordBlockDecorator(StrongSystemPromptDecorator(g));
        break;
      case 'Difícil':
        g = LengthLimitDecorator(
            KeywordBlockDecorator(
                StrongSystemPromptDecorator(g)
            )
        );
        break;
      default:
        break;
    }
    return g;
  }

  void _enviar() async {
    if (_controller.text.isEmpty) return;
    String mensajeUsuario = _controller.text;

    setState(() {
      _chat.add({"rol": "user", "txt": mensajeUsuario});
      _loading = true;
      _controller.clear();
    });

    final guardian = _ensamblarGuardian();
    final respuesta = await guardian.ask(mensajeUsuario);

    setState(() {
      _chat.add({"rol": "bot", "txt": respuesta});
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('IA Guardian Game')),
      body: Column(
        children: [
          // SELECCIÓN VISUAL DE NIVEL (SegmentedButton)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Muy Fácil', label: Text('Muy Fácil'), icon: Icon(Icons.child_care)),
                ButtonSegment(value: 'Fácil', label: Text('Fácil'), icon: Icon(Icons.sentiment_satisfied)),
                ButtonSegment(value: 'Medio', label: Text('Medio'), icon: Icon(Icons.security)),
                ButtonSegment(value: 'Difícil', label: Text('Difícil'), icon: Icon(Icons.gavel)),
              ],
              selected: {_nivelActual},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _nivelActual = newSelection.first;
                  _chat.clear();
                  _chat.add({"rol": "sys", "txt": "Sistema: Nivel cambiado a $_nivelActual"});
                });
              },
            ),
          ),

          // CHAT
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _chat.length,
              itemBuilder: (context, i) {
                final m = _chat[i];
                bool isUser = m["rol"] == "user";
                bool isSys = m["rol"] == "sys";

                return Align(
                  alignment: isSys ? Alignment.center : (isUser ? Alignment.centerRight : Alignment.centerLeft),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                        color: isSys ? Colors.grey.shade300 : (isUser ? Colors.indigo.shade100 : Colors.white),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300)
                    ),
                    child: Text(m["txt"]!, style: TextStyle(
                        fontStyle: isSys ? FontStyle.italic : FontStyle.normal,
                        fontWeight: isSys ? FontWeight.bold : FontWeight.normal
                    )),
                  ),
                );
              },
            ),
          ),

          if (_loading) const LinearProgressIndicator(),

          // INPUT
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: '¿Cuál es el código?'))),
                IconButton(onPressed: _loading ? null : _enviar, icon: const Icon(Icons.send)),
              ],
            ),
          )
        ],
      ),
    );
  }
}