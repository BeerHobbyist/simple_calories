import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_key.dart'; // Import the API key from a separate file so that it can be hidden in gitignore

class CaloriesEstimatorModel extends ChangeNotifier {
  String _estimatedCaloriesText = '';
  final List<String> _estimatedCaloriesTextList = [];

  String get estimatedCaloriesText => _estimatedCaloriesText;
  List<String> get estimatedCaloriesTextList => _estimatedCaloriesTextList;

  final url = Uri.parse('https://api.openai.com/v1/chat/completions');

  Future<void> estimateCalories(String foodName) async {
    final Map<String, dynamic> bodyContent = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "user",
          "content":
              "The following phrase is a food I ate. I want you to give me approximate amount of calories I ate. Write only the number and nothing else.\nExample:\ninput: Pizza\noutput: 800 kcal\ninput: an omelette from 3 eggs and 3 sausages:\noutput: 1000 kcal\ninput: $foodName\noutput: "
        }
      ]
    };

    try {
      final response = await http.post(
        url,
        body: json.encode(bodyContent),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey'
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _estimatedCaloriesTextList.add(data['choices'][0]['message']['content']);
        notifyListeners();
      } else {
        debugPrint(
            'Failed to estimate calories. Status code: ${response.statusCode} with response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error making POST request: $e');
    }
  }
}
