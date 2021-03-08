import 'package:pwd_manager/database/account.dart';

Deleted deleted = Deleted();
Reorder reorder = Reorder();
ResizeDrawer resizeDrawer = ResizeDrawer();

class Deleted {
  List<Account> account = [];
}

class Reorder {
  bool isReordering = false;
}

class ResizeDrawer {
  bool increaseDrawerSize = true;
}