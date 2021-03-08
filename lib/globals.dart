import 'package:pwd_manager/database/account.dart';

Deleted deleted = Deleted();
Reorder reorder = Reorder();

class Deleted {
  List<Account> account = [];
}

class Reorder {
  bool isReordering = false;
}