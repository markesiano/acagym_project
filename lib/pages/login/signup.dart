import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:acagym_project/components/components.dart';
import 'package:acagym_project/pages/login/home.dart';
import 'package:acagym_project/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:acagym_project/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  late String _confirmPass;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TopScreenImage(screenImageName: 'signup.png'),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ScreenTitle(title: 'Registrarse'),
                          CustomTextField(
                            textField: TextField(
                              onChanged: (value) {
                                _email = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Correo',
                              ),
                            ),
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
                                hintText: 'Contraseña',
                              ),
                            ),
                          ),
                          CustomTextField(
                            textField: TextField(
                              obscureText: true,
                              onChanged: (value) {
                                _confirmPass = value;
                              },
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              decoration: kTextInputDecoration.copyWith(
                                hintText: 'Confirmar contraseña',
                              ),
                            ),
                          ),
                          CustomBottomScreen(
                            textButton: 'Registrarse',
                            heroTag: 'signup_btn',
                            question: '¿Ya tienes una cuenta?',
                            buttonPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                _saving = true;
                              });
                              if (_confirmPass == _password) {
                                try {
                                  await _auth.createUserWithEmailAndPassword(
                                      email: _email, password: _password);

                                  if (context.mounted) {
                                    signUpAlert(
                                      context: context,
                                      title: '¡Registro exitoso!',
                                      desc: 'Ve a iniciar sesión',
                                      btnText: 'Iniciar Sesión',
                                      onPressed: () {
                                        setState(() {
                                          _saving = false;
                                          Navigator.popAndPushNamed(
                                              context, SignUpScreen.id);
                                        });
                                        Navigator.pushNamed(
                                            context, LoginScreen.id);
                                      },
                                    ).show();
                                  }
                                } catch (e) {
                                  signUpAlert(
                                      context: context,
                                      onPressed: () {
                                        SystemNavigator.pop();
                                      },
                                      title: '¡Algo salió mal!',
                                      desc: 'Reinicia la aplicación',
                                      btnText: 'Cerrar');
                                }
                              } else {
                                showAlert(
                                    context: context,
                                    title: 'Contraseña mal escrita',
                                    desc:
                                        'Asegurate que ambas contraseñas sean iguales',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }).show();
                              }
                            },
                            questionPressed: () async {
                              Navigator.pushNamed(context, LoginScreen.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
