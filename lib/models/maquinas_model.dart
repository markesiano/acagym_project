import 'package:hive/hive.dart';
part 'maquinas_model.g.dart';

@HiveType(typeId: 2)
class MaquinasModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String image;
  @HiveField(3)
  String qr;

  MaquinasModel({
    required this.id,
    required this.name,
    required this.image,
    required this.qr,
  });

  static MaquinasModel fromJson(Map<String, dynamic> json) => MaquinasModel(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        qr: json['qr'],
      );

  // static List<MaquinasModel> getMaquinas() {
  //   List<MaquinasModel> maquinas = [];

  //   maquinas.add(MaquinasModel(
  //     id: 'maquina1',
  //     name: 'Maquina de sentadillas',
  //     image: 'assets/images/maquina_sentadillas.png',
  //     qr: 'maquinasentadillas1',
  //   ));

  //   maquinas.add(MaquinasModel(
  //     id: 'maquina2',
  //     name: 'Maquina de press de banca',
  //     image: 'assets/images/maquina_press_banca.png',
  //     qr: 'maquinapressbanca1',
  //   ));

  //   maquinas.add(MaquinasModel(
  //     id: 'maquina3',
  //     name: 'Maquina de press de hombro',
  //     image: 'assets/images/maquina_press_hombro.jpg',
  //     qr: 'maquinapresshombro1',
  //   ));

  //   return maquinas;
  // }
}
