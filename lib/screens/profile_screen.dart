import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('The Coding Papa'),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: null,
              ),
            ],
          )
        ],
      ),
    );
  }
}
