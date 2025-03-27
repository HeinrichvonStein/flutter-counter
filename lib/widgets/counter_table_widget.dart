import 'dart:async';

import 'package:flutter/material.dart';

import '../models/counter.dart';
import '../util/powersync.dart';

class CounterTableWidget extends StatefulWidget {
  /// A widget that displays a table of users and their counters.
  ///
  /// This widget also allows users to subscribe or unsubscribe to realtime updates.
  const CounterTableWidget({super.key});

  @override
  State<CounterTableWidget> createState() => _CounterTableWidgetState();
}

class _CounterTableWidgetState extends State<CounterTableWidget> {
  /// The list of counters to display.
  List<Counter> _counters = [];

  /// The subscription to the counter table.
  StreamSubscription? _counterSub;

  @override
  void initState() {
    super.initState();

    /// Watch the counter table for changes
    final stream = db
        .watch('SELECT counter, username FROM counter ORDER BY counter DESC')
        .map(
          (rs) =>
              rs
                  .map((row) => Counter(counter: row['counter'] as int, username: row['username']))
                  .toList(),
        );

    /// Listen to the stream and update counters state.
    _counterSub = stream.listen((counters) {
      /// Check if the widget is still mounted before updating the state
      if (!context.mounted) {
        return;
      }
      setState(() {
        _counters = counters;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    /// Cancel the subscription when the widget is disposed
    _counterSub?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: 1,
        sortAscending: false,
        columns: [
          DataColumn(
            label: Text(
              'Username',
              style: theme.textTheme.titleMedium!.copyWith(color: Colors.yellow),
            ),
          ),
          DataColumn(
            label: Text(
              'Counter',
              style: theme.textTheme.titleMedium!.copyWith(color: Colors.yellow),
            ),
            numeric: true,
          ),
        ],
        rows:
            _counters
                .map(
                  (counter) => DataRow(
                    cells: [
                      DataCell(Text(counter.username, style: const TextStyle(color: Colors.white))),
                      DataCell(
                        Text(
                          counter.counter.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}
