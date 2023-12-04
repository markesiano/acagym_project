import 'package:flutter/material.dart';
import 'package:acagym_project/components/components.dart';
import 'package:acagym_project/constants.dart';
import 'package:acagym_project/pages/home/home.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:acagym_project/pages/login/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomePage();
              } else {
                return _login(context);
              }
            }),
      ),
    );
  }

  LoadingOverlay _login(BuildContext context) {
    return LoadingOverlay(
      isLoading: _saving,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const TopScreenImage(screenImageName: 'welcome.png'),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ScreenTitle(title: 'Inicio de sesión'),
                    CustomTextField(
                      textField: TextField(
                          onChanged: (value) {
                            _email = value;
                          },
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          decoration: kTextInputDecoration.copyWith(
                              hintText: 'Correo')),
                    ),
                    CustomTextField(
                      textField: TextField(
                        obscureText: true,
                        onChanged: (value) {
                          _password = value;
                        },
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                        decoration: kTextInputDecoration.copyWith(
                            hintText: 'Contraseña'),
                      ),
                    ),
                    Hero(
                      tag: 'login_btn',
                      child: CustomButton(
                        buttonText: 'Iniciar Sesión',
                        onPressed: () async {
                          setState(() {
                            _saving = true;
                          });
                          try {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: _email, password: _password);
                            if (user != null) {
                              Navigator.pushNamed(context, HomePage.id);
                            }
                            setState(() {
                              _saving = false;
                            });
                          } catch (e) {
                            print(e);
                            setState(() {
                              _saving = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
