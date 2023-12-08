import 'package:acagym_project/data/hive_database.dart';
import 'package:acagym_project/data/rutina_data.dart';
import 'package:acagym_project/pages/rutinas/rutina.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:acagym_project/models/rutinas_model.dart';

class RutinasPage extends StatefulWidget {
  const RutinasPage({super.key});

  @override
  State<RutinasPage> createState() => _RutinasPageState();
}

class _RutinasPageState extends State<RutinasPage> {
  List<RutinasModel>? rutinasListHive = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    rutinasListHive = context.watch<HiveDatabase>().rutinas;

    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    print('ESTE ES EL VALOR DE RUTINAS LIST: $rutinasListHive');

    return Consumer<RutinaData>(
        builder: (context, value, child) => (value.rutinasList.isNotEmpty)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _searchField(),
                  const SizedBox(
                    height: 40,
                  ),

                  _rutinasSection(value),
                ],
              )
            : const Center(
                child: Text(
                  'No tienes rutinas',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ));
  }

  Column _rutinasSection(RutinaData value) {
    //Se compararán las rutinas de la base de datos con las de hive

    //Se recorre la lista de rutinas de la base de datos

    List<RutinasModel> rutinasMostrar = [];

    for (int i = 0; i < value.rutinasList.length; i++) {
      //Se recorre la lista de rutinas de hive
      for (int j = 0; j < rutinasListHive!.length; j++) {
        //Se compara si el id de la rutina de la base de datos es igual al id de la rutina de hive
        if (value.rutinasList[i].id == rutinasListHive![j].id) {
          //Si es igual, se agrega a la lista de rutinas a mostrar
          rutinasMostrar.add(value.rutinasList[i]);
        }
      }
    }

    //Obtenemos el tamaño de la pantalla
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    Size size = view.physicalSize / view.devicePixelRatio;
    double _height = size.height;

    if (rutinasMostrar.length == 0) {
      return const Column(
        children: [
          Center(
            child: Text(
              'No tienes rutinas nuevas',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          )
        ],
      );
    } else if (rutinasMostrar.length > 0) {
      return Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            height: _height * 0.7,
            child: ListView.separated(
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
                        color: Colors.grey[50],
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
                                        color: Colors.grey[100],
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
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                  itemCount:
                                      rutinasMostrar[index].ejercicios.length,
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
                padding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 20)),
          )
        ],
      );
    } else {
      return const Column(
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
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
