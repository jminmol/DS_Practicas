import 'secret_keeper.dart';
import 'secret_keeper_decorator.dart';

class LengthLimitDecorator extends SecretKeeperDecorator {
  LengthLimitDecorator(SecretKeeper wrappee) : super(wrappee);

  @override
  Future<String> ask(String userMessage) async {
    String response = await super.ask(userMessage);

    if (response.length > 200) {
      return "${response.substring(0, 200)}...\n\n🔇 [El sistema silencia al guardián por hablar demasiado]";
    }

    return response;
  }
}