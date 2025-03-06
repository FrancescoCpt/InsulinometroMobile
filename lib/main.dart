import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/core/app_state.dart';
import 'package:app/ui/widgets/bottom_navigation_bar.dart'; // Importa CustomBottomNav
import 'package:app/core/notification_service.dart';
import 'package:app/core/ble_handler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/core/permission_handler_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializza il servizio di notifiche
  await NotificationService.initialize();

  // Richiedi i permessi BLE all'avvio
  await requestBLEPermissions();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => BLEController()),
      ],
      child: MyApp(),
    ),
  );
}

/// Richiede i permessi Bluetooth necessari
Future<void> requestBLEPermissions() async {
  await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.location,
  ].request();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Somministrazione Insulina',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Invece di `home: HomePage()`, usa la custom bottom nav come root
      home: CustomBottomNav(currentIndex: 0),
    );
  }
}
