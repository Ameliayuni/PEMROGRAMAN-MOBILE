import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_campus_feedback/main.dart';

void main() {
  testWidgets('App should load HomePage correctly', (WidgetTester tester) async {
    // Build aplikasi
    await tester.pumpWidget(const MyApp());

    // Pastikan judul utama muncul
    expect(find.text('Campus Feedback'), findsOneWidget);
  });
}
