import 'package:acagym_project/pages/rutinas/rutinasQr.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

const bgColor = Color(0xfffafafa);

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  bool isScanCompleted = false;
  bool isFrontCamera = false;

  void closeScanner() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
              child: Container(
            child: Column(
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
            color: bgColor,
          )),
          Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: MobileScanner(
                  controller: MobileScannerController(
                    detectionSpeed: DetectionSpeed.noDuplicates,
                    facing: CameraFacing.back,
                    torchEnabled: false,
                  ),
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    final code = barcodes[0].rawValue.toString();

                    // Comprobar con regex que siga la nomenclatura "maquina-nombremaquina-numero"

                    RegExp regex =
                        RegExp(r'^[a-zA-Z0-9]+-[a-zA-Z0-9]+-[0-9]+$');

                    if (!regex.hasMatch(code)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
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
                    } else if (!isScanCompleted) {
                      isScanCompleted = true;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RutinasQr(
                            code: code,
                            closeScreen: closeScanner,
                          ),
                        ),
                      );
                    }
                  },
                ),
              )),
          Expanded(
              child: Container(
            color: bgColor,
          )),
        ],
      ),
    );
  }
}
