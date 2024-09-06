// Filters logs based on startDateTime and endDateTime and returns a list of maps containing DateTime and String.
import 'package:flutter/material.dart';

List<Map<DateTime, String>> filterByDateTime(List<Map<DateTime, String>> logs, DateTime startDateTime, DateTime endDateTime) {
    return logs.where((log) => log.keys.first.isAfter(startDateTime) && log.keys.first.isBefore(endDateTime)).toList();
}

//

// void setTime(DateTime initialDate, List<Map<DateTime, String>> logMaps, BuildContext context) {
//   showDatePicker(
//                       context: context,
//                       initialDate: initialDate,
//                       firstDate: DateTime(2010),
//                       lastDate: DateTime(2030),
//                     ).then((newDate) {
//                       if (newDate != null) {
//                         showTimePicker(
//                           context: context,
//                           initialTime: TimeOfDay.fromDateTime(startDateTime),
//                         ).then((newTime) {
//                           if (newTime != null) {
//                             setState(() {
//                               initialDate = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
//                               sortedLogs = filterByDateTime(logMaps, startDateTime, endDateTime);
//                               debugPrint(sortedLogs.length.toString());
//                             });
//                           }
//                         });
// }

Future<void> _showDateTimePicker(BuildContext context, DateTime? initialDateTime, ValueChanged<DateTime?> onDateTimeSelected) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDateTime ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
  if (picked != null && picked != initialDateTime && context.mounted) {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
    );
    if (pickedTime != null) {
      onDateTimeSelected(DateTime.utc(
        picked.year,
        picked.month,
        picked.day,
        pickedTime.hour,
        pickedTime.minute,
      ));
    }
  }
}