import 'package:firebase_auth_app/models/log.dart';
import 'package:firebase_auth_app/services/encrypt_data.dart';
import 'package:firebase_auth_app/services/regexp.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ParseLogs extends StatefulWidget {
  const ParseLogs({super.key});

  @override
  State<ParseLogs> createState() => _ParseLogsState();
}

class _ParseLogsState extends State<ParseLogs> {

  DateTime startDateTime = DateTime.now().subtract(const Duration(days: 3));
  DateTime endDateTime = DateTime.now();
  int counter = 0;

  List<String> regexList = [
    'Not selected',
    r'\badmin@goodboy.com\b',
    r'\bsigned in\b',
    r'\bsigned out\b',
    r'\bpassword\b',
    r'\bregistered\b',
  ];
  late String dropDownValue;
  late List<DropdownMenuItem<String>> items;
  late List<DropdownMenuEntry<String>> menuItems;

  @override
  void initState() {
    super.initState();
    items = regexList.map((regex) {
      return DropdownMenuItem<String>(
        value: regex,
        child: Text(regex),
      );
    }).toList();
    menuItems = regexList.map((regex) {
      return DropdownMenuEntry<String>(
        value: regex,
        label: regex,
      );
    }).toList();
    dropDownValue = regexList[0];
  }

  void onChanged(String? newValue) {
    setState(() {
      dropDownValue = newValue ?? '';
    });
  }

  void matchesCounter(String logs, RegExp regex) {
    Iterable<Match> matches = regex.allMatches(logs);
    setState(() {
      counter = matches.length;
    });
  }

  List<Map<DateTime, String>> filterByDateTime(List<Map<DateTime, String>> logs, DateTime startDateTime, DateTime endDateTime) {
    return logs.where((log) => log.keys.first.isAfter(startDateTime) && log.keys.first.isBefore(endDateTime)).toList();
  }
  // это веротяно надо отсюда перенести в сервисы
  

  @override
  Widget build(BuildContext context) {

    debugPrint('Here starts widget build');

    final logs = Provider.of<List<Log>?>(context);

    if (logs != null) {

      final decryptedLogs = logs.map((log) => Log(
        timeStamp: log.timeStamp,
        message: cypher.decrypt(log.message!)
      )).toList();
      
      List<Map<DateTime, String>> logMaps = decryptedLogs.map((log) {
        return {log.timeStamp!.toDate(): log.message!};
      }).toList();

      //debugPrint('total logs: ${logMaps.length}');

      

      List<Map<DateTime, String>> sortedLogs = filterByDateTime(logMaps, startDateTime, endDateTime);

      //debugPrint('sorted logs: ${sortedLogs.toString()}');

      String logString = '';

      for (Map<DateTime, String> log in sortedLogs) {
        logString += log.keys.first.toString();
        logString += '\n';
        logString += log.values.first;
        logString += '\n';
      }

      //debugPrint(logString);
      matchesCounter(logString, RegExp(dropDownValue));
      //List<TextSpan> highlightList = highlightMatches(logString, RegExp(r'\badmin@goodboy.com\b'));

      //debugPrint(highlightList.length.toString());

      return SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      debugPrint('Here starts 1st date picker');
                      showDatePicker(
                        context: context,
                        initialDate: startDateTime,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2030),
                      ).then((newDate) {
                        if (newDate != null) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(startDateTime),
                          ).then((newTime) {
                            if (newTime != null) {
                              setState(() {
                                startDateTime = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
                                sortedLogs = filterByDateTime(logMaps, startDateTime, endDateTime);
                              });
                            }
                          });
                        }
                      });
                    },
                    label: const Text('Select start'),
                    icon: const Icon(Icons.calendar_today),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      debugPrint('Here starts 2nd date picker');
                      showDatePicker(
                        context: context,
                        initialDate: endDateTime,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2030),
                      ).then((newDate) {
                        if (newDate != null) {
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(endDateTime),
                          ).then((newTime) {
                            if (newTime != null) {
                              setState(() {
                                endDateTime = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
                                sortedLogs = filterByDateTime(logMaps, startDateTime, endDateTime);
                                //debugPrint(sortedLogs.toString());
                              });
                            }
                          });
                        }
                      });
                    }, 
                    label: const Text('Select end'),
                    icon: const Icon(Icons.calendar_month),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownMenu(
                  onSelected: (regex) {
                    setState(() {
                      dropDownValue = regex!;
                    });
                    //matchesCounter(logString, RegExp(dropDownValue));
                  },
                  dropdownMenuEntries: menuItems,
                  label: const Text('Select regex'),
                ),
                Text('Matches: $counter'),
              ],
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: sortedLogs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(sortedLogs[index].keys.first.toString()),
                    subtitle: RichText(text: TextSpan(
                      children: highlightMatches(sortedLogs[index].values.first, RegExp(dropDownValue))),
                    ),
                  );
                }
              ),
            )
          ],
        )
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}