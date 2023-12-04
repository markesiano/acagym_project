import 'package:flutter/material.dart';

import 'package:acagym_project/models/ejercicios_model.dart';
import 'package:acagym_project/models/rutinas_model.dart';

class MisRutinaData extends ChangeNotifier {
  List<RutinasModel> rutinasList = [];

  List<RutinasModel> getMisRutinas() {
    return rutinasList;
  }

  int getMisEjerciciosCount(String rutinaId) {
    RutinasModel rutina = getMisRutinaById(rutinaId);
    return rutina.ejercicios.length;
  }

  void addMisRutina(RutinasModel rutina) {
    rutinasList.add(rutina);
  }

  void addMisEjercicio(String rutinaId, EjerciciosModel ejercicio) {
    RutinasModel rutina = getMisRutinaById(rutinaId);

    rutina.ejercicios.add(ejercicio);
  }

  RutinasModel getMisRutinaById(String rutinaId) {
    RutinasModel relevantRutina =
        rutinasList.firstWhere((rutina) => rutina.id == rutinaId);
    return relevantRutina;
  }

  EjerciciosModel getMisEjercicioById(String rutinaId, String ejercicioId) {
    RutinasModel relevantRutina = getMisRutinaById(rutinaId);

    EjerciciosModel relevantEjercicio = relevantRutina.ejercicios
        .firstWhere((ejercicio) => ejercicio.id == ejercicioId);

    return relevantEjercicio;
  }
}
