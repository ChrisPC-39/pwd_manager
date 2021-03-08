import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pwd_manager/database/edit.dart';

import '../database/account.dart';
import '../logic.dart' as logic;
import '../main.dart' as main;

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  TextEditingController nameController = TextEditingController();
  bool isHovering = false;
  bool copyName = false;
  bool copyPwd = false;
  bool censor = true;
  int hoverIndex = -1;
  int copyIndex = -1;

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

  void copyToClipboard(String text, int i, bool isPwd) {
    Clipboard.setData(new ClipboardData(text: text));

    setState(() {
      isPwd ? copyPwd = true : copyName = true;
      copyIndex = i;
    });
    Future.delayed(Duration(seconds: 1), () {
      isPwd ? copyPwd = false : copyName = false;
      copyIndex = -1;
    });
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

  Widget _buildTitleRow(Account account, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SelectableText(account.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        _buildMenu(i, account)
      ]
    );
  }

  Widget _buildMenu(int i, Account account) {
    return Visibility(
      visible: isHovering && hoverIndex == i,
      child: Row(
        children: [
          // GestureDetector(
          //   onTap: () => setState(() { censor = !censor; }),
          //   child: Icon(censor ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.grey[800])
          // ),

          // Container(width: 10),

          GestureDetector(
            onTap: () => main.boxList[1].putAt(0, new Edit(account.title, account.name, account.password, true, i)),
            child: Icon(Icons.edit_rounded, color: Colors.grey[800])
          ),

          Container(width: 10),

          GestureDetector(
            onTap: () => Hive.box('accounts').deleteAt(i),
            child: Icon(Icons.delete_rounded, color: Colors.grey[800])
          )
        ]
      )
    );
  }

  //The following 2 functions are completely cursed.
  Widget _buildNameRow(Account account, int i) {
    // String censoredText = "";
    // for(int i = 0; i < account.name.length; i++)
    //   censoredText += "*";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //censor || hoverIndex != i
        //? Text(censoredText, style: TextStyle(fontSize: 18))
        SelectableText(account.name, style: TextStyle(fontSize: 18)),

        GestureDetector(
          onTap: () => copyToClipboard(account.name, i, false),
          child: copyIndex == i && copyName
            ? Text("Copied!", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
            : Icon(Icons.copy_rounded, color: Colors.grey[800])
        )
      ]
    );
  }

  Widget _buildPwdRow(Account account, int i) {
    // String censoredText = "";
    // for(int i = 0; i < account.password.length; i++)
    //   censoredText += "*";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //censor || hoverIndex != i
        //? Text(censoredText, style: TextStyle(fontSize: 18))
        SelectableText(account.password, style: TextStyle(fontSize: 18)),

        GestureDetector(
          onTap: () => copyToClipboard(account.password, i, true),
          child: copyPwd == true && copyIndex == i
            ? Text("Copied!", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))
            : Icon(Icons.copy_rounded, color: Colors.grey[800])
        )
      ]
    );
  }

  Widget _buildContainer(int i) {
    final account = Hive.box('accounts').getAt(i) as Account;

    return FocusedMenuHolder(
      menuWidth: MediaQuery.of(context).size.width * 0.34,
      onPressed: () {},
      key: UniqueKey(),
      menuItems: [
        FocusedMenuItem(
          title: Text("Edit", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold)),
          trailingIcon: Icon(Icons.edit_rounded, color: Colors.grey[800]),
          onPressed: () => main.boxList[1].putAt(0, new Edit(account.title, account.name, account.password, true, i))
        ),

        FocusedMenuItem(
          title: Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          trailingIcon: Icon(Icons.delete_rounded, color: Colors.white),
          backgroundColor: Colors.red[400],
          onPressed: () => Hive.box('accounts').deleteAt(i),
        )
      ],
      child: MouseRegion(
        onHover: (event) { setState(() {
          isHovering = true;
          hoverIndex = i;
        }); },
        onExit: (event) { setState(() {
          isHovering = false;
          hoverIndex = -1;
          censor = true;
        }); },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Column(
            children: [
              _buildTitleRow(account, i),
              Divider(thickness: 1),
              _buildNameRow(account, i),
              Divider(thickness: 1),
              _buildPwdRow(account, i)
            ]
          )
        )
      ),
    );
  }
}