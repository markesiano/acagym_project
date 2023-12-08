import 'package:acagym_project/data/hive_database.dart';
import 'package:acagym_project/data/rutina_data.dart';
import 'package:acagym_project/models/qr_modeL.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:acagym_project/firebase_options.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'package:acagym_project/models/models.dart';
import 'package:acagym_project/pages/pages.dart';

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

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => QrModel(),
      ),
      ChangeNotifierProvider(create: (context) => RutinaData()),
      ChangeNotifierProvider(create: (context) => HiveDatabase()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final _routes = <String, WidgetBuilder>{
    '/': (context) => const HomePage(),
    '/signin': (context) => LoginPage(),
    '/rutina': (context) => const RutinaPage(nombre: '', idRutina: ''),
    '/listaRutinas': (context) => const ListaRutinas(),
    '/rutinasQr': (context) => const RutinasQr(code: ''),
  };

  MyApp({super.key});

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
          initialRoute: '/signin',
          routes: _routes,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
                builder: (context) => const NotFoundPage());
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
