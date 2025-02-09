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
  final List<Map<String, dynamic>> triggers_short = [
    {"title": "Weizen", "value": null},
    {"title": "Kohlenhydrate", "value": null},
    {"title": "Zucker", "value": null},
  ];

  final List<Map<String, dynamic>> triggers_long = [
    {"title": "Trinken", "value": 500.0, "start": 0.0, "end": 1000.0, "step": 50.0},
    {"title": "Draussen", "value": 30.0, "start": 0.0, "end": 120.0, "step": 10.0},
    {"title": "Schlafen", "value": 8.0, "start": 0.0, "end": 24.0, "step": 1.0},
  ];

  DateTime? selectedDateTime = DateTime.now();
  String _getWeekday(DateTime date) {
    const weekdays = ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'];
    return weekdays[date.weekday % 7]; // % 7 ensures that the index is within the range of the weekdays array
  }

  void saveShortTriggers() async {
    final entry = Entry(
      date: DateTime(
        selectedDateTime?.year ?? DateTime.now().year,
        selectedDateTime?.month ?? DateTime.now().month,
        selectedDateTime?.day ?? DateTime.now().day,
        selectedDateTime?.hour ?? 0,
        selectedDateTime?.minute ?? 0,
      ),
      triggers: {
        "Weizen": triggers_short[0]["value"],
        "Kohlenhydrate": triggers_short[1]["value"],
        "Zucker": triggers_short[2]["value"],
      },
      symptoms: {},
    );
    await StorageService().saveEntry(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Eintrag gespeichert!")),
    );
  }

  void saveLongTriggers() async {
    final entry = Entry(
      date: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      triggers: {
        "Trinken": triggers_long[0]["value"],
        "Draussen": triggers_long[1]["value"],
        "Schlafen": triggers_long[2]["value"],
      },
      symptoms: {},
    );
    await StorageService().saveEntry(entry);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Eintrag gespeichert!")),
    );
  }

  void _addTrigger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTriggerName = '';
        String triggerType = 'short';
        double startValue = 0.0;
        double endValue = 100.0;
        double stepValue = 1.0;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Trigger'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: triggerType,
                    onChanged: (String? newValue) {
                      setState(() {
                        triggerType = newValue!;
                      });
                    },
                    items: <String>['short', 'long']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextField(
                    onChanged: (value) {
                      newTriggerName = value;
                    },
                    decoration: InputDecoration(hintText: "Enter trigger name"),
                  ),
                  if (triggerType == 'long') ...[
                    TextField(
                      onChanged: (value) {
                        startValue = double.tryParse(value) ?? 0.0;
                      },
                      decoration: InputDecoration(hintText: "Enter start value"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      onChanged: (value) {
                        endValue = double.tryParse(value) ?? 100.0;
                      },
                      decoration: InputDecoration(hintText: "Enter end value"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      onChanged: (value) {
                        stepValue = double.tryParse(value) ?? 1.0;
                      },
                      decoration: InputDecoration(hintText: "Enter step value"),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (triggerType == 'short') {
                        triggers_short.add({'title': newTriggerName, 'value': null});
                      } else {
                        triggers_long.add({
                          'title': newTriggerName,
                          'value': startValue,
                          'start': startValue,
                          'end': endValue,
                          'step': stepValue,
                        });
                      }
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trigger"),
        actions: [
          // Date and time pickers
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Short triggers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CheckboxList(
                    items: triggers_short.map((item) {
                      return {
                        "title": item["title"] ?? "Unknown",
                        "value": item["value"]
                      };
                    }).toList(),
                    onChanged: (index, value) {
                      setState(() {
                        triggers_short[index]["value"] = value;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: saveShortTriggers,
                  child: Text("Speichern"),
                ),
              ],
            ),
            // Long triggers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      ...triggers_long.map((item) {
                        return SliderWidget(
                          value: item['value'] ?? item['start'],
                          min: item['start'],
                          max: item['end'],
                          divisions: ((item['end'] - item['start']) / item['step']).round(),
                          label: "${item['title']}: ${item['value']?.toStringAsFixed(1) ?? item['start'].toStringAsFixed(1)}",
                          onChanged: (value) => setState(() => item['value'] = value),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: saveLongTriggers,
                  child: Text("Speichern"),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _addTrigger,
              child: Text("Add Trigger"),
            ),
          ],
        ),
      ),
    );
  }
}