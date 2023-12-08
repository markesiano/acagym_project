import 'package:flutter/material.dart';

class QrModel extends ChangeNotifier {
  bool _isScanning = false;

  bool get isScanning => _isScanning;

  set isScanning(bool value) {
    _isScanning = value;
    notifyListeners();
  }
}
