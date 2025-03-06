import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/core/app_state.dart';
import 'package:intl/intl.dart';

class AddUserDetailsPage extends StatefulWidget {
  @override
  _AddUserDetailsPageState createState() => _AddUserDetailsPageState();
}

class _AddUserDetailsPageState extends State<AddUserDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void _saveUserDetails() async {
    if (nameController.text.isEmpty || surnameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Inserisci nome e cognome validi!")),
      );
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    final appState = Provider.of<AppState>(context, listen: false);
    await appState.saveUserDetails(
      nameController.text,
      surnameController.text,
      formattedDate,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Dati salvati con successo!")),
    );

    Navigator.pop(context, true);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent, // Sfondo trasparente
      insetPadding: EdgeInsets.all(10),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Inserisci Generalità",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nome"),
              ),
              TextField(
                controller: surnameController,
                decoration: InputDecoration(labelText: "Cognome"),
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Data di Nascita",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(selectedDate),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("Annulla"),
                  ),
                  ElevatedButton(
                    onPressed: _saveUserDetails,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: Text("Salva"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
