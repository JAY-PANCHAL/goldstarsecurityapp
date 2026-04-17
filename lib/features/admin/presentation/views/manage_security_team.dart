import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/features/admin/data/datasources/admin_local_datasource.dart';

class ManageSecurityTeam extends StatefulWidget {
  const ManageSecurityTeam({super.key});

  @override
  State<ManageSecurityTeam> createState() => _ManageSecurityTeamState();
}

class _ManageSecurityTeamState extends State<ManageSecurityTeam> {
  final AdminLocalDatasource _ds = AdminLocalDatasource();
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    items = await _ds.getSecurityTeam();
    setState(() {});
  }

  Future<void> _add() async {
    final code = TextEditingController();
    final name = TextEditingController();
    final mobile = TextEditingController();
    final role = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Team Member'),
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
              controller: mobile,
              decoration: const InputDecoration(labelText: 'Mobile'),
            ),
            TextField(
              controller: role,
              decoration: const InputDecoration(labelText: 'Role'),
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
              await _ds.addSecurityTeam({
                'code': code.text,
                'name': name.text,
                'mobile': mobile.text,
                'role': role.text,
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
      appBar: AppBar(title: const Text('Security Team')),
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
                item['mobile'] ?? '',
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
