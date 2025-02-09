import 'package:flutter/material.dart';

class CheckboxList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(int, bool?) onChanged;

  const CheckboxList({
    Key? key,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        print(items[index]);
        return CheckboxListTile(
          title: Text(items[index]['title'] ?? ''),
          value: items[index]['value'],
          tristate: true,
          onChanged: (bool? value) {
            onChanged(index, value);
          },
        );
      },
    );
  }
}