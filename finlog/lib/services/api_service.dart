import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class ApiService {
  Future<QuoteModel> fetchDailyQuote() async {
    try {
      final response = await http.get(
        Uri.parse('https://zenquotes.io/api/random'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return QuoteModel.fromJson(data[0]);
        }
      }
      
      // Fallback quote jika API gagal
      return QuoteModel(
        text: "Take care of your finances, and they will take care of you.",
        author: "Anonymous",
      );
    } catch (e) {
      // Fallback quote jika terjadi error
      return QuoteModel(
        text: "Financial freedom is available to those who learn about it and work for it.",
        author: "Robert Kiyosaki",
      );
    }
  }
}