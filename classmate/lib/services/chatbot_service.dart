import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String apiKey;

  ChatbotService({required this.apiKey});

  Future<String> extractTextFromPdf(String pdfPath) async {
    try {
      final ByteData bytes = await rootBundle.load(pdfPath);
      final Uint8List pdfData = bytes.buffer.asUint8List();

      final PdfDocument document = PdfDocument(inputBytes: pdfData);

      final PdfTextExtractor textExtractor = PdfTextExtractor(document);
      final String extractedText = textExtractor.extractText();

      document.dispose();

      return extractedText.trim();
    } catch (e) {
      print('Error extracting text from PDF: $e');
      return 'Error: Unable to extract text from the course material.';
    }
  }

Future<String> fetchChatbotFeedback({
  required List<Map<String, String?>> quizAnswers,
  required String courseMaterial,
}) async {
  final List<Map<String, dynamic>> messages = [
    {
      "role": "system",
      "content": "You are an AI chatbot helping to grade quizzes and provide feedback."
    },
    {
      "role": "user",
      "content": _constructPrompt(quizAnswers, courseMaterial),
    }
  ];

  try {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': messages,
        'max_tokens': 500,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      print('Failed to fetch chatbot feedback: ${response.body}');
      return 'Error: Unable to get feedback from the chatbot.';
    }
  } catch (e) {
    print('Error communicating with the chatbot API: $e');
    return 'Error: Unable to fetch feedback from the chatbot.';
  }
}

  /// Constructs a detailed prompt for the chatbot
  String _constructPrompt(
    List<Map<String, String?>> quizAnswers,
    String courseMaterial,
  ) {
    return '''
You are grading quizzes. Below are the answers provided by the student, the correct answers, and the relevant course material.

Quiz Answers:
${quizAnswers.map((answer) => '''
Question: ${answer['question']}
Student Answer: ${answer['studentAnswer']}
Correct Answer: ${answer['correctAnswer']}
''').join('\n')}

Course Material:
$courseMaterial

Using this information, please provide:
1. A grade for the student based on their answers (partial grading is allowed).
2. Detailed feedback on each question, with references from the course material.
3. Recommendations for further study, including links to videos and articles.
''';
  }
}