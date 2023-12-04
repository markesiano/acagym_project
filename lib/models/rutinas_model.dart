import 'package:acagym_project/models/ejercicios_model.dart';
import 'package:hive/hive.dart';
part 'rutinas_model.g.dart';

@HiveType(typeId: 0)
class RutinasModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  List<EjerciciosModel> ejercicios;

  RutinasModel({
    required this.id,
    required this.name,
    required this.ejercicios,
  });

  static RutinasModel fromJson(Map<String, dynamic> json) => RutinasModel(
        id: json['id'],
        name: json['name'],
        ejercicios: List<EjerciciosModel>.from(
            json['ejercicios'].map((x) => EjerciciosModel.fromJson(x))),
      );

  //Método para obtener los ejercicios del modelo ejercios mediante el id de ejercicios

  // static List<RutinasModel> getRutinas() {
  //   List<RutinasModel> rutinas = [];

  //   rutinas.add(RutinasModel(
  //     id: '1',
  //     name: 'Rutina de pierna',
  //     ejercicios: ['ejercicio1', 'ejercicio2'],
  //   ));

  //   rutinas.add(RutinasModel(
  //     id: '2',
  //     name: 'Rutina de pecho',
  //     ejercicios: ['ejercicio3', 'ejercicio4'],
  //   ));

  //   rutinas.add(RutinasModel(
  //     id: '3',
  //     name: 'Rutina de espalda',
  //     ejercicios: ['ejercicio3', 'ejercicio1'],
  //   ));

  //   return rutinas;
  // }
}
