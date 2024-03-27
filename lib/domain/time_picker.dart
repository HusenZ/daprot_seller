import 'package:flutter/material.dart';

Future<String?> showCustomTimePicker(
  BuildContext context,
) async {
  final selectedTime = await showTimePicker(
    context: context,
    initialTime: const TimeOfDay(hour: 12, minute: 00),
  );
  if (selectedTime != null) {
    return selectedTime.format(context);
  }
  return null;
}
