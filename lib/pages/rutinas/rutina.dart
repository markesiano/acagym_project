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
  final HiveDatabase hiveData = HiveDatabase();

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
                              .addRutina(value.getRutinaById(widget.idRutina));
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.add_circle_outline_outlined),
                      ),
                    ]
                  : [
                      IconButton(
                        onPressed: () {
                          // Preguntar si realmente quiere eliminar

                          AlertDialog alert = AlertDialog(
                            title: const Text("Eliminar rutina"),
                            content: const Text(
                                "¿Estás seguro que quieres eliminar esta rutina?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancelar"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text("Eliminar"),
                                onPressed: () {
                                  hiveData.deleteRutina(widget.numIndex);
                                  // Si se completa, se elimina el ejercicio y se vuelve a la pantalla anterior

                                  Navigator.pop(context);
                                  Navigator.pop(context);
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
                        icon: const Icon(Icons.delete),
                      ),
                    ],
            ),
            body: Container(
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: ListView.separated(
                  itemCount: value.getEjerciciosCount(widget.idRutina),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                  itemBuilder: (context, index) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            value
                                .getRutinaById(widget.idRutina)
                                .ejercicios[index]
                                .name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
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
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Text(
                                        'Series: ${value.getRutinaById(widget.idRutina).ejercicios[index].series}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Text(
                                        'Repeticiones: ${value.getRutinaById(widget.idRutina).ejercicios[index].repeticiones}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                      child: (value
                                                  .getRutinaById(
                                                      widget.idRutina)
                                                  .ejercicios[index]
                                                  .peso !=
                                              null)
                                          ? Text(
                                              'Peso: ${value.getRutinaById(widget.idRutina).ejercicios[index].peso}Kg',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          : const SizedBox(
                                              width: 10,
                                            ),
                                    ),
                                  ],
                                ))
                              ]),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text('Músculos',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(
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
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 10, right: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                                        ),
                                        child: Text(
                                          value
                                              .getRutinaById(widget.idRutina)
                                              .ejercicios[index]
                                              .musculos[index2],
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
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
                          const SizedBox(
                            height: 10,
                          ),
                          (value
                                      .getRutinaById(widget.idRutina)
                                      .ejercicios[index]
                                      .maquina !=
                                  null)
                              ? const Text('Máquina',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold))
                              : const SizedBox(
                                  width: 10,
                                ),
                          const SizedBox(
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
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                              ),
                                            ),
                                            child: Text(
                                              value
                                                  .getRutinaById(
                                                      widget.idRutina)
                                                  .ejercicios[index]
                                                  .maquina!
                                                  .name,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                            ),
                                          ),
                                          child: Image(
                                            image: AssetImage(value
                                                .getRutinaById(widget.idRutina)
                                                .ejercicios[index]
                                                .maquina!
                                                .image),
                                            width: 200,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                              : const SizedBox(
                                  width: 10,
                                ),
                        ],
                      )),
                ),
              ),
            )));
  }
}
