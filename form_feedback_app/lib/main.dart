import 'package:flutter/material.dart';
import 'feedback_form_page.dart';

void main() {
  runApp(const FormFeedbackApp());
}

class FormFeedbackApp extends StatelessWidget {
  const FormFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Feedback App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 44, 155, 189),
          primary: const Color.fromARGB(255, 71, 150, 240),
        ),
        useMaterial3: true,
      ),
      home: const FeedbackFormPage(),
    );
  }
}
