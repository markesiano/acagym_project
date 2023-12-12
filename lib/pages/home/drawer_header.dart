import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:acagym_project/constants.dart';

class MyHeader extends StatefulWidget {
  @override
  _MyHeader createState() => _MyHeader();
}

class _MyHeader extends State<MyHeader> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kGreenLight2,
      ),
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/icons/logo.png'),
                ),
              )),
          Text((_auth.currentUser != null) ? _auth.currentUser!.email! : '',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
