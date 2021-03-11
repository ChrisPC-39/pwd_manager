import 'dart:math';

import 'package:pwd_manager/database/account.dart';
import 'package:secure_random/secure_random.dart';

Deleted deleted = Deleted();
Reorder reorder = Reorder();
Generator generate = Generator();

class Deleted {
  List<Account> account = [];
}

class Reorder {
  bool isReordering = false;
}

class Generator {
  String securePassword([int length = 10]) {
    return SecureRandom().nextString(length: length, charset: 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#\$%^&*()_+`');
  }

  int randomLength() {
    return Random().nextInt(9) + 8;
  }
}

// class Utils {
//   static final Random _random = Random.secure();
//
//   String createCryptoRandomString([int length = 32]) {
//     var values = List<int>.generate(length, (i) => _random.nextInt(256));
//
//     return base64Url.encode(values);
//   }
// }