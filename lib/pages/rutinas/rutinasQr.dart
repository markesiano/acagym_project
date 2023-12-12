import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:acagym_project/constants.dart';
import 'package:acagym_project/data/hive_database.dart';
import 'package:acagym_project/data/rutina_data.dart';
import 'package:acagym_project/models/maquinas_model.dart';
import 'package:acagym_project/models/qr_modeL.dart';
import 'package:acagym_project/models/rutinas_model.dart';
import 'package:flutter/material.dart';
import 'package:acagym_project/pages/rutinas/rutina.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class RutinasQr extends StatefulWidget {
  final String code;
  const RutinasQr({
    super.key,
    required this.code,
  });

  @override
  _RutinasQrState createState() => _RutinasQrState();
}

class _RutinasQrState extends State<RutinasQr> {
  List<RutinasModel>? rutinasListHive = [];
  List<RutinasModel> rutinasFirebase = [];
  late QrImage qrImage;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QrModel>().isScanning = false;
    });
    super.initState();
    final qrCode = QrCode(
      8,
      QrErrorCorrectLevel.H,
    )..addData(widget.code);
    qrImage = QrImage(qrCode);
  }

  MaquinasModel _getMaquina(List<RutinasModel> rutinasFirebase, String code) {
    late MaquinasModel maquina;
    for (int i = 0; i < rutinasFirebase.length; i++) {
      for (int j = 0; j < rutinasFirebase[i].ejercicios.length; j++) {
        if (rutinasFirebase[i].ejercicios[j].maquina != null) {
          if (rutinasFirebase[i].ejercicios[j].maquina!.qr == code) {
            maquina = rutinasFirebase[i].ejercicios[j].maquina!;
          }
        }
      }
    }
    return maquina;
  }

  List<RutinasModel> _getRutinasMostar(
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
        for (int k = 0; k < rutinasFirebase[i].ejercicios.length; k++) {
          if (rutinasFirebase[i].ejercicios[k].maquina != null) {
            if (rutinasFirebase[i].ejercicios[k].maquina!.qr == widget.code) {
              rutinasMostrar.add(rutinasFirebase[i]);
            }
          }
        }
      }
    }
    return rutinasMostrar;
  }

  final GlobalKey _globalKey = GlobalKey();
  dynamic externalDir = '/Storage/emulated/0/Download/';
  bool dirExists = false;
  Future<void> _capturarYdescargarqr() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      final whitePaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(
          recorder,
          Rect.fromLTWH(
              0, 0, image.height.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.height.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());

      final picture = recorder.endRecording();
      final img = await picture.toImage(image.height, image.height);
      ByteData? pngBytes = await img.toByteData(format: ImageByteFormat.png);
      Uint8List? pngBytesList = pngBytes?.buffer.asUint8List();
      String filename = '${widget.code}qr';

      int i = 1;
      while (await File('$externalDir$filename.png').exists()) {
        filename = '${widget.code}qr$i';
        i++;
      }

      dirExists = await Directory('$externalDir').exists();
      if (!dirExists) {
        await Directory('$externalDir').create(recursive: true);
        dirExists = true;
      }

      final file = await File('$externalDir$filename.png').create();
      await file.writeAsBytes(pngBytesList!);
      if (!mounted) return;
      const snackBar = SnackBar(content: Text('QR descargado'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    rutinasFirebase = context.watch<RutinaData>().rutinasList;
    rutinasListHive = context.watch<HiveDatabase>().rutinas;
    ScreenshotController screenshotController = ScreenshotController();

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
            } else if (rutinasMostrar.isNotEmpty) {
              //Se recorre rutinasMostrar para solamente obtener las rutinas que coincidan con el qr de la maquina y verifica que contenga el campo maquina
              MaquinasModel maquina = _getMaquina(rutinasFirebase, widget.code);

              return Column(
                children: [
                  // Ponemos la máquina encontrada junto con su imágen

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(children: [
                      Text(
                        'Rutinas para ${maquina.name.toString().toLowerCase()}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(maquina.image,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                return progress == null
                                    ? child
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              }),
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  key: _globalKey,
                                  child: PrettyQrView(
                                    qrImage: qrImage,
                                    decoration: const PrettyQrDecoration(
                                        image: PrettyQrDecorationImage(
                                            scale: 0.3,
                                            image: AssetImage(
                                                'assets/images/icons/logo.png'))),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kGreenLight4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: _capturarYdescargarqr,
                                  child: const Text('Descargar QR'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),

                  Expanded(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
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
                                                                FontWeight
                                                                    .w500),
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
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 20,
                            ),
                        itemCount: rutinasMostrar.length,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20)),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
