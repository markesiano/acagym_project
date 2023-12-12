import 'package:acagym_project/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AgregarGimnasio extends StatefulWidget {
  final double latitude;
  final double longitude;

  const AgregarGimnasio({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  _AgregarGimnasioState createState() => _AgregarGimnasioState();
}

class _AgregarGimnasioState extends State<AgregarGimnasio> {
  // Se crea la instancia de firebase para que sea agregado un elemento a la tabla gimnasiosACAGYM
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Se crea el controlador para el campo de texto del nombre del gimnasio
  final nombreGimnasioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kGreenLight1,
        appBar: AppBar(
          backgroundColor: kGreenLight2,
          centerTitle: true,
          title: const Text('Agregar gimnasio'),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: kGreenLight1,
            ),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: kGreenLight3,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.black87.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text centrado para indicar que se agregará el gimnasio donde se encuentra actualmente
                  const Text(
                    'Se eviará solicitud del gimnasio donde se encuentra actualmente',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  // Indicamos la latitud y longitud del gimnasio que viene desde HomePage
                  Text(
                      'Latitud: ${widget.latitude} \nLongitud: ${widget.longitude}',
                      style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 20),
                  // Se agrega un campo de texto para el nombre del gimnasio
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: nombreGimnasioController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        labelText: 'Nombre del gimnasio',
                      ),
                    ),
                  ),
                  // Se agrega el botón para guardar el gimnasio
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        // Se agrega el registro a la tabla gimnasiosACAGYM y se verifica que se haya agregado

                        // Comrpobar que esté ingresado el nombre del gimnasio
                        if (nombreGimnasioController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(milliseconds: 750),
                              content: Text('Ingrese el nombre del gimnasio'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          _firestore
                              .collection('gimnasiosACAGYM')
                              .add({
                                'nombre': nombreGimnasioController.text,
                                'latitude': widget.latitude,
                                'longitude': widget.longitude,
                                'status': false,
                              })
                              .then((value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(milliseconds: 1500),
                                      content: Text(
                                          'Se ha enviado su solicitud para agregar el gimnasio'),
                                      backgroundColor: Colors.green,
                                    ),
                                  ))
                              .catchError((error) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      duration: Duration(milliseconds: 1500),
                                      content:
                                          Text('Error al agregar el gimnasio'),
                                      backgroundColor: Colors.red,
                                    ),
                                  ));

                          // Se da un delay

                          Future.delayed(const Duration(milliseconds: 2500),
                              () {
                            // Se regresa a la pantalla anterior
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
