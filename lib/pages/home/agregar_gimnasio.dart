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
        appBar: AppBar(
          title: Text('Agregar gimnasio'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text centrado para indicar que se agregará el gimnasio donde se encuentra actualmente
                Text(
                  'Se eviará solicitud del gimnasio donde se encuentra actualmente',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                // Indicamos la latitud y longitud del gimnasio que viene desde HomePage
                Text(
                    'Latitud: ${widget.latitude} \nLongitud: ${widget.longitude}',
                    style: TextStyle(fontSize: 15)),
                SizedBox(height: 20),
                // Se agrega un campo de texto para el nombre del gimnasio
                Container(
                  width: 300,
                  child: TextField(
                    controller: nombreGimnasioController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre del gimnasio',
                    ),
                  ),
                ),
                // Se agrega el botón para guardar el gimnasio
                ElevatedButton(
                  onPressed: () {
                    // Se agrega el registro a la tabla gimnasiosACAGYM y se verifica que se haya agregado
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
                              SnackBar(
                                duration: Duration(milliseconds: 500),
                                content: Text('Gimnasio agregado'),
                                backgroundColor: Colors.green,
                              ),
                            ))
                        .catchError((error) =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(milliseconds: 500),
                                content: Text('Error al agregar el gimnasio'),
                                backgroundColor: Colors.red,
                              ),
                            ));

                    // Se da un delay

                    Future.delayed(const Duration(milliseconds: 1000), () {
                      // Se regresa a la pantalla anterior
                      Navigator.pop(context);
                    });
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ),
        ));
  }
}
