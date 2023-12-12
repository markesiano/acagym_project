import 'package:acagym_project/models/ejercicios_model.dart';
import 'package:acagym_project/models/maquinas_model.dart';
import 'package:acagym_project/models/rutinas_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RutinaData extends ChangeNotifier {
  late Stream<List<RutinasModel>> _rutinasStream;

  List<RutinasModel> rutinasList = [];

  RutinaData() {
    _initialize();
  }

  void _initialize() {
    _rutinasStream = FirebaseFirestore.instance
        .collection('rutinas')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RutinasModel.fromJson(doc.data()))
            .toList());

    _rutinasStream.listen((rutinas) {
      rutinasList = rutinas;
      notifyListeners(); // Notifica a los widgets que los datos han cambiado
    });
  }

  List<RutinasModel> get rutinas => rutinasList;

  // Buscar en la base de datos la máquina a partir del qr, obteniendo el objeto de la máquina

  MaquinasModel getMaquina(String qr) {
    late MaquinasModel maquina;
    for (int i = 0; i < rutinasList.length; i++) {
      for (int j = 0; j < rutinasList[i].ejercicios.length; j++) {
        if (rutinasList[i].ejercicios[j].maquina!.qr == qr) {
          maquina = rutinasList[i].ejercicios[j].maquina!;
        }
      }
    }
    return maquina;
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
