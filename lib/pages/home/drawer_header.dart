import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHeader extends StatefulWidget {
  @override
  _MyHeader createState() => _MyHeader();
}

class _MyHeader extends State<MyHeader> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  scale: 0.3,
                  image: AssetImage('assets/images/icons/AcaGYMIcon.jpeg'),
                ),
              )),
          Text("ACA GYM",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          Text((_auth.currentUser != null) ? _auth.currentUser!.email! : '',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
