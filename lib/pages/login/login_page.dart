import 'package:acagym_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:acagym_project/components/my_buttom.dart';
import 'package:acagym_project/components/square_tile.dart';
import 'package:acagym_project/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _email;
  late String _password;

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      //pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle
      Navigator.pop(context);

      genericErrorMessage(e.code);
    }
  }

  void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreenLight1,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Image(
                    height: 250,
                    width: 250,
                    image: AssetImage('assets/images/icons/logo.png')),
                //welcome back you been missed

                Text(
                  'Bienvenido de nuevo',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 25),

                //username

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Correo electrónico',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.grey[400],
                      ),
                    ),
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                ),

                const SizedBox(height: 15),
                //password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey[400],
                      ),
                    ),
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                ),

                const SizedBox(height: 15),

                //sign in button
                MyButton(
                  onTap: signUserIn,
                  text: 'Iniciar Sesión',
                ),
                const SizedBox(height: 20),

                //forgot passowrd

                // Padding(
                //   padding: const EdgeInsets.all(5.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         '¿Olvidaste tus datos? ',
                //         style: TextStyle(
                //             color: Colors.grey.shade600, fontSize: 12),
                //       ),
                //       Text(
                //         'Da click aquí para recuperarlos',
                //         style: TextStyle(
                //           color: Colors.blue.shade900,
                //           fontSize: 15,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       )
                //     ],
                //   ),
                // ),

                const SizedBox(
                  height: 10,
                ),

                // continue with
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey.shade400,
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(left: 8, right: 8),
                //         child: Text(
                //           'O inicia sesión con',
                //           style: TextStyle(color: Colors.grey.shade600),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey.shade400,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),

                //google + apple button

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     //google buttom
                //     SquareTile(
                //       onTap: () => AuthService().signInWithGoogle(),
                //       imagePath: 'assets/images/icons/google.svg',
                //       height: 70,
                //     ),
                //   ],
                // ),
                const SizedBox(
                  height: 25,
                ),

                // not a memeber ? register now

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Aún no estas registrado? ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Registrarse ahora',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
