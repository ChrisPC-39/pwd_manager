import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pwd_manager/database/account.dart';
import 'package:pwd_manager/deleted.dart';

import '../logic.dart' as logic;

class DrawerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[400],
      child: Column(
        children: [
          _buildTile(
            Icon(Icons.delete_forever_rounded),
            Text("Delete all"),
            () { _showDeleteDialog(context); }
          ),

          _buildTile(
            Icon(deleted.account.length == 0 ? Icons.do_not_disturb : Icons.undo_rounded),
            Text(deleted.account.length == 0 ? "Nothing to undo" : "Undo"),
            () {
              for(int i = 0; i < deleted.account.length; i++)
                logic.addAccount(deleted.account.elementAt(i));
              deleted.account.clear();
              setState(() {});
            }
          ),

          _buildTile(
            Icon(Icons.file_copy_outlined),
            Text("View licenses"),
            () { _showLicensesDialog(context); }
          ),

          _buildTile(
            Icon(Icons.info_outline_rounded),
            Text("About"),
            () { _showAboutDialog(context); }
          )
        ]
      )
    );
  }

  Widget _buildTile(Icon icon, Widget title, void onPressed()) {
    return ListTile(
      leading: icon,
      title: title,
      onTap: () { onPressed(); },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("About"),
          content: Text("\${PASSWORD_MANAGER.title} is a free, open source and offline app to help you save your passwords. Keeping any sensitive information online is a risk, this is why this app is entirely offline! Don't send your data to anyone!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Amazing!")
            )
          ]
        );
      }
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete all items?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop()
            ),

            TextButton(
              child: Text("Delete"),
              onPressed: () {
                final accountsBox = Hive.box('accounts');

                for(int i = 0; i < accountsBox.length; i++) {
                  final account = accountsBox.getAt(i) as Account;
                  deleted.account.add(account);
                }

                accountsBox.clear();
                Navigator.of(context).pop();
              }
            )
          ]
        );
      }
    );
  }

  void _showLicensesDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationIcon: FlutterLogo(),
      applicationName: "Password Manager",
      applicationVersion: '0.3.0',
      applicationLegalese: "Enjoy offline storage for your valuable accounts!"
    );
  }
}