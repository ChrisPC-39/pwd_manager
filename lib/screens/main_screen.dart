import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../database/account.dart';
import '../logic.dart' as logic;

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildListView()
        ]
      )
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
      valueListenable: Hive.box('accounts').listenable(),
      builder: (context, accountsBox, _) {
        return Flexible(
          child: ReorderableListView(
            key: listKey,
            onReorder: logic.reorderList,
            physics: BouncingScrollPhysics(),
            children: [
              for(int i = 0; i < Hive.box('accounts').length; i++)
                _buildContainer(i)
            ]
          )
        );
      }
    );
  }

  Widget _buildContainer(int i) {
    final account = Hive.box('accounts').getAt(i) as Account;

    return Dismissible(
      onDismissed: (dir) => Hive.box('accounts').deleteAt(i),
      key: UniqueKey(),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 20),
                Text(account.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Icon(Icons.edit_rounded, color: Colors.grey[800])
              ]
            ),

            Divider(thickness: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(account.name, style: TextStyle(fontSize: 18)),
                Icon(Icons.open_in_new_rounded, color: Colors.grey[800])
              ]
            ),

            Divider(thickness: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(account.password, style: TextStyle(fontSize: 18)),
                Icon(Icons.open_in_new_rounded, color: Colors.grey[800])
              ]
            )
          ]
        )
      )
    );
  }
}