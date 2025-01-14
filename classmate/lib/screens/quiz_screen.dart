import 'package:flutter/material.dart';
import 'package:classmate/services/chatbot_service.dart';
import 'package:classmate/widgets/navbar.dart';

class QuizScreen extends StatefulWidget {
  final ChatbotService chatbotService;

  const QuizScreen({Key? key, required this.chatbotService}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizScreen> {
  final List<Map<String, String>> quizQuestions = [
    {
      'question': 'What is Flutter?',
      'correctAnswer': 'A UI toolkit for building natively compiled apps.',
    },
    {
      'question': 'What is Dart?',
      'correctAnswer': 'A programming language optimized for building fast apps.',
    },
  ];

  final Map<int, String> studentAnswers = {};

  String feedback = '';
  bool isLoading = false;

  /// Submits the quiz and gets feedback from the chatbot
  Future<void> submitQuiz() async {
    setState(() {
      isLoading = true;
    });

    // Prepare quiz data
    List<Map<String, String?>> quizData = [];
    for (int i = 0; i < quizQuestions.length; i++) {
      quizData.add({
        'question': quizQuestions[i]['question'],
        'studentAnswer': studentAnswers[i],
        'correctAnswer': quizQuestions[i]['correctAnswer'],
      });
    }

    // Extract course material
    String courseMaterial = await widget.chatbotService.extractTextFromPdf('course_material.pdf');

    // Fetch chatbot feedback
    String chatbotResponse = await widget.chatbotService.fetchChatbotFeedback(
      quizAnswers: quizData,
      courseMaterial: courseMaterial,
    );

    setState(() {
      feedback = chatbotResponse;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Assignment: Quiz on Flutter Basics',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: quizQuestions.length,
                      itemBuilder: (context, index) {
                        final question = quizQuestions[index]['question']!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Q${index + 1}: $question', style: const TextStyle(fontSize: 16)),
                            TextField(
                              onChanged: (value) {
                                studentAnswers[index] = value;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Your answer',
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: submitQuiz,
                    child: const Text('Submit Quiz'),
                  ),
                  const SizedBox(height: 16),
                  if (feedback.isNotEmpty)
                    Text(
                      'Feedback:\n$feedback',
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                ],
              ),
            ),
    );
  }
}
