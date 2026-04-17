import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/features/admin/data/datasources/admin_local_datasource.dart';

class ManageCheckpoints extends StatefulWidget {
  const ManageCheckpoints({super.key});

  @override
  State<ManageCheckpoints> createState() => _ManageCheckpointsState();
}

class _ManageCheckpointsState extends State<ManageCheckpoints> {
  final AdminLocalDatasource _ds = AdminLocalDatasource();
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    items = await _ds.getCheckpoints();
    setState(() {});
  }

  Future<void> _add() async {
    final code = TextEditingController();
    final floorCode = TextEditingController();
    final name = TextEditingController();
    final qrCode = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Checkpoint'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: code,
              decoration: const InputDecoration(labelText: 'Code'),
            ),
            TextField(
              controller: floorCode,
              decoration: const InputDecoration(labelText: 'Floor Code'),
            ),
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: qrCode,
              decoration: const InputDecoration(labelText: 'QR Code'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _ds.addCheckpoint({
                'code': code.text,
                'floorCode': floorCode.text,
                'name': name.text,
                'qrCode': qrCode.text,
                'status': 'Active',
                'syncStatus': 'local',
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkpoints')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(
                item['name'] ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                item['qrCode'] ?? '',
                style: const TextStyle(color: Colors.white70),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        backgroundColor: AppColors.accentGold,
        child: const Icon(Icons.add, color: AppColors.textOnLight),
      ),
    );
  }
}
