import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';



Future<String> importTextFromFile() async {
  try {
    // Открытие диалогового окна для выбора файла
    var filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    // Проверка, был ли выбран файл
    if (filePickerResult != null) {
      var filePath = filePickerResult.files.single.path!;
      var file = File(filePath); // Создаем объект File с указанным путем
      var fileContent = await file.readAsString(); // Читаем содержимое файла
      return fileContent;
    }
    else {
      return '';
    }
  } catch (e) {
    //print('Ошибка импорта файла: $e');
    return '';
  }
}

class RegexText extends StatelessWidget {
  final String text;
  final RegExp regex;

  const RegexText({
    super.key, 
    required this.text, 
    required this.regex
    });

  @override
  Widget build(BuildContext context) {
    // Ищем все совпадения в тексте
    Iterable<Match> matches = regex.allMatches(text);

    // Создаем список TextSpan, в котором каждое совпадение будет иметь специальный стиль
    List<TextSpan> textSpans = [];

    int lastMatchEnd = 0; // Переменная для отслеживания конца предыдущего совпадения

    for (Match match in matches) {
      // Добавляем текст до совпадения
      if (match.start > lastMatchEnd) {
        textSpans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: const TextStyle(color: Colors.black),
          ),
        );
      }

      // Добавляем совпадение с выделением стиля
      textSpans.add(
        TextSpan(
          text: match.group(0)!,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      lastMatchEnd = match.end;
    }

    // Добавляем оставшийся текст после последнего совпадения
    if (lastMatchEnd < text.length) {
      textSpans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: const TextStyle(color: Colors.black),
        ),
      );
    }

    // Создаем RichText с сформированными TextSpan
    return RichText(
      text: TextSpan(
        children: textSpans,
      ),
    );
  }
}


class RegexApp extends StatefulWidget {
  const RegexApp({super.key});

  @override
  State<RegexApp> createState() => _RegexAppState();
}

class _RegexAppState extends State<RegexApp> {

  TextEditingController controller = TextEditingController();

  String text = '';
  List<String> regexList = [
    r'\bdonuts\b',
    r'\bcake\b',
    r'\bapple\b',
  ];
  
  late List<DropdownMenuItem<String>> items;
  late String dropDownValue;

  @override
  void initState() {
    super.initState();
    items = regexList.map((regex) {
      return DropdownMenuItem<String>(
        value: regex,
        child: Text(regex),
      );
    }).toList();
    dropDownValue = regexList[0];
  }

  

  void onChanged(String? newValue) {
    setState(() {
      dropDownValue = newValue ?? '';
    });
  }


  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regex Page'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      String res = await importTextFromFile();
                      setState(() {
                        text = res;
                      });
                    }, 
                    child: const Text('Insert from txt')
                  ),
                  DropdownButton<String>(
                    value: dropDownValue,
                    items: items,
                    onChanged: onChanged,
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: controller,
                onChanged: (value) {
                  setState(() {
                    text = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Enter text',
                ),
              ),
              const SizedBox(height: 20,),
              RegexText(text: text, regex: RegExp(dropDownValue))
            ],
          ),
        ),
      )
    );
  }
}



// Использование
// void main() {
//   runApp(
//     const MaterialApp(
//       home: RegexApp(),
//     ),
//   );
// }

// List<TextSpan> highlightMatches(String text, RegExp regex) {
//   // Ищем все совпадения в тексте
//     Iterable<Match> matches = regex.allMatches(text);

    

//     // Создаем список TextSpan, в котором каждое совпадение будет иметь специальный стиль
//     List<TextSpan> textSpans = [];

//     int lastMatchEnd = 0; // Переменная для отслеживания конца предыдущего совпадения

//     for (Match match in matches) {
//       // Добавляем текст до совпадения
//       if (match.start > lastMatchEnd) {
//         textSpans.add(
//           TextSpan(
//             text: text.substring(lastMatchEnd, match.start),
//             style: const TextStyle(color: Colors.black),
//           ),
//         );
//       }

//       // Добавляем совпадение с выделением стиля
//       textSpans.add(
//         TextSpan(
//           text: match.group(0)!,
//           style: const TextStyle(
//             color: Colors.red,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       );

//       lastMatchEnd = match.end;
//     }

//     // Добавляем оставшийся текст после последнего совпадения
//     if (lastMatchEnd < text.length) {
//       textSpans.add(
//         TextSpan(
//           text: text.substring(lastMatchEnd),
//           style: const TextStyle(color: Colors.black),
//         ),
//       );
//     }
//     return textSpans;
// }