import 'package:flutter/material.dart';
import '../widgets/checkbox_list.dart';
import '../widgets/slider_widget.dart';
import '../models/entry_model.dart';
import '../services/storage_service.dart';

class TriggerScreen extends StatefulWidget {
  @override
  _TriggerScreenState createState() => _TriggerScreenState();
}

class _TriggerScreenState extends State<TriggerScreen> {
  final List<Map<String, dynamic>> triggers = [
    {"title": "Weizen", "value": false},
    {"title": "Kohlenhydrate", "value": false},
    {"title": "Zucker", "value": false},
  ];

  double drinking = 500;
  double outdoors = 30;
  double sleeping = 8;

  void saveEntry() async {
    final entry = Entry(
      date: DateTime.now(),
      triggers: {
        "Weizen": triggers[0]["value"],
        "Kohlenhydrate": triggers[1]["value"],
        "Zucker": triggers[2]["value"],
        "Trinken": drinking,
        "Draussen": outdoors,
        "Schlafen": sleeping,
      },
      symptoms: {}, // Fuege Symptome spaeter hinzu
    );
    await StorageService().saveEntry(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Eintrag gespeichert!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trigger")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CheckboxList(
              items: triggers,
              onChanged: (index, value) {
                setState(() {
                  triggers[index]["value"] = value;
                });
              },
            ),
            SliderWidget(
              value: drinking,
              min: 0,
              max: 3000,
              divisions: 30,
              label: "Trinken: ${drinking.toInt()} ml",
              onChanged: (value) => setState(() => drinking = value),
            ),
            SliderWidget(
              value: outdoors,
              min: 0,
              max: 240,
              divisions: 24,
              label: "Draußen: ${outdoors.toInt()} Minuten",
              onChanged: (value) => setState(() => outdoors = value),
            ),
            SliderWidget(
              value: sleeping,
              min: 0,
              max: 12,
              divisions: 24,
              label: "Schlafen: ${sleeping.toStringAsFixed(1)} Stunden",
              onChanged: (value) => setState(() => sleeping = value),
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
