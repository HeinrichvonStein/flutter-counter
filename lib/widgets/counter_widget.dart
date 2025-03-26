import 'package:flutter/material.dart';

import 'counter_button_widget.dart';

class CounterWidget extends StatefulWidget {
  /// A widget that displays a counter and allows a user to increment or decrement it.
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  /// The current value of the counter.
  var _counter = 0;

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
                  }),
            ),
            const SizedBox(width: 5),
            CounterButtonWidget(
              icon: Icons.arrow_downward,
              onPressed:
                  () => setState(() {
                    if (_counter > 0) {
                      _counter--;
                    }
                  }),
              increase: false,
            ),
            const SizedBox(width: 5),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _counter = 0;
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
