import 'package:flutter/material.dart';

class DrawerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[400],
      child: Column(
        children: [
          _buildTile(Icon(Icons.home_rounded), Text("PLACEHOLDER")),
          _buildTile(Icon(Icons.ac_unit), Text("PLACEHOLDER"))
        ]
      )
    );
  }

  Widget _buildTile(Icon icon, Widget title) {
    return ListTile(
      leading: icon,
      title: title
    );
  }
}