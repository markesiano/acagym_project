import 'package:flutter/material.dart';

class RutinasModel {
  String name;
  String iconPath;
  Color boxColor;

  RutinasModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<RutinasModel> getCategories() {
    List<RutinasModel> rutinas = [];

    rutinas.add(RutinasModel(
      name: 'Pierna',
      iconPath: 'assets/icons/leg.svg',
      boxColor: const Color(0xffFFD9D9),
    ));

    rutinas.add(RutinasModel(
      name: 'Brazo',
      iconPath: 'assets/icons/arm.svg',
      boxColor: const Color(0xffD9EFFF),
    ));

    rutinas.add(RutinasModel(
      name: 'Espalda',
      iconPath: 'assets/icons/back.svg',
      boxColor: const Color(0xffD9FFD9),
    ));

    rutinas.add(RutinasModel(
      name: 'Abdomen',
      iconPath: 'assets/icons/abs.svg',
      boxColor: const Color.fromARGB(255, 255, 246, 217),
    ));

    rutinas.add(RutinasModel(
      name: 'Pecho',
      iconPath: 'assets/icons/chest.svg',
      boxColor: const Color.fromARGB(255, 255, 232, 217),
    ));

    rutinas.add(RutinasModel(
      name: 'Cintura',
      iconPath: 'assets/icons/waist.svg',
      boxColor: const Color.fromARGB(255, 244, 217, 255),
    ));

    return rutinas;
  }
}
