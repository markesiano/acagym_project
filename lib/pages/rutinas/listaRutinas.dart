import 'package:acagym_project/data/hive_database.dart';
import 'package:acagym_project/models/rutinas_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:acagym_project/pages/rutinas/rutina.dart';

class ListaRutinas extends StatefulWidget {
  const ListaRutinas({Key? key}) : super(key: key);

  @override
  _ListaRutinasState createState() => _ListaRutinasState();
}

class _ListaRutinasState extends State<ListaRutinas> {
  final HiveDatabase hiveData = const HiveDatabase();
  List<RutinasModel> rutinasListHive = [];

  @override
  void initState() {
    getRutinas();
    super.initState();
  }

  Future<void> getRutinas() async {
    rutinasListHive = await hiveData.rutinas;
    setState(() {});
  }

  Stream<List<RutinasModel>> readRutinas() => FirebaseFirestore.instance
      .collection('rutinas')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => RutinasModel.fromJson(doc.data()))
          .toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutinas'),
      ),
      body: StreamBuilder(
        stream: readRutinas(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error');
          } else if (snapshot.hasData) {
            final rutinas = snapshot.data as List<RutinasModel>;

            List<RutinasModel> rutinasMostrar = [];

            //Se recorren las dos listas para que solamente se despliegue la que se va a mostrar, la cual es todos los datos que no pertenezcan a la lista de rutinas de hive

            for (int i = 0; i < rutinas.length; i++) {
              bool flag = true;
              for (int j = 0; j < rutinasListHive.length; j++) {
                if (rutinas[i].id == rutinasListHive[j].id) {
                  flag = false;
                }
              }
              if (flag) {
                rutinasMostrar.add(rutinas[i]);
              }
            }

            if (rutinasMostrar.length == 0) {
              return Center(
                child: Text(
                  'No hay rutinas disponibles',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              );
            } else {
              return Container(
                //height: _height * 0.7,
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
                                flag: true,
                                numIndex: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: 210,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    rutinasMostrar[index].name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Ejercicios',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    child: ListView.separated(
                                      itemBuilder: (context, index2) {
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                                    style: TextStyle(
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
                                          SizedBox(
                                        width: 3,
                                      ),
                                      itemCount: rutinasMostrar[index]
                                          .ejercicios
                                          .length,
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
                    separatorBuilder: (context, index) => SizedBox(
                          height: 20,
                        ),
                    itemCount: rutinasMostrar.length,
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 20)),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
