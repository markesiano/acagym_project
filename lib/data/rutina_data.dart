import 'package:acagym_project/models/ejercicios_model.dart';
import 'package:acagym_project/models/rutinas_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RutinaData extends ChangeNotifier {
  Stream<List<RutinasModel>> readRutinas() => FirebaseFirestore.instance
      .collection('rutinas')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => RutinasModel.fromJson(doc.data()))
          .toList());

  List<RutinasModel> rutinasList = [];

  //Inicializar base de datos desde firestore
  RutinaData() {
    readRutinas().listen((rutinas) {
      rutinasList = rutinas;
      notifyListeners();
    });
  }

  // Buscar en la base de datos todos los registros que coincidan con el qr de la maquina

  List<RutinasModel> getMaquinaFromQR(String qr) {
    List<RutinasModel> rutinas = [];
    for (int i = 0; i < rutinasList.length; i++) {
      for (int j = 0; j < rutinasList[i].ejercicios.length; j++) {
        if (rutinasList[i].ejercicios[j].maquina!.qr == qr) {
          rutinas.add(rutinasList[i]);
        }
      }
    }
    return rutinas;
  }

  // Obtener la ruta de la imágen de la máquina buscando con el qr

  String getMaquinaImage(String qr) {
    String image = '';
    for (int i = 0; i < rutinasList.length; i++) {
      for (int j = 0; j < rutinasList[i].ejercicios.length; j++) {
        if (rutinasList[i].ejercicios[j].maquina!.qr == qr) {
          image = rutinasList[i].ejercicios[j].maquina!.image;
        }
      }
    }
    return image;
  }

  //   RutinasModel(
  //     id: '1',
  //     name: 'Rutina de pierna',
  //     ejercicios: [
  //       EjerciciosModel(
  //           id: 'ejercicio1',
  //           name: 'Sentadillas',
  //           repeticiones: 10,
  //           series: 3,
  //           peso: 50,
  //           musculos: ['Pierna', 'Gluteo'],
  //           maquina: MaquinasModel(
  //             id: 'maquina1',
  //             name: 'Maquina de sentadillas',
  //             image: 'assets/images/maquina_sentadillas.png',
  //             qr: 'maquinasentadillas1',
  //           )),
  //       EjerciciosModel(
  //         id: 'ejercicio2',
  //         name: 'Peso muerto',
  //         repeticiones: 10,
  //         series: 3,
  //         peso: 50,
  //         musculos: ['Pierna', 'Gluteo'],
  //       )
  //     ],
  //   ),
  //   RutinasModel(
  //     id: '2',
  //     name: 'Rutina de pecho',
  //     ejercicios: [
  //       EjerciciosModel(
  //           id: 'ejercicio3',
  //           name: 'Press de banca',
  //           repeticiones: 10,
  //           series: 3,
  //           peso: 50,
  //           musculos: ['Pecho', 'Triceps'],
  //           maquina: MaquinasModel(
  //             id: 'maquina2',
  //             name: 'Maquina de press de banca',
  //             image: 'assets/images/maquina_press_banca.png',
  //             qr: 'maquinapressbanca1',
  //           )),
  //       EjerciciosModel(
  //         id: 'ejercicio4',
  //         name: 'Press de banca inclinado',
  //         repeticiones: 10,
  //         series: 3,
  //         peso: 50,
  //         musculos: ['Pecho', 'Triceps'],
  //       )
  //     ],
  //   ),
  //   RutinasModel(
  //     id: '3',
  //     name: 'Rutina de hombro',
  //     ejercicios: [
  //       EjerciciosModel(
  //           id: 'ejercicio5',
  //           name: 'Press de hombro',
  //           repeticiones: 10,
  //           series: 3,
  //           peso: 50,
  //           musculos: ['Hombro', 'Triceps'],
  //           maquina: MaquinasModel(
  //             id: 'maquina3',
  //             name: 'Maquina de press de hombro',
  //             image: 'assets/images/maquina_press_hombro.png',
  //             qr: 'maquinapresshombro1',
  //           )),
  //       EjerciciosModel(
  //         id: 'ejercicio6',
  //         name: 'Press de hombro con mancuernas',
  //         repeticiones: 10,
  //         series: 3,
  //         peso: 50,
  //         musculos: ['Hombro', 'Triceps'],
  //       )
  //     ],
  //   ),
  //   RutinasModel(
  //     id: '3',
  //     name: 'Rutina de hombro',
  //     ejercicios: [
  //       EjerciciosModel(
  //           id: 'ejercicio5',
  //           name: 'Press de hombro',
  //           repeticiones: 10,
  //           series: 3,
  //           peso: 50,
  //           musculos: ['Hombro', 'Triceps'],
  //           maquina: MaquinasModel(
  //             id: 'maquina3',
  //             name: 'Maquina de press de hombro',
  //             image: 'assets/images/maquina_press_hombro.jpg',
  //             qr: 'maquinapresshombro1',
  //           )),
  //       EjerciciosModel(
  //         id: 'ejercicio6',
  //         name: 'Press de hombro con mancuernas',
  //         repeticiones: 10,
  //         series: 3,
  //         peso: 50,
  //         musculos: ['Hombro', 'Triceps'],
  //       )
  //     ],
  //   ),
  // ];

  //Se inicializan los datos de las rutinas, si no hay datos existentes, se crean unos por defecto

  List<RutinasModel> getRutinas() {
    return rutinasList;
  }

  int getEjerciciosCount(String rutinaId) {
    RutinasModel rutina = getRutinaById(rutinaId);
    return rutina.ejercicios.length;
  }

  void addRutina(RutinasModel rutina) {
    rutinasList.add(rutina);
  }

  void addEjercicio(String rutinaId, EjerciciosModel ejercicio) {
    RutinasModel rutina = getRutinaById(rutinaId);

    rutina.ejercicios.add(ejercicio);
  }

  RutinasModel getRutinaById(String rutinaId) {
    RutinasModel relevantRutina =
        rutinasList.firstWhere((rutina) => rutina.id == rutinaId);
    return relevantRutina;
  }

  EjerciciosModel getEjercicioById(String rutinaId, String ejercicioId) {
    RutinasModel relevantRutina = getRutinaById(rutinaId);

    EjerciciosModel relevantEjercicio = relevantRutina.ejercicios
        .firstWhere((ejercicio) => ejercicio.id == ejercicioId);

    return relevantEjercicio;
  }
}
