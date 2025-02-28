import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEController extends ChangeNotifier {
  final FlutterReactiveBle _ble = FlutterReactiveBle();
  List<DiscoveredDevice> _devices = [];
  bool _isScanning = false;
  DiscoveredDevice? _connectedDevice;

  List<DiscoveredDevice> get devices => _devices;
  bool get isScanning => _isScanning;
  DiscoveredDevice? get connectedDevice => _connectedDevice;

  /// Richiede i permessi necessari per BLE
  Future<void> requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  /// Avvia la scansione dei dispositivi BLE
  void startScan() async {
    await requestPermissions();

    _devices.clear();
    _isScanning = true;
    notifyListeners(); // Notifica UI

    _ble.scanForDevices(withServices: []).listen((device) {
      if (!_devices.any((d) => d.id == device.id)) {
        _devices.add(device);
        notifyListeners();
      }
    }).onDone(() {
      _isScanning = false;
      notifyListeners();
    });
  }

  /// Si connette a un dispositivo BLE
  Future<void> connectToDevice(DiscoveredDevice device) async {
    try {
      await _ble.connectToDevice(id: device.id).first;
      _connectedDevice = device;
      notifyListeners();
    } catch (e) {
      print("Errore di connessione: $e");
    }
  }

  /// Disconnette il dispositivo attualmente connesso
  Future<void> disconnectDevice() async {
    _connectedDevice = null;
    notifyListeners();
  }
}
