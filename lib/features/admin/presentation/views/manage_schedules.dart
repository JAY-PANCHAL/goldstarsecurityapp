import 'package:flutter/material.dart';
import 'package:golstarsecurityapplatest/app/themes/app_colors.dart';
import 'package:golstarsecurityapplatest/features/admin/data/datasources/admin_local_datasource.dart';
import 'package:intl/intl.dart';

class ManageSchedules extends StatefulWidget {
  const ManageSchedules({super.key});

  @override
  State<ManageSchedules> createState() => _ManageSchedulesState();
}

class _ManageSchedulesState extends State<ManageSchedules> {
  final AdminLocalDatasource _ds = AdminLocalDatasource();
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    items = await _ds.getSchedules();
    setState(() {});
  }

  Future<void> _add() async {
    final code = TextEditingController();
    final buildingCode = TextEditingController();
    final buildingName = TextEditingController();
    final floorCode = TextEditingController();
    final floorName = TextEditingController();
    final date = TextEditingController();
    final time = TextEditingController();
    final cpCount = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Schedule'),
        content: SingleChildScrollView(
          child: Column(
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
                controller: buildingName,
                decoration: const InputDecoration(labelText: 'Building Name'),
              ),
              TextField(
                controller: floorCode,
                decoration: const InputDecoration(labelText: 'Floor Code'),
              ),
              TextField(
                controller: floorName,
                decoration: const InputDecoration(labelText: 'Floor Name'),
              ),
              TextField(
                controller: date,
                decoration: const InputDecoration(
                  labelText: 'Date (dd/MM/yyyy)',
                ),
              ),
              TextField(
                controller: time,
                decoration: const InputDecoration(labelText: 'Time (HH:mm)'),
              ),
              TextField(
                controller: cpCount,
                decoration: const InputDecoration(
                  labelText: 'Checkpoint Count',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newDate = date.text.trim();
              final newTime = time.text.trim();
              final building = buildingCode.text.trim();
              final floor = floorCode.text.trim();
              DateTime? newDateTime;
              try {
                newDateTime = DateFormat(
                  'dd/MM/yyyy HH:mm',
                ).parse('$newDate $newTime');
              } catch (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid date/time format')),
                );
                return;
              }

              for (final item in items) {
                if (item['buildingCode'] != building ||
                    item['floorCode'] != floor) {
                  continue;
                }
                try {
                  final existing = DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).parse('${item['rDate']} ${item['rTime']}');
                  final diff = newDateTime.difference(existing).inMinutes.abs();
                  if (diff < 60) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Schedule must be at least 1 hour apart'),
                      ),
                    );
                    return;
                  }
                } catch (_) {
                  // ignore parse errors
                }
              }

              await _ds.addSchedule({
                'code': code.text,
                'rDate': newDate,
                'rTime': newTime,
                'buildingCode': buildingCode.text,
                'buildingName': buildingName.text,
                'floorCode': floorCode.text,
                'floorName': floorName.text,
                'checkPointCount': int.tryParse(cpCount.text) ?? 0,
                'status': 'Pending',
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
      appBar: AppBar(title: const Text('Schedules')),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return ListTile(
              title: Text(
                item['buildingName'] ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${item['rDate'] ?? ''} ${item['rTime'] ?? ''}',
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
