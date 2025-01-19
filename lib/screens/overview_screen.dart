import 'package:flutter/material.dart';
import '../models/entry_model.dart';
import '../services/storage_service.dart';

class OverviewScreen extends StatelessWidget {
  Future<List<Entry>> fetchEntries() async {
    return await StorageService().getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Übersicht")),
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
                subtitle: Text("Trigger: ${entry.triggers}"),
              );
            },
          );
        },
      ),
    );
  }
}
