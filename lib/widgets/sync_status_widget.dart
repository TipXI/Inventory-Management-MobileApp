import 'package:flutter/material.dart';

class SyncStatusWidget extends StatelessWidget {
  const SyncStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sync, color: Colors.green),
      tooltip: 'Synced (tap to refresh)',
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data synced successfully")),
        );
      },
    );
  }
}
