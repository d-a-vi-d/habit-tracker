import 'package:flutter/material.dart';
import '../widgets/checkbox_list.dart';
import '../widgets/slider_widget.dart';
import '../models/entry_model.dart';
import '../services/storage_service.dart';

class SymptomScreen extends StatefulWidget {
  final PageController pageController;
  final VoidCallback toggleThemeMode;

  const SymptomScreen({super.key, required this.pageController, required this.toggleThemeMode});


  @override
  _SymptomScreenState createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  final List<Map<String, dynamic>> symptoms = [
    {'name': 'Müdigkeit', 'value': false},
    {'name': 'Trockene Haut', 'value': false},
    {'name': 'Verdauungsprobleme', 'value': false},
  ];

  void saveEntry() async {
    final entry = Entry(
      date: DateTime.now(),
      triggers: {},
      symptoms: {
        "Müdigkeit": symptoms[0]["value"],
        "Trockene Haut": symptoms[1]["value"],
        "Verdauungsprobleme": symptoms[2]["value"],
      },
    );
    await StorageService().saveEntry(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Eintrag gespeichert!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptome'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleThemeMode,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CheckboxList(
                items: symptoms,
                onChanged: (index, value) {
                  setState(() {
                    symptoms[index]['value'] = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: saveEntry,
                child: Text("Speichern"),
              ),
            ],
          ),
        ),
      );
    }
  }