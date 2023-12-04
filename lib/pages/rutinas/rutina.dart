import 'package:acagym_project/data/hive_database.dart';
import 'package:acagym_project/data/rutina_data.dart';
import 'package:acagym_project/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RutinaPage extends StatefulWidget {
  final String nombre;
  final String idRutina;
  final bool flag;
  final int numIndex;

  const RutinaPage(
      {super.key,
      required this.nombre,
      required this.idRutina,
      this.flag = false,
      this.numIndex = 0});
  static String id = 'rutina_screen';
  @override
  State<RutinaPage> createState() => _RutinaPageState();
}

class _RutinaPageState extends State<RutinaPage> {
  final HiveDatabase hiveData = const HiveDatabase();

  @override
  Widget build(BuildContext context) {
    return Consumer<RutinaData>(
        builder: (context, value, child) => Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(widget.nombre),
              actions: (widget.flag)
                  ? [
                      IconButton(
                        onPressed: () {
                          hiveData
                              .saveRutina(value.getRutinaById(widget.idRutina));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                        icon: Icon(Icons.add_circle_outline_outlined),
                      ),
                    ]
                  : [
                      IconButton(
                        onPressed: () {
                          // Preguntar si realmente quiere eliminar

                          AlertDialog alert = AlertDialog(
                            title: Text("Eliminar rutina"),
                            content: Text(
                                "¿Estás seguro que quieres eliminar esta rutina?"),
                            actions: [
                              TextButton(
                                child: Text("Cancelar"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Eliminar"),
                                onPressed: () {
                                  hiveData.deleteRutina(widget.numIndex);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                },
                              ),
                            ],
                          );

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
            ),
            body: Container(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: ListView.separated(
                  itemCount: value.getEjerciciosCount(widget.idRutina),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 20,
                  ),
                  itemBuilder: (context, index) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            value
                                .getRutinaById(widget.idRutina)
                                .ejercicios[index]
                                .name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Series: ' +
                                            value
                                                .getRutinaById(widget.idRutina)
                                                .ejercicios[index]
                                                .series
                                                .toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Repeticiones: ' +
                                            value
                                                .getRutinaById(widget.idRutina)
                                                .ejercicios[index]
                                                .repeticiones
                                                .toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: (value
                                                  .getRutinaById(
                                                      widget.idRutina)
                                                  .ejercicios[index]
                                                  .peso !=
                                              null)
                                          ? Text(
                                              'Peso: ' +
                                                  value
                                                      .getRutinaById(
                                                          widget.idRutina)
                                                      .ejercicios[index]
                                                      .peso
                                                      .toString() +
                                                  'Kg',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          : SizedBox(
                                              width: 10,
                                            ),
                                    ),
                                  ],
                                ))
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Músculos',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              alignment: Alignment.center,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index2) {
                                      return Container(
                                        padding: EdgeInsets.only(
                                            top: 15, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          value
                                              .getRutinaById(widget.idRutina)
                                              .ejercicios[index]
                                              .musculos[index2],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      width: 10,
                                    ),
                                    itemCount: value
                                        .getRutinaById(widget.idRutina)
                                        .ejercicios[index]
                                        .musculos
                                        .length,
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          (value
                                      .getRutinaById(widget.idRutina)
                                      .ejercicios[index]
                                      .maquina !=
                                  null)
                              ? Text('Máquina',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                              : SizedBox(
                                  width: 10,
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          (value
                                      .getRutinaById(widget.idRutina)
                                      .ejercicios[index]
                                      .maquina !=
                                  null)
                              ? Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              value
                                                  .getRutinaById(
                                                      widget.idRutina)
                                                  .ejercicios[index]
                                                  .maquina!
                                                  .name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Image(
                                        image: AssetImage(value
                                            .getRutinaById(widget.idRutina)
                                            .ejercicios[index]
                                            .maquina!
                                            .image),
                                        width: 200,
                                        height: 200,
                                      ),
                                    ],
                                  ))
                              : SizedBox(
                                  width: 10,
                                ),
                        ],
                      )),
                ),
              ),
            )));
  }
}
