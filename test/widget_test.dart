import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradersplayground/main.dart'; // Ensure correct import

void main() {
  testWidgets('App launches and displays login screen', (WidgetTester tester) async {
    // Build the TRADERSPLAYGROUNDand trigger a frame.
   await tester.pumpWidget(TRADERSPLAYGROUND());


    // Verify the presence of login-related elements.
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2)); // Username & Password fields
    expect(find.byType(ElevatedButton), findsOneWidget); // Login button

    // Try tapping the login button.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    
    // Check for validation messages (if required).
  });
}
