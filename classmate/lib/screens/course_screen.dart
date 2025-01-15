import 'package:flutter/material.dart';
import 'package:classmate/screens/quiz_screen.dart';
import 'package:classmate/services/chatbot_service.dart';
import 'package:classmate/widgets/navbar.dart';

class CourseScreen extends StatelessWidget {
  final ChatbotService chatbotService;

  const CourseScreen({Key? key, required this.chatbotService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const Navbar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Course: Systems Engineering',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This course will teach you the basics of Systems Engineering methods. '
              'Complete the assignment below to test your understanding.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
             ListTile(
              title: const Text('Quiz - SysML Diagrams'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizScreen(chatbotService: chatbotService),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
