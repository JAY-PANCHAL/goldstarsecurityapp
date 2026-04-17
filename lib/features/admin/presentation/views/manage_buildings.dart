import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/features/admin/data/datasources/admin_local_datasource.dart';

class ManageBuildings extends StatefulWidget {
  const ManageBuildings({super.key});

  @override
  State<ManageBuildings> createState() => _ManageBuildingsState();
}

class _ManageBuildingsState extends State<ManageBuildings> {
  final AdminLocalDatasource _ds = AdminLocalDatasource();
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    items = await _ds.getBuildings();
    setState(() {});
  }

  Future<void> _add() async {
    final code = TextEditingController();
    final name = TextEditingController();
    final address = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Building'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: code,
              decoration: const InputDecoration(labelText: 'Code'),
            ),
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: address,
              decoration: const InputDecoration(labelText: 'Address'),
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
              await _ds.addBuilding({
                'code': code.text,
                'name': name.text,
                'address': address.text,
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
      appBar: AppBar(title: const Text('Buildings')),
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
                item['address'] ?? '',
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
