import 'package:acagym_project/data/rutina_data.dart';
import 'package:acagym_project/models/rutinas_model.dart';
import 'package:acagym_project/models/maquinas_model.dart';
import 'package:acagym_project/models/ejercicios_model.dart';

import 'package:flutter/material.dart';
import 'package:acagym_project/pages/login/home.dart';
import 'package:acagym_project/pages/login/login.dart';
import 'package:acagym_project/pages/login/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:acagym_project/firebase_options.dart';
import 'package:acagym_project/pages/home/home.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:acagym_project/pages/rutinas/rutina.dart';

Future<void> main() async {
  //Se inicia la instancia de hive
  await Hive.initFlutter();
  Hive.registerAdapter(RutinasModelAdapter());
  Hive.registerAdapter(EjerciciosModelAdapter());
  Hive.registerAdapter(MaquinasModelAdapter());
  //Se abre "hive box"
  //Se sepera que inicialicen los widgets
  WidgetsFlutterBinding.ensureInitialized();
  //Se inicia la instancia de firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RutinaData(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontFamily: 'Roboto',
            ),
          )),
          initialRoute: HomeScreen.id,
          routes: {
            HomeScreen.id: (context) => HomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            SignUpScreen.id: (context) => SignUpScreen(),
            RutinaPage.id: (context) => RutinaPage(nombre: '', idRutina: ''),
            HomePage.id: (context) => HomePage(),
          },
        ));
  }
}





// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(fontFamily: 'roboto'),
//         home: HomePage());
//   }
// }
