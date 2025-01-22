import 'package:flutter/material.dart';
import '../models/entry_model.dart';
import '../services/storage_service.dart';

class OverviewScreen extends StatelessWidget {
  final PageController pageController;
  final VoidCallback toggleThemeMode;

  const OverviewScreen({super.key, required this.pageController, required this.toggleThemeMode});

  Future<List<Entry>> fetchEntries() async {
    return await StorageService().getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overview'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: toggleThemeMode,
          ),
        ],
      ),
      body: FutureBuilder<List<Entry>>(
        future: fetchEntries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final entries = snapshot.data!;
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return ListTile(
                title: Text(entry.date.toLocal().toString()),
                subtitle: Text("Trigger: ${entry.triggers}" +
                    "\nSymptome: ${entry.symptoms}"),
              );
            },
          );
        },
      ),
    );
  }
}