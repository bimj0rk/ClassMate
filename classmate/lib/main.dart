import 'package:flutter/material.dart';
import 'screens/course_screen.dart';
import 'screens/quiz_screen.dart';
import 'services/chatbot_service.dart';

void main() {
  final chatbotService = ChatbotService(apiKey: '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');


  runApp(SmartTeachingApp(chatbotService: chatbotService));
}

class SmartTeachingApp extends StatelessWidget {
  final ChatbotService chatbotService;

  const SmartTeachingApp({Key? key, required this.chatbotService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Teaching App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CourseScreen(chatbotService: chatbotService), // Start with Course Page
    );
  }
}
