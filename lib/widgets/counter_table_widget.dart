import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/counter.dart';

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

  /// The realtime channel for counter updates.
  late RealtimeChannel _counterChannel;

  /// A flag to indicate if the widget is loading data.
  bool _isLoading = true;

  /// A flag to indicate if the widget is subscribed to realtime updates.
  bool _subscribed = false;

  @override
  void initState() {
    super.initState();
    _loadCounters();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  /// Loads the counters from the database.
  Future<void> _loadCounters() async {
    final response = await Supabase.instance.client
        .from('counter')
        .select('username, counter')
        .order('counter', ascending: false);

    final data = response as List<dynamic>;

    setState(() {
      _counters = data.map((json) => Counter.fromJson(json)).toList();
      _isLoading = false;
    });
  }

  /// Subscribes to realtime updates for the counter table.
  void _subscribeToCounterChanges() {
    _counterChannel =
        Supabase.instance.client
            .channel('public:counter')
            .onPostgresChanges(
              event: PostgresChangeEvent.update,
              schema: 'public',
              table: 'counter',
              callback: (payload) {
                print('Realtime update received: $payload');
                _loadCounters();
              },
            )
            .subscribe();

    setState(() {
      _subscribed = true;
    });
    _showMessage('Subscribed to counter updates.');
  }

  /// Shows a message to the user.
  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), showCloseIcon: true, duration: const Duration(seconds: 2)),
    );
  }

  /// Unsubscribes from realtime updates for the counter table.
  void _unsubscribe() {
    if (_subscribed) {
      Supabase.instance.client.removeChannel(_counterChannel);
      setState(() {
        _subscribed = false;
      });
      _showMessage('Unsubscribed to counter updates.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // if (_isLoading) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _subscribed ? _unsubscribe : _subscribeToCounterChanges,
          icon: Icon(_subscribed ? Icons.unsubscribe_outlined : Icons.unsubscribe),
          label: Text(_subscribed ? 'Unsubscribe from Updates' : 'Subscribe to Updates'),
        ),
        const SizedBox(height: 10),
        _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
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
                              DataCell(
                                Text(counter.username, style: const TextStyle(color: Colors.white)),
                              ),
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
            ),
      ],
    );
  }
}
