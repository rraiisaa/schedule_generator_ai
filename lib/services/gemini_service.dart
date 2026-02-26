import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schedule_generator_ai/models/task.dart';

// jembatan antar penghubung client dan server
class GeminiService {
  static const String _baseURL = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent";
  final String apiKey;

  // ini API KEY yang diambil dari file .env
  // ini buat ngecek apakah API KEY sudah di input atau belum
  // jika belum, maka akan muncul error
  GeminiService() : apiKey = dotenv.env["GEMINI_API_KEY"] ?? "Please input your API KEY" {
    if (apiKey.isEmpty) {
      throw ArgumentError("API KEY is missing");
    }
  }
  
  // ini buat generate jadwal harian berdasarkan task yang sudah di input
  Future<String> generateSchedule(List<Task> tasks) async {
    _validateTasks(tasks);
    final prompt = _buildPrompt(tasks);
    try {
      // ini nanti akan muncul di debug console
      print("Prompt: \n$prompt");
      // tambah request time-out biar API nya ga crash dan ga nunggu loading kelamaan
      final response = await http
          .post(Uri.parse("$_baseURL?key=$apiKey"), headers: {
            "Content-Type": "application/json",
          },
           body: jsonEncode({
            "contents":[
              {
                "role": "user",
                "parts": [
                  {"text": prompt}
                ]
              }
            ]
          })
          // ini time out biar requestnya gak kelamaan
          ).timeout(Duration(seconds: 20));
          return _handleResponse(response);
      // sebuah code yg letak nya setelah await itu hasil yg akan di generate setelah proses async selesai.
    } catch (e) {
     throw ArgumentError("An error occurred while generating the schedule: $e"); 
    }
  }

  String _handleResponse(http.Response responses) {
    // buat ngubah kode JSON jadi format yang bisa dibaca sama dart
    final data = jsonDecode(responses.body);
    // 401 = itu format error yang artinya API Key nya salah atau tidak valid
    if (responses.statusCode == 401) {
      throw ArgumentError("Invalid API Key or Unorthorized access");
    // 429 = itu format buat too many request (limit abis/token abis)
    } else if (responses.statusCode == 429) {
      throw ArgumentError("Too many requests or token limit exceeded");
    // 500 = ini format buat internal server error (servernya lagi down atau ada masalah)
    } else if (responses.statusCode == 500) {
      throw ArgumentError("Internal server error, please try again later");
    // 503 = servernya biasanya lagi maintenance atau lagi down
    } else if (responses.statusCode == 503) {
      throw ArgumentError("Service unavailable, please try again later");
    } else if (responses.statusCode == 200) {
      return data["candidates"][0]['content']['parts'][0]['text'];
      // ketika kondisinya ga spesifik. errornya diluar dari yang kita kasih
    } else {
      throw ArgumentError("Unknown error occurred");
    }
  }
  String _buildPrompt(List<Task> tasks) {
    final tasksList = tasks.map((task) => "${task.name} (Priority: ${task.priority}, Duration: ${task.duration}, Deadline: ${task.deadline})").join("\n");
    return "Buatkan jadwal harian yang optimal berdasarkan task berikut:\n$tasksList";
  }

  void _validateTasks(List<Task> tasks) {
    if (tasks.isEmpty) throw ArgumentError("Tasks cannot be empty. PLease insert ur prompt");
  }
}