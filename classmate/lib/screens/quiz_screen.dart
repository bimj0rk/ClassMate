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
      'question': 'What are the types of Behaviour Diagrams?',
      'correctAnswer': 'Activty Diagram, State Diagram, Sequence Diagram, Use Case Diagram',
    },
    {
      'question': 'What are the types of Dependencies used for Package Diagrams?',
      'correctAnswer': 'Use, Refine, Allocate, Trace',
    },
    {
      'question': 'What are the types of Requirement Relationships?',
      'correctAnswer': 'Derive, Satisfy, Verify, Refine, Copy, Trace',
    },
  ];

  final Map<int, String> studentAnswers = {};

  String feedback = '';
  bool isLoading = false;

  Future<void> submitQuiz() async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, String?>> quizData = [];
    for (int i = 0; i < quizQuestions.length; i++) {
      quizData.add({
        'question': quizQuestions[i]['question'],
        'studentAnswer': studentAnswers[i],
        'correctAnswer': quizQuestions[i]['correctAnswer'],
      });
    }

    String courseMaterial = await widget.chatbotService.extractTextFromPdf('course_material.pdf');

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
                    'Assignment: Quiz on SysML Diagrams',
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
