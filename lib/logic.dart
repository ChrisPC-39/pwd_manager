import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
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
  Hive.box('accounts').add(Account("", "", "", false, 0xFFBDBDBD));
  final allAccounts = Hive.box('accounts');

  for(int i = Hive.box('accounts').length - 1; i >= 1 ; i--) {
    final account = allAccounts.getAt(i - 1) as Account;
    allAccounts.putAt(i, account);
  }

  Hive.box('accounts').putAt(0, account);
}

int findIndex(int colorCode) {
  switch(colorCode) {
    case 0xFF66BB6A: return 0;
    case 0xFFEF5350: return 1;
    case 0xFFE0E0E0: return 2;
    case 0xFF42A5F5: return 3;
    case 0xFF1565C0: return 4;
    case 0xFF5C6BC0: return 5;
    case 0xFFFFEE58: return 6;
    case 0xFFFFA726: return 7;
    case 0xFFAB47BC: return 8;
    default: return 0;
  }
}

BoxDecoration buildBoxDecoration(double radius, int color) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: Color(color)
  );
}

OutlineInputBorder outlineBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
}

FocusedMenuItem buildFocusedMenuItem(Widget title, Icon icon, void onPressed(), Color background) {
  return FocusedMenuItem(
    title: title,
    trailingIcon:icon,
    onPressed: () => onPressed(),
    backgroundColor: background
  );
}

TextStyle textStyle({Color color = Colors.black, FontWeight fontWeight = FontWeight.bold, FontStyle fontStyle = FontStyle.normal,  double fontSize = 20}) {
  return TextStyle(
    color: color,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    fontSize: fontSize
  );
}