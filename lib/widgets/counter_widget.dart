import 'package:flutter/material.dart';
import 'package:powersync/sqlite3.dart' show ResultSet;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../util/powersync.dart';
import 'counter_button_widget.dart';

class CounterWidget extends StatefulWidget {
  /// A widget that displays a counter and allows a user to increment, decrement or reset it.
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  /// The current value of the counter.
  var _counter = 0;
  final userId = Supabase.instance.client.auth.currentUser!.id;

  /// Updates the counter in the database.
  Future<void> _updateCounterInDB(int value) async {
    await db.execute('UPDATE counter set counter = ? WHERE user_id = ?', [_counter, userId]);
  }

  /// Retrieves the counter from the database.
  Future<int> getCounter() async {
    ResultSet results = await db.getAll('SELECT counter FROM counter WHERE user_id = ?', [userId]);
    return results.map((row) => row['counter'] as int).first;
  }

  @override
  void initState() {
    super.initState();

    /// Fetch the counter value from the database.
    /// If the user updated their counter and logged out, we want to initialize the counter to the last value.
    getCounter().then(
      (value) => setState(() {
        _counter = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          constraints: const BoxConstraints(maxWidth: 150),
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Counter', style: theme.textTheme.titleLarge),
              const SizedBox(width: 5),
              Text(_counter.toString(), style: theme.textTheme.titleLarge),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CounterButtonWidget(
              icon: Icons.arrow_upward,
              onPressed:
                  () => setState(() {
                    _counter++;
                    _updateCounterInDB(_counter);
                  }),
            ),
            const SizedBox(width: 5),
            CounterButtonWidget(
              icon: Icons.arrow_downward,
              onPressed:
                  () => setState(() {
                    if (_counter > 0) {
                      _counter--;
                      _updateCounterInDB(_counter);
                    }
                  }),
              increase: false,
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _counter = 0;
                  _updateCounterInDB(_counter);
                });
              },
              child: Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
