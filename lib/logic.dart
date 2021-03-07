import 'package:hive/hive.dart';

import 'database/account.dart';

void reorderList(int oldIndex, int newIndex) {
  final accountsBox = Hive.box('accounts');
  final account = accountsBox.getAt(oldIndex);

  if (oldIndex > newIndex) {
    for (int i = oldIndex; i > newIndex; i--) {
      final account = accountsBox.getAt(i - 1) as Account;
      accountsBox.putAt(i, account);
    }

    accountsBox.putAt(newIndex, account);
  } else if (oldIndex < newIndex) {
    for (int i = oldIndex; i < newIndex - 1; i++) {
      final account = accountsBox.getAt(i + 1) as Account;
      accountsBox.putAt(i, account);
    }

    accountsBox.putAt(newIndex - 1, account);
  }
}

void addAccount(Account account) {
  Hive.box('accounts').add(Account("", "", ""));
  final allAccounts = Hive.box('accounts');

  for(int i = Hive.box('accounts').length - 1; i >= 1 ; i--) {
    final account = allAccounts.getAt(i - 1) as Account;
    allAccounts.putAt(i, account);
  }

  Hive.box('accounts').putAt(0, account);
}
