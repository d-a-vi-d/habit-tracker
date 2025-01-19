import 'package:flutter/material.dart';
import '../widgets/checkbox_list.dart';

class SymptomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> symptoms = [
      {'name': 'Müdigkeit', 'isChecked': false},
      {'name': 'Trockene Haut', 'isChecked': false},
      {'name': 'Verdauungsprobleme', 'isChecked': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Symptome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CheckboxList(
          items: symptoms,
          onChanged: (index, value) {
            // Verarbeitung der Checkbox-Änderungen
            print('Checkbox geändert: ${symptoms[index]['name']} -> $value');
          },
        ),
      ),
    );
  }
}
