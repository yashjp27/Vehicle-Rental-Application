import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle/main.dart'; // Replace with your actual app import

void main() {
  testWidgets('Navigate to Vehicle Search Page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp()); // Replace with your app name

    // Tap the "Search for Vehicles" button.
    await tester.tap(find.text('Search for Vehicles'));
    await tester.pump();

    // Expect that we have navigated to the VehicleSearchPage.
    expect(find.text('Vehicle Search'), findsOneWidget);
  });

  testWidgets('Navigate to Trending Vehicles Page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp()); // Replace with your app name

    // Tap the "Trending Vehicles" button.
    await tester.tap(find.text('Trending Vehicles'));
    await tester.pump();

    // Expect that we have navigated to the TrendingVehiclesPage.
    expect(find.text('Trending Vehicles'), findsOneWidget);
  });

  testWidgets('Navigate to Login Page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp()); // Replace with your app name

    // Tap the "Login" button.
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Expect that we have navigated to the LoginPage.
    expect(find.text('Login'), findsOneWidget);
  });

  // Add more widget tests as needed for specific UI and functionality.
}
