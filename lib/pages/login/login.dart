import 'package:acagym_project/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:acagym_project/components/button_login.dart';
import 'package:acagym_project/components/square_tile_login.dart';
import 'package:acagym_project/components/text_field_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();

  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  bool _saving = false;

  //Método de logeo dónde recibe el contexto para validar y posteriormente navegar a la pantalla home
  Future<void> login() async {
    //Validar que los campos no estén vacíos
    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      //Verificar que el correo tenga el formato correcto con regex
      RegExp regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!regExp.hasMatch(userNameController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Ingresa un correo válido'),
          ),
        );
      } else {
        try {
          showDialog(
              context: context,
              builder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
          //Se hace el logeo con firebase
          final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: userNameController.text,
              password: passwordController.text);
          if (user != null) {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
          }
        } on FirebaseAuthException catch (e) {
          print(e);
        } catch (e) {
          print(e);
        }
      }

      //Navegar a la pantalla home
    } else if (userNameController.text.isEmpty) {
      //Mostrar un que el campo de usuario está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('El campo de usuario no puede estar vacío'),
        ),
      );
    } else if (passwordController.text.isEmpty) {
      //Mostrar un que el campo de contraseña está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('Debes ingresar tu contraseña'),
        ),
      );
    }
  }

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Correo incorrecto'),
            content: Text('El correo ingresado no es correcto'),
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text('Contraseña incorrecta'),
            content: Text('La contraseña ingresada no es correcta'),
          );
        });
  }

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
              return _loginBody(context);
            }
          },
        ));
  }

  LoadingOverlay _loginBody(BuildContext context) {
    return LoadingOverlay(
      isLoading: _saving,
      child: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                width: 200,
                height: 200,
                image: AssetImage('assets/images/icons/logo.png'),
              ),
              Text(
                '¡Bienvenido!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldLogin(
                  controller: userNameController,
                  hintText: 'Usuario',
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),
              TextFieldLogin(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              ButtonLogin(
                  // Se llama al método de logeo
                  onTap: () async {
                setState(() {
                  _saving = true;
                });
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: userNameController.text,
                      password: passwordController.text);
                  if (user != null) {
                    Navigator.pushNamed(context, '/');
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
              }),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'O inicia sesión con',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const SquareTile(imagePath: 'assets/images/icons/google.png'),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿No estas registrado?',
                      style: TextStyle(
                        color: Colors.grey[700],
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text('Registrarse',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ))
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
