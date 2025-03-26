import 'package:flutter/material.dart';
import 'package:flutter_counter/widgets/counter_table_widget.dart';
import 'package:flutter_counter/widgets/counter_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CounterScreen extends StatelessWidget {
  /// A screen that displays a counter widget.
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(80),
        leading: SvgPicture.asset('assets/images/powersync-logo-icon.svg'),
        title: Text('Counter App', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          IconButton(
            onPressed: () => Supabase.instance.client.auth.signOut(),
            icon: Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.primaryContainer),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primaryContainer, theme.colorScheme.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [CounterWidget(), const SizedBox(height: 20), CounterTableWidget()],
        ),
      ),
    );
  }
}
