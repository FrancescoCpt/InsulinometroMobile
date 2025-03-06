import 'package:app/core/ble_handler.dart';
import 'package:app/core/data_manager.dart';
import 'package:app/ui/pages/battery_confermation_page.dart';
import 'package:app/ui/pages/battery_low_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BLEScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bleController = Provider.of<BLEController>(context);
    final deviceManager = DeviceDataManager();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Connessione")),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.blue, width: 2),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 5.0, spreadRadius: 2.0),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const SizedBox(height: 16),
              const Text("Seleziona dispositivo per la connessione", style: TextStyle(fontWeight: FontWeight.bold)),

              Expanded( // Rende la lista scrollabile
                child: Consumer<BLEController>(
                  builder: (context, bleController, child) {
                    if (bleController.devices.isEmpty) {
                      return const Center(child: Text("Nessun dispositivo trovato", style: TextStyle(color: Colors.grey)));
                    }
                    return ListView.builder(
                      itemCount: bleController.devices.length,
                      itemBuilder: (context, index) {
                        final device = bleController.devices[index];
                        return deviceButton(
                            device.id.isNotEmpty ? "${device.name} ${device.id}" : "Unknown Device",
                            device,
                            bleController
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: bleController.startScan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    child: Text(bleController.isScanning ? "Scanning..." : "Scan"),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Pulsante "Continua" con controllo batteria
              ElevatedButton(
                onPressed: () {
                  int batteryLevel = deviceManager.getSimulatedBatteryLevel();

                  if (batteryLevel > 50) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BatteryConfirmationPage()),
                    ); // Sostituisci con la pagina successiva
                  } else {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BatteryLowPage()),
                    ); // Sostituisci con la pagina successiva
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("Continua", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Pulsante per selezionare il tipo di connessione (Bluetooth / USB)
  Widget connectionButton(String type) {
    return ElevatedButton(
      onPressed: () {
        // Qui puoi gestire il cambio di tipo di connessione
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(120, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(type == "Bluetooth" ? Icons.bluetooth : Icons.usb, size: 30),
          const SizedBox(height: 5),
          Text(type, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  /// Pulsante per connettersi a un dispositivo BLE
  Widget deviceButton(String deviceName, dynamic device, BLEController bleController) {
    return GestureDetector(
      onTap: () {
        bleController.connectToDevice(device);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          deviceName,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
