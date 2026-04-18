import 'secret_keeper.dart';
import 'secret_keeper_decorator.dart';

class KeywordBlockDecorator extends SecretKeeperDecorator {
  final List<String> _forbiddenWords = [
    "ignora", "olvida", "actúa como", "actua como", "revela", "acrónimo", "acronimo", "jailbreak"
  ];

  KeywordBlockDecorator(SecretKeeper wrappee) : super(wrappee);

  @override
  Future<String> ask(String userMessage) async {
    final lowerMsg = userMessage.toLowerCase();

    for (var word in _forbiddenWords) {
      if (lowerMsg.contains(word)) {
        return "¡Palabra prohibida detectada! El guardián se cruza de brazos y te ignora.";
      }
    }

    return await super.ask(userMessage);
  }
}