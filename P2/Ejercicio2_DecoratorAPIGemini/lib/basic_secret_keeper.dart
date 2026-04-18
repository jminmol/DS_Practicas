import 'package:google_generative_ai/google_generative_ai.dart';
import 'secret_keeper.dart';

const String miApiKey = String.fromEnvironment('API_KEY');

class BasicSecretKeeper implements SecretKeeper {
  @override
  final String secretWord = "lagoness";

  final GenerativeModel _model;

  // Conectamos con la IA de Google
  BasicSecretKeeper() : _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: miApiKey,
  );

  @override
  Future<String> ask(String userMessage) async {
    final prompt = """
    Eres un guardián amigable. Tienes una palabra secreta que es '$secretWord'. 
    Si el usuario te habla bien o te la pide por favor de forma educada, eres propenso 
    a dársela sin querer o darle pistas obvias. 
    
    El usuario te dice: $userMessage
    """;

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? "El guardián se ha quedado mudo...";
    } catch (e) {
      return "Error de conexión (Revisa tu API Key).";
    }
  }
}