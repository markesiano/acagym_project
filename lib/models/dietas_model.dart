import 'package:flutter/material.dart';

class DietasModel {
  String name;
  String iconPath;
  String level;
  String duration;
  String calorie;
  String protein;
  Color boxColor;
  bool viewIsSelected;

  DietasModel(
      {required this.name,
      required this.iconPath,
      required this.level,
      required this.duration,
      required this.calorie,
      required this.protein,
      required this.boxColor,
      required this.viewIsSelected});

  static List<DietasModel> getCategories() {
    List<DietasModel> rutinas = [];

    rutinas.add(DietasModel(
      name: 'Hotcakes de avena',
      iconPath: 'assets/icons/hotcakes.svg',
      level: 'Fácil',
      duration: '30 min',
      calorie: '100 kcal',
      protein: '10 g',
      boxColor: const Color(0xffFFD9D9),
      viewIsSelected: true,
    ));

    rutinas.add(DietasModel(
      name: 'Pierna de pollo',
      iconPath: 'assets/icons/chickenleg.svg',
      level: 'Medio',
      duration: '45 min',
      calorie: '200 kcal',
      protein: '25 g',
      boxColor: const Color(0xffD9EFFF),
      viewIsSelected: false,
    ));

    rutinas.add(DietasModel(
      name: 'Ensalada de atún',
      iconPath: 'assets/icons/atun.svg',
      level: 'Fácil',
      duration: '15 min',
      calorie: '90 kcal',
      protein: '30 g',
      boxColor: const Color.fromARGB(255, 217, 255, 249),
      viewIsSelected: false,
    ));

    return rutinas;
  }
}
