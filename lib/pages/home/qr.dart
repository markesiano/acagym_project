import 'package:acagym_project/models/qr_modeL.dart';
import 'package:acagym_project/pages/rutinas/rutinasQr.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:acagym_project/constants.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  bool _isScanning = false;

  @override
  Widget build(BuildContext context) {
    _isScanning = context.watch<QrModel>().isScanning;
    MobileScannerController controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    return Container(
      color: kGreenLight1,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
              child: Container(
            color: kGreenLight1,
            child: const Column(
              children: [
                Text(
                  'Escanea el código QR del gimnasio para poder acceder a las rutinas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
          Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(20),
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: MobileScanner(
                  controller: controller,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    final code = barcodes[0].rawValue.toString();

                    // Comprobar con regex que siga la nomenclatura "maquina-nombremaquina-numero"

                    RegExp regex =
                        RegExp(r'^[a-zA-Z0-9]+-[a-zA-Z0-9]+-[0-9]+$');

                    if (!regex.hasMatch(code)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: Text(
                            'El código QR no es válido',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else if (!_isScanning) {
                      context.read<QrModel>().isScanning = true;
                      //Detenemos el escaneo de la cámara con el método stop()
                      controller.stop();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PopScope(
                            canPop: true,
                            onPopInvoked: (bool didPop) {
                              if (didPop) {
                                controller.start();
                                MaterialPageRoute(
                                  builder: (context) => const QrPage(),
                                );
                              }
                            },
                            child: RutinasQr(
                              code: code,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              )),
          Expanded(
              child: Container(
            color: Colors.white,
          )),
        ],
      ),
    );
  }
}
