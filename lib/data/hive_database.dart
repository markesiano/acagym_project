import 'package:acagym_project/models/rutinas_model.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  const HiveDatabase();

  //Función para guardar una rutina de la base de datos de Firebase a Hive
  Future<int> saveRutina(RutinasModel rutina) async {
    final Box<RutinasModel> box = await Hive.openBox<RutinasModel>('rutinas');
    return box.add(rutina);
  }

  //Función para enlistar las rutinas guardadas en Hive
  Future<List<RutinasModel>> get rutinas async {
    final Box<RutinasModel> box = await Hive.openBox<RutinasModel>('rutinas');
    return box.values.toList();
  }

  Future<void> deleteRutina(int index) async {
    final Box<RutinasModel> box = await Hive.openBox<RutinasModel>('rutinas');
    await box.deleteAt(index);
  }

  // // Referencia de "hive box"
  // final _myBox = Hive.box('basedatos_rutinas');
  // // Revisar si los datos ya estan creados, si no, empieza a crearlos
  // bool previousDataExists() {
  //   if (_myBox.isEmpty) {
  //     _myBox.put("START_DATE", getToday());
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  // void saveToDatabase(List<RutinasModel> rutinas) {

  // }

  // Leemos los datos y retornamos la lista de rutinas

  // List<RutinasModel> readFromDatabase() {
  //   List<RutinasModel> misRutinas = [];

  //   List<String> rutinasList = _myBox.get("RUTINAS");
  //   final detallesEjercicios = _myBox.get("EJERCICIOS");

  //   for (int i = 0; i < rutinasList.length; i++) {
  //     List<EjerciciosModel> ejercicios = [];
  //     for (int j = 0; j < detallesEjercicios[i].length; j++) {
  //       String textoEjercicoio = detallesEjercicios[i][j][5];
  //       textoEjercicoio = textoEjercicoio.replaceAll(RegExp(r'[\[\]\s]'), '');
  //       List<String> listaMusculos = textoEjercicoio.split(',');

  //       EjerciciosModel ejercicio = EjerciciosModel(
  //         id: detallesEjercicios[i][j][0],
  //         name: detallesEjercicios[i][j][1],
  //         repeticiones: int.parse(detallesEjercicios[i][j][2]),
  //         series: int.parse(detallesEjercicios[i][j][3]),
  //         peso: int.parse(detallesEjercicios[i][j][4]),
  //         musculos: listaMusculos,
  //         maquina:
  //             (detallesEjercicios[i][j][6].equalsIgnoreCase("null") == false)
  //                 ? MaquinasModel(
  //                     id: detallesEjercicios[i][j][6],
  //                     name: detallesEjercicios[i][j][7],
  //                     image: detallesEjercicios[i][j][8],
  //                     qr: detallesEjercicios[i][j][9],
  //                   )
  //                 : null,
  //       );
  //       ejercicios.add(ejercicio);
  //     }
  //     RutinasModel rutina = RutinasModel(
  //       id: rutinasList[i][0],
  //       name: rutinasList[i][1],
  //       ejercicios: ejercicios,
  //     );
  //     misRutinas.add(rutina);
  //   }
  //   return misRutinas;
  // }
}


















// // Conversiones de objetos "rutina" a lista
// List<String> rutinasToStringList(List<RutinasModel> rutinas) {
//   List<String> rutinasList = [];
//   for (RutinasModel rutina in rutinas) {
//     rutinasList.add(rutina.name);
//   }
//   return rutinasList;
// }

// // Conversiones de "ejercicios" a objetos de "rutina" y a lista de Strings

// List<List<List<List<String>>>> ejerciciosToStringList(
//     List<RutinasModel> rutinas) {
//   List<List<List<List<String>>>> ejerciciosList = [];

//   for (RutinasModel rutina in rutinas) {
//     List<List<List<String>>> ejercicios = [];
//     for (EjerciciosModel ejercicio in rutina.ejercicios) {
//       List<List<String>> ejercicioList = [];
//       List<String> ejercicioList2 = [];
//       ejercicioList2.add(ejercicio.id);
//       ejercicioList2.add(ejercicio.name);
//       ejercicioList2.add(ejercicio.repeticiones.toString());
//       ejercicioList2.add(ejercicio.series.toString());
//       ejercicioList2.add(ejercicio.peso.toString());
//       ejercicioList2.add(ejercicio.musculos.toString());
//       if (ejercicio.maquina == null) {
//         ejercicioList2.add("null");
//         ejercicioList2.add("null");
//         ejercicioList2.add("null");
//         ejercicioList2.add("null");
//       } else {
//         ejercicioList2.add(ejercicio.maquina!.id);
//         ejercicioList2.add(ejercicio.maquina!.name);
//         ejercicioList2.add(ejercicio.maquina!.image);
//         ejercicioList2.add(ejercicio.maquina!.qr);
//       }

//       ejercicioList.add(ejercicioList2);
//     }
//     ejerciciosList.add(ejercicios);
//   }

//   // for (RutinasModel rutina in rutinas) {
//   //   List<List<String>> ejercicios = [];
//   //   for (EjerciciosModel ejercicio in rutina.ejercicios) {
//   //     List<String> ejercicioList = [];
//   //     ejercicioList.add(ejercicio.id);
//   //     ejercicioList.add(ejercicio.name);
//   //     ejercicioList.add(ejercicio.repeticiones.toString());
//   //     ejercicioList.add(ejercicio.series.toString());
//   //     ejercicioList.add(ejercicio.peso.toString());
//   //     ejercicioList.add(ejercicio.musculos.toString());
//   //     ejercicioList.add(ejercicio.maquina.toString());
//   //     ejercicios.add(ejercicioList);
//   //   }
//   //   ejerciciosList.add(ejercicios);
//   // }
//   return ejerciciosList;
// }

  // Conversiones de objetos "rutina" a lista de Strings
