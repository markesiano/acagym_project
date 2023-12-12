import 'package:flutter/material.dart';

import 'package:acagym_project/models/models.dart';
import 'package:acagym_project/data/hive_database.dart';
import 'package:acagym_project/data/rutina_data.dart';
import 'package:acagym_project/models/qr_modeL.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:acagym_project/firebase_options.dart';
import 'package:get_storage/get_storage.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'package:acagym_project/pages/pages.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  //Se sepera que inicialicen los widgets
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  //Se inicia la instancia de hive
  await Hive.initFlutter();

  // Se inicializan los adaptadores de Hive
  Hive.registerAdapter(RutinasModelAdapter());
  Hive.registerAdapter(EjerciciosModelAdapter());
  Hive.registerAdapter(MaquinasModelAdapter());

  //Se abre "hive box"
  await Hive.openBox<RutinasModel>('rutinas');

  // Se inicializa el storage
  await GetStorage.init();

  // Se inicializa el splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  //Se inicia la instancia de firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => FlutterNativeSplash.remove());
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
    '/auth': (context) => const AuthPage(),
    '/rutina': (context) => const RutinaPage(nombre: '', idRutina: ''),
    '/listaRutinas': (context) => const ListaRutinas(),
    '/rutinasQr': (context) => const RutinasQr(code: ''),
    '/register': (context) => RegisterPage(),
  };

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => RutinaData(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              useMaterial3: true,
              textTheme: const TextTheme(
                bodyMedium: TextStyle(
                  fontFamily: 'Roboto',
                ),
              )),
          initialRoute: '/auth',
          routes: _routes,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
                builder: (context) => const NotFoundPage());
          },
        ));
  }
}
