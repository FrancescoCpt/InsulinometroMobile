import 'package:app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:app/core/database_helper.dart';
import 'package:app/ui/pages/add_somministrazione_page.dart';
import 'package:app/ui/widgets/bottom_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario Somministrazioni',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> somministrazioni = [];
  Map<String, dynamic>? nextSomministrazione;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadSomministrazioni();
    await _loadNextSomministrazione();
  }

  Future<void> _loadSomministrazioni() async {
    final data = await dbHelper.getSomministrazioni();
    setState(() {
      somministrazioni = data;
    });
  }

  Future<void> _loadNextSomministrazione() async {
    final now = DateTime.now();
    final data = somministrazioni.where((s) {
      if (s['isTaken'] == 1) return false; // Escludi le somministrazioni già effettuate
      DateTime sTime = DateFormat('yyyy-MM-dd HH:mm').parse("${s['date']} ${s['time']}");
      return sTime.isAfter(now) || sTime.isBefore(now);
    }).toList();

    if (data.isNotEmpty) {
      data.sort((a, b) {
        DateTime aTime = DateFormat('yyyy-MM-dd HH:mm').parse("${a['date']} ${a['time']}");
        DateTime bTime = DateFormat('yyyy-MM-dd HH:mm').parse("${b['date']} ${b['time']}");
        return aTime.compareTo(bTime);
      });
      setState(() {
        nextSomministrazione = data.first;
      });
    } else {
      setState(() {
        nextSomministrazione = null;
      });
    }
  }

  void _deleteSomministrazione(int id) async {
    await dbHelper.deleteSomministrazione(id);
    _loadData();
  }

  void _markAsTaken(int id) async {
    await dbHelper.markAsTaken(id);
    _loadData();
  }

  Widget _buildNotificationCard() {
    if (nextSomministrazione == null) {
      return Card(
        color: Colors.grey.shade300,
        child: ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Nessuna somministrazione prevista'),
        ),
      );
    }
    DateTime now = DateTime.now();
    DateTime scheduledTime = DateFormat('yyyy-MM-dd HH:mm').parse("${nextSomministrazione!['date']} ${nextSomministrazione!['time']}");
    Color cardColor = scheduledTime.isBefore(now) ? Colors.red.shade300 : Colors.amber.shade100;
    return Card(
      color: cardColor,
      child: ListTile(
          leading: Icon(Icons.notifications),
          title: Text("Prossima somministrazione: \n${nextSomministrazione!['date']} ${nextSomministrazione!['time']} - ${nextSomministrazione!['meal']}")
      ),
    );
  }

  Widget _buildPatchInsulinaCard() {
    return Card(
      color: Colors.lightGreen.shade100,
      child: ListTile(
        leading: Icon(Icons.medication_liquid),
        title: Text('Patch Insulina'),
        subtitle: Text(AppState().getExpirationDate() ?? 'Data non disponibile'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario somministrazioni'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildNotificationCard(),
            SizedBox(height: 16),
            _buildPatchInsulinaCard(),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: somministrazioni.length,
                itemBuilder: (context, index) {
                  final s = somministrazioni[index];
                  return Card(
                    child: ListTile(
                      title: Text('${s['date']} ${s['time']} - ${s['meal']}'),
                      subtitle: Text('${s['dosage']} UI'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          s['isTaken'] == 1
                              ? Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 4),
                              Text('Somministrato', style: TextStyle(color: Colors.green)),
                            ],
                          )
                              : IconButton(
                            icon: Icon(Icons.check_circle_outline),
                            onPressed: () => _markAsTaken(s['id']),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteSomministrazione(s['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    barrierColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return AddSomministrazionePage();
                    },
                  );
                  if (result == true) {
                    _loadData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(fontSize: 19),
                ),
                child: Text('Aggiungi Somministrazione', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 0),
    );
  }
}
