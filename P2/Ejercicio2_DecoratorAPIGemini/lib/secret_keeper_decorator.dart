import 'secret_keeper.dart';

abstract class SecretKeeperDecorator implements SecretKeeper {
  final SecretKeeper wrappee;

  SecretKeeperDecorator(this.wrappee);

  @override
  String get secretWord => wrappee.secretWord;

  @override
  Future<String> ask(String userMessage) async {
    return await wrappee.ask(userMessage);
  }
}