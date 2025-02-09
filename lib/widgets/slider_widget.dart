import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final ValueChanged<double> onChanged;

  const SliderWidget({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: value.toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}