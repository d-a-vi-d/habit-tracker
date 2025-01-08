import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool weizenChecked = false;
  bool kohlenhydrateChecked = false;
  bool zuckerChecked = false;
  String selectedMahlzeit = 'Frühstück'; // Mahlzeit Dropdown
  String uhrzeit = ''; // Uhrzeit
  bool showDetails = false; // Steuert, ob Details angezeigt werden
  PageController _pageController = PageController(); // Controller für das Wischen

  List<Map<String, dynamic>> checkboxItems = [
    {"title": "Weizen", "value": false},
    {"title": "Kohlenhydrate", "value": false},
    {"title": "Zucker", "value": false},
  ];
  List<Map<String, dynamic>> trockeneHautCheckboxes = [
    {"title": "Trockene Haut (Stelle 1)", "value": false},
    {"title": "Trockene Haut (Stelle 2)", "value": false},
    {"title": "Trockene Haut (Stelle 3)", "value": false},
    {"title": "Trockene Haut (Stelle 4)", "value": false},
  ];
  double trinken = 500; // Startwert für Trinken in ml
  double draussen = 30; // Startwert für Dauer draußen in Minuten
  double schlafen = 8; // Startwert für Schlaf in Stunden

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tracker App'),
          backgroundColor: Colors.orange,
        ),
        body: PageView(
          controller: _pageController,
          children: [
            // Auslöser Seite
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Mahlzeit Auswahl
                    Text(
                      'Mahlzeit',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    // Button, um die Detailansicht anzuzeigen
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mahlzeit Details',
                          style: TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showDetails = !showDetails; // Umschalten der Anzeige
                            });
                          },
                          child: Text(showDetails ? 'Details ausblenden' : 'Details anzeigen'),
                        ),
                      ],
                    ),

                    // Wenn der Button gedrückt wird, die Details anzeigen
                    if (showDetails) ...[
                      SizedBox(height: 10),
                      // Dropdown für Mahlzeit
                      DropdownButton<String>(
                        value: selectedMahlzeit,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMahlzeit = newValue!;
                          });
                        },
                        items: <String>[
                          'Frühstück',
                          'Snack',
                          'Mittagessen',
                          'Nachspeise',
                          'Abendessen'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      // Uhrzeit Eingabe
                      TextField(
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: 'Uhrzeit (HH:MM)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            uhrzeit = value;
                          });
                        },
                      ),
                      // Ernährung - Checkboxen
                      SizedBox(height: 20),
                      Column(
                        children: checkboxItems.map((item) {
                          return CheckboxListTile(
                            title: Text(item["title"]),
                            value: item["value"],
                            onChanged: (bool? value) {
                              setState(() {
                                item["value"] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Menge an Trinken: ${trinken.toInt()} ml"),
                          Slider(
                            value: trinken,
                            min: 0,
                            max: 3000,
                            divisions: 30,
                            label: "${trinken.toInt()} ml",
                            onChanged: (value) {
                              setState(() {
                                trinken = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Text("Dauer draußen: ${draussen.toInt()} Minuten"),
                          Slider(
                            value: draussen,
                            min: 0,
                            max: 240,
                            divisions: 24,
                            label: "${draussen.toInt()} Minuten",
                            onChanged: (value) {
                              setState(() {
                                draussen = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          Text("Schlaf: ${schlafen.toStringAsFixed(1)} Stunden"),
                          Slider(
                            value: schlafen,
                            min: 0,
                            max: 12,
                            divisions: 24,
                            label: "${schlafen.toStringAsFixed(1)} Stunden",
                            onChanged: (value) {
                              setState(() {
                                schlafen = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],

                    // Weitere Auslöser (immer sichtbar)
                    SizedBox(height: 20),
                    Text(
                      'Weitere Auslöser:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(title: Text('Essen')),
                        ListTile(title: Text('Menge an Trinken')),
                        ListTile(title: Text('Dauer Draußen')),
                        ListTile(title: Text('Schlaf')),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Symptome Seite
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Symptome',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // Symptome Auswahl
                    CheckboxListTile(
                      title: Text("Trockene Haut (Stelle 1)"),
                      value: false,
                      onChanged: (bool? value) {},
                    ),
                    CheckboxListTile(
                      title: Text("Trockene Haut (Stelle 2)"),
                      value: false,
                      onChanged: (bool? value) {},
                    ),
                    CheckboxListTile(
                      title: Text("Trockene Haut (Stelle 3)"),
                      value: false,
                      onChanged: (bool? value) {},
                    ),
                    // Weitere Symptome hier hinzufügen...
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
