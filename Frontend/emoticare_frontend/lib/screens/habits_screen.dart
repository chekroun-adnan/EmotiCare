import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({Key? key}) : super(key: key);

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void _addHabit() {
    if (_nameController.text.isEmpty) return;
    Provider.of<AppProvider>(context, listen: false).createHabit(
      _nameController.text, 
      _descController.text
    );
    _nameController.clear();
    _descController.clear();
    Navigator.of(context).pop();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('New Habit', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Habit Name', labelStyle: TextStyle(color: Colors.grey)),
              style: const TextStyle(color: Colors.white),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description', labelStyle: TextStyle(color: Colors.grey)),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: _addHabit, child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Habit Tracker', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('New Habit'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary, foregroundColor: Colors.black)
              )
            ],
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, _) {
                 if (provider.habits.isEmpty) {
                   return const Center(child: Text('No habits tailored yet. Start one!', style: TextStyle(color: AppTheme.textSecondary)));
                 }
                 return GridView.builder(
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2, 
                     childAspectRatio: 1.5,
                     crossAxisSpacing: 20,
                     mainAxisSpacing: 20
                   ),
                   itemCount: provider.habits.length,
                   itemBuilder: (context, index) {
                     final habit = provider.habits[index];
                     return DashboardCard(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  habit.completed ? Icons.check_circle : Icons.circle_outlined,
                                  color: habit.completed ? AppTheme.accentYellow : Colors.grey,
                                  size: 32,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check, color: AppTheme.primary),
                                  onPressed: () => provider.completeHabit(habit.id),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(habit.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 8),
                            Text(habit.description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12), maxLines: 2),
                         ],
                       ),
                     );
                   },
                 );
              }
            ),
          )
        ],
      ),
    );
  }
}
