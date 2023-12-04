import 'package:acagym_project/models/maquinas_model.dart';
import 'package:hive/hive.dart';
part 'ejercicios_model.g.dart';

@HiveType(typeId: 1)
class EjerciciosModel extends HiveObject {
  //Definición de variables
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int repeticiones;
  @HiveField(3)
  int series;
  @HiveField(4)
  int? peso;
  @HiveField(5)
  List<String> musculos;
  @HiveField(6)
  MaquinasModel? maquina; //Puede ser nulo

  //Contructor de variables
  EjerciciosModel({
    required this.id,
    required this.name,
    required this.repeticiones,
    required this.series,
    this.peso,
    required this.musculos,
    //Máquina id puede ser nulo, ya que no todos los ejercicios llevan máquina
    this.maquina,
  });

  static EjerciciosModel fromJson(Map<String, dynamic> json) {
    json['musculos'] = json['musculos']
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',');

    if (json['maquina'] != null) {
      json['maquina'] = MaquinasModel.fromJson(json['maquina']);
    } else {
      json['maquina'] = null;
    }
    if (json['peso'] == null) {
      json['peso'] = 0;
    }

    return EjerciciosModel(
        id: json['id'],
        name: json['name'],
        repeticiones: int.parse(json['repeticiones'].toString()),
        series: int.parse(json['series'].toString()),
        peso: int.parse(json['peso'].toString()),
        musculos: json['musculos'],
        maquina: json['maquina']);
  }

  // //Método para obtener los ejercicios de una máquina
  // static List<EjerciciosModel> getEjerciciosByMaquinaId(String maquinaId) {
  //   List<EjerciciosModel> ejercicios = getEjercicios();

  //   List<EjerciciosModel> ejerciciosByMaquinaId = [];

  //   ejercicios.forEach((ejercicio) {
  //     if (ejercicio.maquinaId == maquinaId) {
  //       ejerciciosByMaquinaId.add(ejercicio);
  //     }
  //   });

  //   return ejerciciosByMaquinaId;
  // }

  // //Metodo para obtener una máquina mediante un id de máquina
  // static MaquinasModel getMaquinaById(String maquinaId) {
  //   List<MaquinasModel> maquinas = MaquinasModel.getMaquinas();

  //   MaquinasModel maquina = maquinas.firstWhere((maquina) {
  //     return maquina.id == maquinaId;
  //   });

  //   return maquina;
  // }

  // //Método para obtener los ejercicios
  // static List<EjerciciosModel> getEjercicios() {
  //   List<EjerciciosModel> ejercicios = [];

  //   ejercicios.add(
  //     EjerciciosModel(
  //         id: 'ejercicio1',
  //         name: 'Sentadillas',
  //         repeticiones: 10,
  //         series: 3,
  //         peso: 50,
  //         musculos: ['Pierna', 'Gluteo'],
  //         maquinaId: getMaquinaById('maquina1')),
  //   );

  //   ejercicios.add(EjerciciosModel(
  //     id: 'ejercicio2',
  //     name: 'Peso muerto',
  //     repeticiones: 10,
  //     series: 3,
  //     peso: 50,
  //     musculos: ['Pierna', 'Gluteo'],
  //   ));

  //   ejercicios.add(EjerciciosModel(
  //     id: 'ejercicio3',
  //     name: 'Press de hombro',
  //     repeticiones: 10,
  //     series: 3,
  //     peso: 50,
  //     musculos: ['Hombro', 'Triceps'],
  //     maquinaId: getMaquinaById('maquina2'),
  //   ));

  //   ejercicios.add(EjerciciosModel(
  //     id: 'ejercicio4',
  //     name: 'Press de banca',
  //     repeticiones: 10,
  //     series: 3,
  //     peso: 50,
  //     musculos: ['Pecho', 'Triceps'],
  //     maquinaId: getMaquinaById('maquina3'),
  //   ));

  //   return ejercicios;
  // }
}
