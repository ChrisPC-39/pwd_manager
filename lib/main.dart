import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'screens/add_screen.dart';
import 'database/account.dart';
import 'screens/drawer_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(AccountAdapter());

  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('accounts'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError) return Text(snapshot.error.toString());
          else return Scaffold(
            body: SafeArea(
              child: Scaffold(
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: DrawerScreen()),
                    Expanded(flex: 2, child: MainScreen()),
                    Expanded(flex: 3, child: AddScreen())
                  ]
                )
              )
            )
          );
        } else return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    );
  }
}
