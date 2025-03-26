import 'package:flutter/material.dart';
import 'package:flutter_counter/screens/counter_screen.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 0, 213, 255),
  primary: const Color.fromARGB(255, 170, 0, 255),
  secondary: const Color.fromARGB(255, 0, 85, 255),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.onSurface,
  colorScheme: colorScheme,
);

/// Starts the Flutter Counter app.
void main() {
  runApp(const CounterApp());
}

/// The root widget of the Flutter Counter app.
///
/// Uses a [StatefulWidget] to manage the state of the application.
class CounterApp extends StatefulWidget {
  const CounterApp({super.key});

  @override
  State<CounterApp> createState() => _CounterAppState();
}

/// State class for [CounterApp], setting up the theme and home screen.
class _CounterAppState extends State<CounterApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Counter', theme: theme, home: const CounterScreen());
  }
}
