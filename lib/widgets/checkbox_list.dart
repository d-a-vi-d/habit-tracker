import 'package:flutter/material.dart';

class CheckboxList extends StatefulWidget {
  final List<Map<String, dynamic>> items; // Liste der Checkbox-Elemente
  final Function(int index, bool value)? onChanged; // Callback-Funktion für Änderungen

  CheckboxList({required this.items, this.onChanged});

  @override
  _CheckboxListState createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(widget.items[index]['name']),
          value: widget.items[index]['isChecked'],
          onChanged: (bool? value) {
            setState(() {
              widget.items[index]['isChecked'] = value ?? false;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(index, value ?? false);
            }
          },
        );
      },
    );
  }
}
