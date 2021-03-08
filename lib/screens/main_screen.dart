import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pwd_manager/database/edit.dart';

import '../database/account.dart';
import '../main.dart' as main;

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  TextEditingController titleController = TextEditingController();
  bool isHovering = false;
  bool copyName = false;
  bool copyPwd = false;
  int hoverIndex = -1;
  int copyIndex = -1;
  String input = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildListView()
      ]
    );
  }

  Widget _buildListView() {
    final accBox = Hive.box('accounts');

    return ValueListenableBuilder(
      valueListenable: Hive.box('accounts').listenable(),
      builder: (context, accountsBox, _) {
        return Flexible(
          child: ListView.builder(
            key: listKey,
            physics: BouncingScrollPhysics(),
            itemCount: Hive.box('accounts').length,
            itemBuilder: (context, index) {
              final account = accBox.getAt(index) as Account;
              return !account.title.toLowerCase().contains(input)
                ? Container()
                : _buildContainer(index);
            }
          )
        );
      }
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      height: 45,
      child: TextField(
        enableSuggestions: true,
        controller: titleController,
        onChanged: (String value) {
          if(value.contains("")) titleController.text = "";
          setState(() { input = value.toLowerCase(); });
        },
        onSubmitted: (value) {},
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          enabledBorder: _outlineBorder(),
          focusedBorder: _outlineBorder(),
          hintText: "Search for an account",
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey),
        )
      )
    );
  }

  Widget _buildTitleRow(Account account, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: SelectableText(account.title, style: _textStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        _buildMenu(i, account)
      ]
    );
  }

  Widget _buildMenu(int i, Account account) {
    return Visibility(
      visible: isHovering && hoverIndex == i,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => main.boxList[1].putAt(0, new Edit(account.title, account.name, account.password, true, i, account.colorCode)),
            child: Icon(Icons.edit_rounded, color: Colors.grey[800])
          ),

          Container(width: 10),

          GestureDetector(
            onTap: () {
              Hive.box('accounts').deleteAt(i);
              main.boxList[1].putAt(0, new Edit(account.title, account.name, account.password, false, i, account.colorCode));
            },
            child: Icon(Icons.delete_rounded, color: Colors.grey[800])
          )
        ]
      )
    );
  }

  //The following 2 functions are completely cursed.
  Widget _buildNameRow(Account account, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Flexible(child: SelectableText(account.name, style: _textStyle(fontSize: 18, fontWeight: FontWeight.normal))),

      //COPY BUTTON
      GestureDetector(
        onTap: () => copyToClipboard(account.name, i, false),
        child: copyIndex == i && copyName
          ? Text("Copied!", style: _textStyle(color: Colors.grey[800], fontStyle: FontStyle.italic, fontSize: 10))
          : Icon(Icons.copy_rounded, color: Colors.grey[800])
        )
      ]
    );
  }

  Widget _buildPwdRow(Account account, int i) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Flexible(child: SelectableText(account.password, style: TextStyle(fontSize: 18))),

      //COPY BUTTON
      GestureDetector(
        onTap: () => copyToClipboard(account.password, i, true),
        child: copyIndex == i && copyPwd
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
      menuItems: _buildFocusedMenuItemList(account, i),
      child: MouseRegion(
        onHover: (event) { _buildOnHover(i); },
        onExit: (event) { _buildOnExit(); },
        child: Container(
          decoration: _buildBoxDecoration(10, account.colorCode),
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
      )
    );
  }

  BoxDecoration _buildBoxDecoration(double radius, int color) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Color(color)
    );
  }

  List<FocusedMenuItem> _buildFocusedMenuItemList(Account account, int i) {
    return [
      _buildFocusedMenuItem(
        Text("Edit", style: _textStyle(color: Colors.grey[800])),
        Icon(Icons.edit_rounded, color: Colors.grey[800]),
        () { main.boxList[1].putAt(0, new Edit(account.title, account.name, account.password, true, i, account.colorCode)); },
        Colors.white
      ),

      _buildFocusedMenuItem(
        Text("Delete", style: _textStyle(color: Colors.white)),
        Icon(Icons.delete_rounded, color: Colors.white),
        () { Hive.box('accounts').deleteAt(i); },
        Colors.red[400]
      )
    ];
  }

  FocusedMenuItem _buildFocusedMenuItem(Widget title, Icon icon, void onPressed(), Color background) {
    return FocusedMenuItem(
      title: title,
      trailingIcon:icon,
      onPressed: () => onPressed(),
      backgroundColor: background
    );
  }

  TextStyle _textStyle({Color color = Colors.black, FontWeight fontWeight = FontWeight.bold, FontStyle fontStyle = FontStyle.normal,  double fontSize = 20}) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize
    );
  }

  OutlineInputBorder _outlineBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(10)),
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

  void _buildOnHover(int i) {
    setState(() {
      isHovering = true;
      hoverIndex = i;
    });
  }

  void _buildOnExit() {
    setState(() {
      isHovering = false;
      hoverIndex = -1;
    });
  }
}