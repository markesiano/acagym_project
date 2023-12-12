import 'package:acagym_project/data/hive_database.dart';
import 'package:acagym_project/data/rutina_data.dart';
import 'package:acagym_project/models/rutinas_model.dart';
import 'package:flutter/material.dart';
import 'package:acagym_project/pages/rutinas/rutina.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:acagym_project/constants.dart';

class ListaRutinas extends StatefulWidget {
  const ListaRutinas({Key? key}) : super(key: key);

  @override
  _ListaRutinasState createState() => _ListaRutinasState();
}

class _ListaRutinasState extends State<ListaRutinas> {
  List<RutinasModel>? rutinasListHive = [];
  List<RutinasModel> rutinasFirebase = [];

  _getRutinasMostar(
      List<RutinasModel> rutinasListHive, List<RutinasModel> rutinasFirebase) {
    List<RutinasModel> rutinasMostrar = [];
    for (int i = 0; i < rutinasFirebase.length; i++) {
      bool flag = true;
      for (int j = 0; j < rutinasListHive.length; j++) {
        if (rutinasFirebase[i].id == rutinasListHive[j].id) {
          flag = false;
        }
      }
      if (flag) {
        rutinasMostrar.add(rutinasFirebase[i]);
      }
    }
    return rutinasMostrar;
  }

  @override
  Widget build(BuildContext context) {
    rutinasFirebase = context.watch<RutinaData>().rutinasList;
    rutinasListHive = context.watch<HiveDatabase>().rutinas;
    return Scaffold(
      backgroundColor: kGreenLight1,
      appBar: AppBar(
        backgroundColor: kGreenLight2,
        title: const Text('Rutinas'),
      ),
      body: ValueListenableBuilder(
          valueListenable: Hive.box<RutinasModel>('rutinas').listenable(),
          builder: (context, Box<RutinasModel> box, _) {
            List<RutinasModel> rutinas = box.values.toList();
            List<RutinasModel> rutinasMostrar =
                _getRutinasMostar(rutinas, rutinasFirebase);

            if (rutinasMostrar.isEmpty) {
              return const Center(
                child: Text(
                  'No hay rutinas disponibles',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              );
            } else {
              return _ListViewRutinas(rutinasMostrar);
            }
          }),
    );
  }

  ListView _ListViewRutinas(List<RutinasModel> rutinasMostrar) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RutinaPage(
                    nombre: rutinasMostrar[index].name,
                    idRutina: rutinasMostrar[index].id,
                    flag: true,
                    numIndex: index,
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              width: 210,
              decoration: BoxDecoration(
                color: kGreenLight3,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        rutinasMostrar[index].name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Ejercicios',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: ListView.separated(
                          itemBuilder: (context, index2) {
                            return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: kGreenLight2,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        rutinasMostrar[index]
                                            .ejercicios[index2]
                                            .name,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 3,
                          ),
                          itemCount: rutinasMostrar[index].ejercicios.length,
                          scrollDirection: Axis.horizontal,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
              height: 20,
            ),
        itemCount: rutinasMostrar.length,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20));
  }
}
