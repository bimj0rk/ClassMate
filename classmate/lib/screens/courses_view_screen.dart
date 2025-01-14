import 'package:flutter/material.dart';
import '../widgets/navbar.dart';

class CoursesView extends StatelessWidget {
  const CoursesView({Key? key}) : super(key: key);

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
              'Courses',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Course #1 - Flutter Basics'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => Navigator.pushNamed(context, '/courses'),
            ),
          ],
        ),
      ),
    );
  }
}