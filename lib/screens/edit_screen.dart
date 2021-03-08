import 'package:flutter/material.dart';
import 'package:pwd_manager/database/account.dart';
import 'package:pwd_manager/database/edit.dart';
import '../logic.dart' as logic;
import '../main.dart' as main;

class EditScreen extends StatefulWidget {
  final titleController = TextEditingController();
  final accountController = TextEditingController();
  final pwdController = TextEditingController();

  @override
  State<StatefulWidget> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  int colorCode = 0xFF66BB6A;
  int index = 0;
  bool indexSet = false;
  int hoverIndex = -1;

  @override
  Widget build(BuildContext context) {
    fillFields();

    return Column(
      children: [
        _buildAddButton(),
        _buildInput(widget.titleController, "Title", 0),
        _buildInput(widget.accountController, "Username", 1),
        _buildInput(widget.pwdController, "Password", 2),
        _buildColorPicker()
      ]
    );
  }

  void fillFields() {
    final editAcc = main.boxList[1].getAt(0) as Edit;
    widget.titleController.text = editAcc.title;
    widget.accountController.text = editAcc.name;
    widget.pwdController.text = editAcc.password;
    if(!indexSet) {
      colorCode = editAcc.colorCode;
      index = logic.findIndex(editAcc.colorCode);
    }
    indexSet = true;
  }

  void clearFields() {
    widget.titleController.text = "";
    widget.accountController.text = "";
    widget.pwdController.text = "";
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
        child:  Container(
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
    return Row(
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () {
              if(widget.titleController.text != "" && widget.accountController.text != "" && widget.pwdController.text != "") {
                final editAcc = main.boxList[1].getAt(0) as Edit;
                main.boxList[0].putAt(editAcc.index, Account(widget.titleController.text, widget.accountController.text, widget.pwdController.text, false, colorCode));
                main.boxList[1].putAt(0, Edit("", "", "", false, 0, colorCode));

              } else main.boxList[1].putAt(0, Edit("", "", "", false, 0, colorCode));
            },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.indigo[400]),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(20, 5, 5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Update", style: TextStyle(color: Colors.white)),
                  Icon(Icons.update_rounded, color: Colors.white)
                ]
              )
            )
          )
        ),

        Flexible(
          child: GestureDetector(
            onTap: () => main.boxList[1].putAt(0, Edit("", "", "", false, 0, colorCode)),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.red[400]),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cancel", style: TextStyle(color: Colors.white)),
                  Icon(Icons.cancel_rounded, color: Colors.white)
                ]
              )
            )
          )
        )
      ]
    );
  }

  Widget _buildInput(TextEditingController controller, String hintText, int i) {
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
                final editAcc = main.boxList[1].getAt(0) as Edit;
                main.boxList[0].putAt(editAcc.index, Account(widget.titleController.text, widget.accountController.text, widget.pwdController.text, false, 0xFFBDBDBD));
                main.boxList[1].putAt(0, Edit("", "", "", false, 0, colorCode));
                clearFields();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[100],
                enabledBorder: _outlineBorder(),
                focusedBorder: _outlineBorder(),
              )
            )
          ),

          MouseRegion(
            onHover: (event) {
              setState(() {
                hoverIndex = findIndividualField(hintText);
              });
            },
            onExit: (event) {
              setState(() {
                hoverIndex = -1;
              });
            },
            child: GestureDetector(
              onTap: () => clearIndividualField(hintText),
              child: Icon(Icons.cancel_rounded, color: hoverIndex == i ? Colors.grey[700] : Colors.grey),
            )
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
      default:
        break;
    }
  }
}