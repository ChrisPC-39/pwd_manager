import 'package:flutter/material.dart';

import 'package:pwd_manager/globals.dart';
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
  int hoverIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      child: Column(
        children: [
          _buildAddButton(),
          _buildInput(widget.titleController, "Title", 0),
          _buildInput(widget.accountController, "Username", 1),
          _buildInput(widget.pwdController, "Password", 2),
          _buildColorPicker()
        ]
      )
    );
  }

  Widget _buildRandomGeneratorButton() {
    return Container(
      height: 52,
      margin: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(colorCode)),
      child: TextButton(
        onPressed: () {
          widget.pwdController.text = generate.securePassword(generate.randomLength());
        },
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Icon(Icons.admin_panel_settings_rounded, color: Colors.black)
          //child: Text("Generate", style: logic.textStyle(fontSize: 15, fontWeight: FontWeight.normal)),
        )
      )
    );
  }

  Widget _buildColorPicker() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        children: [
          _buildColorContainer(Colors.green[400], 0xFF66BB6A, 0),
          _buildColorContainer(Colors.red[400], 0xFFEF5350, 1),
          _buildColorContainer(Colors.grey[400], 0xFFBDBDBD, 2),
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
        logic.addAccount(new Account(widget.titleController.text, widget.accountController.text, widget.pwdController.text, false, colorCode, false));
        clearFields();
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(colorCode)),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
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

  Widget _buildInput(TextEditingController controller, String hintText, int i) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: controller,
              onChanged: (value) {
                if(value.contains("")) clearIndividualField(hintText);
              },
              onSubmitted: (value) {
                logic.addAccount(new Account(widget.titleController.text, widget.accountController.text, widget.pwdController.text, false, colorCode, false));
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

          Visibility(
            visible: findIndividualField(hintText) == 2,
            child: _buildRandomGeneratorButton()
          ),

          MouseRegion(
            onHover: (event) {
              setState(() { hoverIndex = findIndividualField(hintText); });
            },
            onExit: (event) {
              setState(() { hoverIndex = -1; });
            },
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: GestureDetector(
                onTap: () => clearIndividualField(hintText),
                child: Icon(Icons.cancel_rounded, color: hoverIndex == i ? Colors.grey[700] : Colors.grey),
              ),
            )
          )
        ]
      )
    );
  }

  OutlineInputBorder _outlineBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(10)),
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

  int findIndividualField(String text) {
    switch(text) {
      case "Title": return 0;
      case "Username": return 1;
      case "Password": return 2;
      default: return 0;
    }
  }
}