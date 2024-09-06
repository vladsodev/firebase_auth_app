import 'package:firebase_auth_app/core/common/error_text.dart';
import 'package:firebase_auth_app/core/common/loader.dart';
import 'package:firebase_auth_app/features/auth/controller/auth_controller.dart';
import 'package:firebase_auth_app/utils/logparsing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {

  DateTime startDateTime = DateTime.now().subtract(const Duration(days: 3));
  DateTime endDateTime = DateTime.now();
  int counter = 0;

  List<String> regexList = [
    'Not selected',
    r'\badmin\b',
    r'\bsigned in\b',
    r'\bsigned out\b',
    r'\bpassword\b',
    r'\bregistered\b',
    r'\berror\b',
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
    final logList = ref.watch(logsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
      ),
      body: SafeArea(
        child: logList.when(
          data: (logList) {
            List<Map<DateTime, String>> logMaps = logList.map((log) {
              return {log.timeStamp!.toDate(): log.message!};
            }).toList();
            
            List<Map<DateTime, String>> sortedLogs = filterByDateTime(logMaps, startDateTime, endDateTime);

            String logString = '';

            for (Map<DateTime, String> log in sortedLogs) {
              logString += log.keys.first.toString();
              logString += '\n';
              logString += log.values.first;
              logString += '\n';
            }
            matchesCounter(logString, RegExp(dropDownValue));
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
                const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    const Divider()
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

          }, 
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()
        )
      ),
    );
  }
}