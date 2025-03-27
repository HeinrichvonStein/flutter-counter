import 'package:powersync/powersync.dart';

/// The schema for the counter table.
/// - [counter] is the counter value.
/// - [username] is the username of the user.
/// - [user_id] is the user id of the user.
Schema schema = Schema(([
  Table('counter', [Column.integer('counter'), Column.text('username'), Column.text('user_id')]),
]));
