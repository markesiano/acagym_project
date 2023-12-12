import 'package:acagym_project/constants.dart';
import 'package:acagym_project/data/hive_database.dart';
import 'package:acagym_project/data/rutina_data.dart';
import 'package:acagym_project/pages/rutinas/rutina.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:acagym_project/models/rutinas_model.dart';

class RutinasPage extends StatefulWidget {
  const RutinasPage({super.key});

  @override
  State<RutinasPage> createState() => _RutinasPageState();
}

class _RutinasPageState extends State<RutinasPage> {
  List<RutinasModel>? rutinasListHive = [];
  List<RutinasModel> rutinasFirebase = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rutinasFirebase = context.watch<RutinaData>().rutinasList;
    rutinasListHive = context.watch<HiveDatabase>().rutinas;
    return ValueListenableBuilder(
        valueListenable: Hive.box<RutinasModel>('rutinas').listenable(),
        builder: (context, Box<RutinasModel> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No tienes rutinas',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            );
          } else {
            return _rutinasSection(box.values.toList());
          }
        });
  }

  Widget _rutinasSection(List<RutinasModel>? rutinasMostrar) {
    // Se extrae aun método para que no se ejecute cada vez que se renderiza el widget

    if (rutinasMostrar!.isNotEmpty) {
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
                      flag: false,
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
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                  color: kGreenLight2,
                                  borderRadius: BorderRadius.circular(20),
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
                            separatorBuilder: (context, index) =>
                                const SizedBox(
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
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  // Container _searchField() {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
  //     decoration: BoxDecoration(boxShadow: [
  //       BoxShadow(
  //         color: Color(0xff1D1617).withOpacity(0.11),
  //         blurRadius: 40,
  //         spreadRadius: 0.0,
  //       )
  //     ]),
  //     child: TextField(
  //       decoration: InputDecoration(
  //         filled: true,
  //         fillColor: Colors.white,
  //         contentPadding: const EdgeInsets.all(15),
  //         hintText: 'Buscar',
  //         hintStyle: TextStyle(
  //           color: Colors.black.withOpacity(0.5),
  //           fontSize: 14,
  //         ),
  //         prefixIcon: Padding(
  //           padding: const EdgeInsets.all(12),
  //           child: SvgPicture.asset(
  //             'assets/icons/search-svgrepo-com.svg',
  //           ),
  //         ),
  //         border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(15),
  //             borderSide: BorderSide.none),
  //       ),
  //     ),
  //   );
  // }
}
