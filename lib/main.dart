import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'database/edit.dart';
import 'screens/add_screen.dart';
import 'database/account.dart';
import 'screens/drawer_screen.dart';
import 'screens/edit_screen.dart';
import 'screens/main_screen.dart';

List<Box> boxList = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(EditAdapter());

  var accBox = await Hive.openBox('accounts');
  var editBox = await Hive.openBox('edit');

  if(editBox.length == 0) editBox.add(Edit("title", "accName", "pwd", false, 0, 0xFFBDBDBD));
  //editBox.clear();
  boxList.add(accBox);
  boxList.add(editBox);

  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('accounts'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasError) return Text(snapshot.error.toString());
          else return ValueListenableBuilder(
            valueListenable: Hive.box("edit").listenable(),
            builder: (context, editBox, _) {
              final edit = boxList[1].getAt(0) as Edit;
              return SafeArea(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Scaffold(
                    backgroundColor: Color(0xFFe0e0e0),
                    body: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DrawerScreen(),
                        MainScreen(),
                        edit.isEditing
                          ? EditScreen()
                          : AddScreen()
                      ]
                    )
                  ),
                )
              );
            }
          );
        } else return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    );
  }
}
