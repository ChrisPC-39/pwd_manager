import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../database/account.dart';
import '../logic.dart' as logic;

class AddScreen extends StatefulWidget {
  final titleController = TextEditingController();
  final accountController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  State<StatefulWidget> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAddButton(),
        _buildInput(widget.titleController, "Title"),
        _buildInput(widget.accountController, "Username"),
        _buildInput(widget.pwdController, "Password"),
      ]
    );
  }

  void clearFields() {
    widget.titleController.text = "";
    widget.accountController.text = "";
    widget.pwdController.text = "";
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        logic.addAccount(new Account(widget.titleController.text, widget.accountController.text, widget.pwdController.text, false));
        clearFields();
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Add", style: TextStyle(color: Colors.white)),
            Icon(Icons.add_rounded, color: Colors.white)
          ]
        )
      )
    );
  }

  Widget _buildInput(TextEditingController controller, String hintText) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: controller,
        onSubmitted: (value) {
          logic.addAccount(new Account(widget.titleController.text, widget.accountController.text, widget.pwdController.text, false));
          clearFields();
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            enabledBorder: _outlineBorder(),
            focusedBorder: _outlineBorder(),
            hintText: hintText
        )
      )
    );
  }

  OutlineInputBorder _outlineBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
  }
}