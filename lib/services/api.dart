import 'dart:convert'; // Для работы с JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> sendApiLog(String message) async {
  const String baseUrl = "http://192.168.11.142:3000/api/create-log";

  try {
    // Тело запроса
    final Map<String, String> body = {'message': message};

    // Отправка POST-запроса
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    // Проверяем ответ от сервера
    if (response.statusCode == 200) {
      debugPrint('Лог успешно отправлен: ${response.body}');
    } else {
      debugPrint('Ошибка: ${response.statusCode}, ${response.body}');
    }
  } catch (e) {
    debugPrint('Ошибка подключения: $e');
  }
}
