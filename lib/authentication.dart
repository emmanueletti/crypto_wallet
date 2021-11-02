import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
        child: Column(
          children: [
            TextFormField(),
            TextFormField(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
