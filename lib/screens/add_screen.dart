import 'package:flutter/material.dart';

import '../database/account.dart';
import '../logic.dart' as logic;

class AddScreen extends StatefulWidget {
  final titleController = TextEditingController();
  final accountController = TextEditingController();
  final pwdController = TextEditingController();

  final Account account;

  AddScreen({this.account});

  @override
  State<StatefulWidget> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  int colorCode = 0xFF66BB6A;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAddButton(),
        _buildInput(widget.titleController, "Title"),
        _buildInput(widget.accountController, "Username"),
        _buildInput(widget.pwdController, "Password"),
        _buildColorPicker()
      ]
    );
  }

  void clearFields() {
    widget.titleController.text = "";
    widget.accountController.text = "";
    widget.pwdController.text = "";
  }

  void clearIndividualField(String text) {
    switch(text) {
      case "Title":
        widget.titleController.text = "";
        break;
      case "Username":
        widget.accountController.text = "";
        break;
      case "Password":
        widget.pwdController.text = "";
        break;
      default:
        break;
    }
  }

  Widget _buildColorPicker() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        children: [
          _buildColorContainer(Colors.green[400], 0xFF66BB6A, 0),
          _buildColorContainer(Colors.red[400], 0xFFEF5350, 1),
          _buildColorContainer(Colors.grey[300], 0xFFE0E0E0, 2),
          _buildColorContainer(Colors.blue[400], 0xFF42A5F5, 3),
          _buildColorContainer(Colors.blue[800], 0xFF1565C0, 4),
          _buildColorContainer(Colors.indigo[400], 0xFF5C6BC0, 5),
          _buildColorContainer(Colors.yellow[400], 0xFFFFEE58, 6),
          _buildColorContainer(Colors.orange[400], 0xFFFFA726, 7),
          _buildColorContainer(Colors.purple[400], 0xFFAB47BC, 8),
        ]
      )
    );
  }

  Widget _buildColorContainer(Color color, int code, int i) {
    return Flexible(
      child: GestureDetector(
        onTap: () => setState(() { index = i; colorCode = code; }),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
          margin: EdgeInsets.only(right: 2),
          width: 50,
          height: 50,
          child: i == index ? Icon(Icons.check_rounded) : Container()
        )
      )
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        logic.addAccount(new Account(widget.titleController.text, widget.accountController.text, widget.pwdController.text, false, colorCode));
        clearFields();
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(colorCode)),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(20, 5, 10, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Add", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            Icon(Icons.add_rounded, color: Colors.black)
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
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: controller,
              onSubmitted: (value) {
                logic.addAccount(new Account(widget.titleController.text, widget.accountController.text, widget.pwdController.text, false, colorCode));
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
          ),

          GestureDetector(
            onTap: () => clearIndividualField(hintText),
            child: Icon(Icons.cancel_rounded, color: Colors.grey),
          )
        ]
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