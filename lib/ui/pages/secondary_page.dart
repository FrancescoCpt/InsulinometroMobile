import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/core/app_state.dart';
import 'package:app/ui/widgets/bottom_navigation_bar.dart';
import 'package:app/ui/pages/medical_staff_page.dart';

class InsulinometerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Insulinometer', style: TextStyle()),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDeviceStatusCard(appState.isDeviceConnected),
            SizedBox(height: 32),
            _buildActionButton('Staff Medico', Colors.blue, Colors.white, () => _showPinDialog(context)),
            SizedBox(height: 16),
            _buildActionButton('Settings', Colors.grey[800]!, Colors.white, () {}),
          ],
        ),
      ),
        bottomNavigationBar: CustomBottomNav(currentIndex: 0));
  }

  void _showPinDialog(BuildContext context) {
    TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter PIN'),
          content: TextField(
            controller: pinController,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter 4-digit PIN'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (pinController.text == Provider.of<AppState>(context, listen: false).pin) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MedicalStaffPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Incorrect PIN')),
                  );
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeviceStatusCard(bool isDeviceConnected) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Device Connection", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                SizedBox(height: 4),
                Text(
                  isDeviceConnected ? "Connected" : "No Device Connected",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDeviceConnected ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Battery", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      isDeviceConnected ? Icons.battery_full : Icons.battery_unknown,
                      color: Colors.grey[700],
                    ),
                    SizedBox(width: 4),
                    Text(
                      isDeviceConnected ? "75%" : "--%",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, Color textColor, VoidCallback onPressed) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        child: Text(text, style: TextStyle(fontSize: 18, color: textColor)),
      ),
    );
  }
}