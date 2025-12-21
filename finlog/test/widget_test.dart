import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:finlog/providers/auth_provider.dart';
import 'package:finlog/screens/login_screen.dart';
// removed unused import

void main() {
  testWidgets(
    'LoginScreen menampilkan semua elemen UI',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verifikasi elemen UI ada
      expect(find.text('Login FinLog'), findsOneWidget); // AppBar
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget); // Logo
      expect(find.text('Email'), findsOneWidget); // Label email
      expect(find.text('Password'), findsOneWidget); // Label password
      expect(find.widgetWithText(ElevatedButton, 'MASUK'), findsOneWidget); // Tombol
    },
  );

  testWidgets(
    'Form validasi email kosong',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Kosongkan semua field dan tekan tombol
      await tester.tap(find.widgetWithText(ElevatedButton, 'MASUK'));
      await tester.pump();

      expect(find.text('Email tidak boleh kosong'), findsOneWidget);
    },
  );

  testWidgets(
    'Form validasi password minimal 6 karakter',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Input email valid
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@email.com',
      );

      // Input password kurang dari 6 karakter
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '12345',
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'MASUK'));
      await tester.pump();

      expect(find.text('Password minimal 6 karakter'), findsOneWidget);
    },
  );

  testWidgets(
    'Login berhasil dengan input valid',
    (WidgetTester tester) async {
      final authProvider = AuthProvider();
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: authProvider),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Input data valid
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'admin@finlog.com',
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '123456',
      );

      // Tekan tombol login
      await tester.tap(find.widgetWithText(ElevatedButton, 'MASUK'));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'Loading indicator muncul saat proses login',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Input data
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@email.com',
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Tekan tombol (akan muncul loading)
      await tester.tap(find.widgetWithText(ElevatedButton, 'MASUK'));
      await tester.pump();

      // Loading indicator mungkin muncul tergantung implementasi
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}