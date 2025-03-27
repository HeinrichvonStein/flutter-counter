import 'package:powersync/powersync.dart';

Schema schema = Schema(([
  Table(
    'counter',
    [Column.text('counter_id'), Column.text('counter'), Column.text('username')],
    indexes: [
      Index('counter', [IndexedColumn('counter_id')]),
    ],
  ),
]));
