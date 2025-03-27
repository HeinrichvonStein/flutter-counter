import 'package:flutter_counter/app_config.dart';
import 'package:logging/logging.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
final logger = Logger('powersync-supabase');

/// Postgres Response codes that we cannot recover from by retrying.
final List<RegExp> fatalResponseCodes = [
  // Class 22 — Data Exception
  // Examples include data type mismatch.
  RegExp(r'^22...$'),
  // Class 23 — Integrity Constraint Violation.
  // Examples include NOT NULL, FOREIGN KEY and UNIQUE violations.
  RegExp(r'^23...$'),
  // INSUFFICIENT PRIVILEGE - typically a row-level security violation
  RegExp(r'^42501$'),
];

class SupabaseBackendConnector extends PowerSyncBackendConnector {
  SupabaseBackendConnector();

  /// Get a Supabase token to authenticate against the PowerSync instance.
  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    /// Get the current session.
    final session = supabase.auth.currentSession;

    /// If the session is null, the user is not logged in.
    if (session == null) {
      return null;
    }
    return PowerSyncCredentials(
      endpoint: AppConfig.powersyncUrl,
      token: session.accessToken,
      userId: session.user.id,
    );
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    /// Get the next transaction to upload.
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) {
      return;
    }
    try {
      /// Iterate over each operation in the transaction.
      for (var op in transaction.crud) {
        /// Get the table to update.
        final table = supabase.from(op.table);

        /// Perform the operation.
        switch (op.op) {
          /// Insert a new record.
          case UpdateType.put:
            await table.upsert(op.opData!);

          /// Update an existing record.
          case UpdateType.patch:
            await table.update(op.opData!).eq('id', op.id);

          /// Delete a record.
          case UpdateType.delete:
            await table.delete().eq('id', op.id);
        }
      }
      await transaction.complete();
    } on Exception catch (error) {
      if (error is PostgrestException) {
        if (error.code != null && fatalResponseCodes.any((re) => re.hasMatch(error.code!))) {
          logger.severe('Data upload error - discarding', error);
          await transaction.complete();
        } else {
          logger.severe(error);
        }
      }
    }
  }
}
