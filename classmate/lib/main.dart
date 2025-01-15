import 'package:flutter/material.dart';
import 'screens/course_screen.dart';
import 'services/chatbot_service.dart';
import 'screens/index_screen.dart';
import 'screens/courses_view_screen.dart';

void main() {
  final chatbotService = ChatbotService(apiKey: 'insert api key here');

  runApp(SmartTeachingApp(chatbotService: chatbotService));
}

class SmartTeachingApp extends StatelessWidget {
  final ChatbotService chatbotService;

  const SmartTeachingApp({Key? key, required this.chatbotService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClassMate',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => IndexScreen(),
        '/courses': (context) => CourseScreen(chatbotService: chatbotService),
        '/course_view': (context) => CoursesView(),
      },
    );
  }
}
