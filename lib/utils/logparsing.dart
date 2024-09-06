import 'package:flutter/material.dart';

List<TextSpan> highlightMatches(String text, RegExp regex) {
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
    return textSpans;
}