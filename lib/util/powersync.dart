import 'package:flutter_counter/models/schema.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';

late PowerSyncDatabase db;

openDatabase() async {
  final dir = await getApplicationSupportDirectory();
  final path = join(dir.path, 'powersync-dart.db');

  db = PowerSyncDatabase(schema: schema, path: path);
  await db.initialize();
}
