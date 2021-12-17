// import dos pacotes
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage();

// deletar todos os tokens
class DeleteAll {

  void deleteAllTokens() async {
    await _storage.deleteAll();
  }

}

// deletar um token especifico
class DeleteOnly {

  void deleteOnlyToken( String keyName ) async {

    await _storage.delete(key: keyName);
  }

}