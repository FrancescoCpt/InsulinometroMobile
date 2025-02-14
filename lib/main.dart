import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa Provider
import 'package:app/core/app_state.dart'; // Importa AppState
import 'package:app/ui/pages/home_page.dart';
import 'package:app/core/notification_service.dart'; // Importa NotificationService
import 'package:app/core/meal_notification.dart'; // Importa MealNotificationService

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assicura l'inizializzazione di Flutter

  // Inizializza il servizio di notifiche generiche
  await NotificationService.initialize();

  // Inizializza il servizio di notifiche legate ai pasti
  final MealNotificationService mealNotificationService = MealNotificationService();
  await mealNotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()), // Inizializza lo stato globale
        Provider<MealNotificationService>(create: (_) => mealNotificationService), // Fornisci il servizio di notifiche per i pasti
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Somministrazione Insulina',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}