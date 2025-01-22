import 'package:flutter/material.dart';

class CheckboxList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(int, bool) onChanged;

  const CheckboxList({super.key, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        int index = items.indexOf(item);
        return CheckboxListTile(
          title: Text(item['name'] ?? item['title'] ?? 'Unknown'),
          value: item['value'],
          onChanged: (bool? value) {
            onChanged(index, value ?? false);
          },
        );
      }).toList(),
    );
  }
}