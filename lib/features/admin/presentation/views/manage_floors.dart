import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/features/admin/data/datasources/admin_local_datasource.dart';

class ManageFloors extends StatefulWidget {
  const ManageFloors({super.key});

  @override
  State<ManageFloors> createState() => _ManageFloorsState();
}

class _ManageFloorsState extends State<ManageFloors> {
  final AdminLocalDatasource _ds = AdminLocalDatasource();
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    items = await _ds.getFloors();
    setState(() {});
  }

  Future<void> _add() async {
    final code = TextEditingController();
    final buildingCode = TextEditingController();
    final name = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Floor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: code,
              decoration: const InputDecoration(labelText: 'Code'),
            ),
            TextField(
              controller: buildingCode,
              decoration: const InputDecoration(labelText: 'Building Code'),
            ),
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Name'),
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
              await _ds.addFloor({
                'code': code.text,
                'buildingCode': buildingCode.text,
                'name': name.text,
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
      appBar: AppBar(title: const Text('Floors')),
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
                'Building: ${item['buildingCode'] ?? ''}',
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
