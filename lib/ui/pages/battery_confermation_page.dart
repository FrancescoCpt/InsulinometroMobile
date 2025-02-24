import 'package:flutter/material.dart';
import 'package:app/ui/pages/patch_application_failed.dart';
import 'package:app/ui/pages/patch_confermation_page.dart';
import 'package:app/utils/complex_numbers.dart';

class BatteryConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Procedura Completata"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Icona di successo
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(30),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 120,
              ),
            ),

            const SizedBox(height: 20),

            // Testo "Livello della Batteria Sufficiente"
            const Text(
              "Livello della Batteria Sufficiente",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 10),

            // Testo "Procedere con l'applicazione della patch"
            const Text(
              "Procedere con l'applicazione della patch",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            // Pulsante "Premi per Continuare"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  bool checkPassed = Checker(context);
                  if (checkPassed) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>PatchConfermationPage()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatchApplicationFailed ()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Premi per Continuare",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  bool Checker(BuildContext context) {
    List<Complex> array1 = List.generate(100, (i) => Complex(100 - i.toDouble(), 0));
    List<Complex> array2 = List.generate(100, (i) => Complex(200 - i.toDouble(), 0));
    List<Complex> array3 = List.generate(100, (i) => Complex(300 - i.toDouble(), 0));
    List<List<Complex>> spectra = [array1, array2, array3];
    int windowSize = 10;

    for (var spectrum in spectra) {
      List<double> windowAverages = [];
      for (int i = 0; i <= spectrum.length - windowSize; i += windowSize) {
        double avg = spectrum.sublist(i, i + windowSize).map((c) => c.real).reduce((a, b) => a + b) / windowSize;
        windowAverages.add(avg);
      }

      for (int i = 1; i < windowAverages.length; i++) {
        if (windowAverages[i] >= windowAverages[i - 1]) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Monotonicità non rispettata. Verificare adesione della patch.')),
          );
          return false;
        }
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Monotonicità rispettata, procedere con la verifica della deviazione standard.')),
    );
    return true;
  }
}


