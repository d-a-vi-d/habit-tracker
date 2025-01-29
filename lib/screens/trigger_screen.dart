import 'package:flutter/material.dart';
import '../widgets/checkbox_list.dart';
import '../widgets/slider_widget.dart';
import '../models/entry_model.dart';
import '../services/storage_service.dart';

class TriggerScreen extends StatefulWidget {
  final PageController pageController;
  final VoidCallback toggleThemeMode;

  const TriggerScreen({super.key, required this.pageController, required this.toggleThemeMode});

  @override
  _TriggerScreenState createState() => _TriggerScreenState();
}

class _TriggerScreenState extends State<TriggerScreen> {
  final List<Map<String, dynamic>> triggers = [
    {"title": "Weizen", "value": null},
    {"title": "Kohlenhydrate", "value": null},
    {"title": "Zucker", "value": null},
  ];

  double drinking = 500;
  double outdoors = 30;
  double sleeping = 8;

  DateTime? selectedDateTime = DateTime.now();
  String _getWeekday(DateTime date) {
    const weekdays = ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'];
    return weekdays[date.weekday % 7]; // % 7 ensures that the index is within the range of the weekdays array
  }





  void saveEntry() async {
    final entry = Entry(
      date: selectedDateTime ?? DateTime.now(),
      triggers: {
        "Weizen": triggers[0]["value"],
        "Kohlenhydrate": triggers[1]["value"],
        "Zucker": triggers[2]["value"],
        "Trinken": drinking,
        "Draussen": outdoors,
        "Schlafen": sleeping,
      },
      symptoms: {},
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
        child:
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CheckboxList(
                      items: triggers.map((item) {
                        return {
                          "title": item["title"] ?? "Unknown", // Provide a default value if title is null
                          "value": item["value"] // Ensure value can be null
                        };
                      }).toList(),
                      onChanged: (index, value) {
                        setState(() {
                          triggers[index]["value"] = value;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: saveEntry,
                    child: Text("Speichern"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        SliderWidget(
                          value: drinking,
                          min: 0,
                          max: 4000,
                          divisions: 40,
                          label: "Trinken: ${drinking.toInt()} ml",
                          onChanged: (value) => setState(() => drinking = value),
                        ),
                        SliderWidget(
                          value: outdoors,
                          min: 0,
                          max: 120,
                          divisions: 12,
                          label: "Draußen: ${outdoors.toInt()} Minuten",
                          onChanged: (value) => setState(() => outdoors = value),
                        ),
                        SliderWidget(
                          value: sleeping,
                          min: 3,
                          max: 11,
                          divisions: 32,
                          label: "Schlafen: ${sleeping.toStringAsFixed(1)} Stunden",
                          onChanged: (value) => setState(() => sleeping = value),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: saveEntry,
                    child: Text("Speichern"),
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}