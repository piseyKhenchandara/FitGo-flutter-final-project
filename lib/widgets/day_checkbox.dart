import 'package:flutter/material.dart';

class DayCheckbox extends StatelessWidget {
  const DayCheckbox({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onChanged,
  });

  final String day;
  final bool isSelected;
  final Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        day,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      value: isSelected,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      activeColor: Colors.black,
      checkColor: Colors.white,
    );
  }
}
