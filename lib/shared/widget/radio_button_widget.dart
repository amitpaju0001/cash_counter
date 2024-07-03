import 'package:flutter/material.dart';

class RadioButtonWidget<T> extends StatelessWidget {
  const RadioButtonWidget({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    required this.value,
    required this.title,
  });

  final T selectedValue;
  final ValueChanged<T>? onChanged;
  final T value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: selectedValue,
          onChanged: onChanged != null
              ? (T? newValue) {
            if (newValue != null) {
              onChanged!(newValue);
            }
          }
              : null,
        ),
        Text(title),
      ],
    );
  }
}