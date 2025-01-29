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
    {'name': 'Müdigkeit', 'value': null},
    {'name': 'Trockene Haut', 'value': null},
    {'name': 'Verdauungsprobleme', 'value': null},
  ];

  DateTime? selectedDateTime = DateTime.now();
  String _getWeekday(DateTime date) {
    const weekdays = ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'];
    return weekdays[date.weekday % 7]; // % 7 ensures that the index is within the range of the weekdays array
  }

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
        title: Text("Trigger"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () async {
                  // Datum auswählen
                  final DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDateTime ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      selectedDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedDateTime?.hour ?? 0,
                        selectedDateTime?.minute ?? 0,
                      );
                    });
                  }
                },
                child: Text(
                  "${selectedDateTime != null ? "${_getWeekday(selectedDateTime!)} " : ''}"
                      "${selectedDateTime?.day ?? DateTime.now().day}.${selectedDateTime?.month ?? DateTime.now().month}.${selectedDateTime?.year ?? DateTime.now().year}",
                  style: TextStyle(fontSize: 18),
                ),
              ),

              TextButton(
                onPressed: () async {
                  // Uhrzeit auswählen
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      selectedDateTime = DateTime(
                        selectedDateTime?.year ?? DateTime.now().year,
                        selectedDateTime?.month ?? DateTime.now().month,
                        selectedDateTime?.day ?? DateTime.now().day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                },
                child: Text(
                  "${selectedDateTime?.hour ?? DateTime.now().hour}:${selectedDateTime?.minute ?? DateTime.now().minute}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              IconButton(
                icon: Icon(Icons.brightness_6),
                onPressed: widget.toggleThemeMode,
              ),
            ],
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