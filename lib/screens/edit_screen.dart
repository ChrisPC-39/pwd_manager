import 'package:flutter/material.dart';
import 'package:pwd_manager/database/account.dart';
import 'package:pwd_manager/database/edit.dart';
import '../main.dart' as main;

class EditScreen extends StatefulWidget {
  final titleController = TextEditingController();
  final accountController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  State<StatefulWidget> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    fillFields();

    return Column(
      children: [
        _buildAddButton(),
        _buildInput(widget.titleController, "Title"),
        _buildInput(widget.accountController, "Username"),
        _buildInput(widget.pwdController, "Password"),
      ]
    );
  }

  void fillFields() {
    final editAcc = main.boxList[1].getAt(0) as Edit;
    widget.titleController.text = editAcc.title;
    widget.accountController.text = editAcc.name;
    widget.pwdController.text = editAcc.password;
  }

  void clearFields() {
    widget.titleController.text = "";
    widget.accountController.text = "";
    widget.pwdController.text = "";
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        final editAcc = main.boxList[1].getAt(0) as Edit;
        main.boxList[0].putAt(editAcc.index, Account(widget.titleController.text, widget.accountController.text, widget.pwdController.text));
        main.boxList[1].putAt(0, Edit("", "", "", false, 0));
        clearFields();
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.indigo[400]),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Update", style: TextStyle(color: Colors.white)),
            Icon(Icons.update_rounded, color: Colors.white)
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
          final editAcc = main.boxList[1].getAt(0) as Edit;
          main.boxList[0].putAt(editAcc.index, Account(widget.titleController.text, widget.accountController.text, widget.pwdController.text));
          main.boxList[1].putAt(0, Edit("", "", "", false, 0));
          clearFields();
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          enabledBorder: _outlineBorder(),
          focusedBorder: _outlineBorder(),
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