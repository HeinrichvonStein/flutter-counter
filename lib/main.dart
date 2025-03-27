import 'package:flutter/material.dart';
import 'package:flutter_counter/app_config.dart';
import 'package:flutter_counter/screens/counter_screen.dart';
import 'package:flutter_counter/screens/login_screen.dart';
import 'package:flutter_counter/util/powersync.dart';
import 'package:flutter_counter/util/supabase_backend_connector.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializes Supabase with the URL and anonymous key.
  await Supabase.initialize(url: AppConfig.supabaseUrl, anonKey: AppConfig.supabaseAnonKey);

  await openDatabase();
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
    return MaterialApp(
      title: 'Flutter Counter',
      theme: theme,
      home: StreamBuilder(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (ctx, snapshot) {
          /// If the connection is still waiting, show a loading spinner.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          /// If the user is signed in, show the counter screen.
          if (snapshot.hasData && snapshot.data!.event == AuthChangeEvent.signedIn) {
            db.connect(connector: SupabaseBackendConnector());
            return const CounterScreen();
          }
          db.disconnect();
          return const LoginScreen();
        },
      ),
    );
  }
}
