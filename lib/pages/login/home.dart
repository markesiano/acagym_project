import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:acagym_project/components/components.dart';
import 'package:acagym_project/pages/login/login.dart';
import 'package:acagym_project/pages/login/signup.dart';
import 'package:acagym_project/pages/home/home.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return _welcome(context);
            }
          }),
    );
  }

  SafeArea _welcome(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TopScreenImage(screenImageName: 'home.jpg'),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(right: 15.0, left: 15, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const ScreenTitle(title: '¡Bienvenido!'),
                    const Text(
                      'Inicia sesión o registrate para ver el contenido de ACA GYM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Hero(
                      tag: 'login_btn',
                      child: CustomButton(
                        buttonText: 'Iniciar Sesión',
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.id);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Hero(
                      tag: 'signup_btn',
                      child: CustomButton(
                        buttonText: 'Registrarse',
                        isOutlined: true,
                        onPressed: () {
                          Navigator.pushNamed(context, SignUpScreen.id);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
