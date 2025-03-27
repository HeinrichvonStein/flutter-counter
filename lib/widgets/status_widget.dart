import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_counter/util/powersync.dart';
import 'package:powersync/powersync.dart' show SyncStatus;

class StatusWidget extends StatefulWidget {
  /// A widget that displays the current powersync sync status.
  const StatusWidget({super.key});

  @override
  State<StatusWidget> createState() => _StatusWidgetState();
}

class _StatusWidgetState extends State<StatusWidget> {
  /// The current connection state.
  late SyncStatus _connectionState;

  /// The subscription to the sync status stream.
  StreamSubscription<SyncStatus>? _syncStatusSubscription;

  @override
  void initState() {
    super.initState();
    _connectionState = db.currentStatus;

    /// Listen to the sync status stream and update the UI.
    _syncStatusSubscription = db.statusStream.listen((event) {
      setState(() {
        _connectionState = db.currentStatus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _syncStatusSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildInfoRow(title: 'Connected', content: _connectionState.connected),
          _buildInfoRow(title: 'Downloading', content: _connectionState.downloading),
          _buildInfoRow(title: 'Uploading', content: _connectionState.uploading),
          _buildInfoRow(title: 'LastSyncedAt', content: _connectionState.lastSyncedAt),
        ],
      ),
    );
  }

  /// Builds a row with the powersync status title and connection state.
  Row _buildInfoRow({required String title, required Object? content}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _getStatusIcon(_connectionState),
        Text('$title: $content', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: 5),
      ],
    );
  }
}

Widget _makeIcon(String text, IconData icon) {
  return Tooltip(
    message: text,
    child: SizedBox(width: 40, height: null, child: Icon(icon, size: 24)),
  );
}

Widget _getStatusIcon(SyncStatus status) {
  if (status.anyError != null) {
    // The error message is verbose, could be replaced with something
    // more user-friendly
    if (!status.connected) {
      return _makeIcon(status.anyError!.toString(), Icons.cloud_off);
    } else {
      return _makeIcon(status.anyError!.toString(), Icons.sync_problem);
    }
  } else if (status.connecting) {
    return _makeIcon('Connecting', Icons.cloud_sync_outlined);
  } else if (!status.connected) {
    return _makeIcon('Not connected', Icons.cloud_off);
  } else if (status.uploading && status.downloading) {
    // The status changes often between downloading, uploading and both,
    // so we use the same icon for all three
    return _makeIcon('Uploading and downloading', Icons.cloud_sync_outlined);
  } else if (status.uploading) {
    return _makeIcon('Uploading', Icons.cloud_sync_outlined);
  } else if (status.downloading) {
    return _makeIcon('Downloading', Icons.cloud_sync_outlined);
  } else {
    return _makeIcon('Connected', Icons.cloud_queue);
  }
}
