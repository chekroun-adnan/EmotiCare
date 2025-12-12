import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/widgets/async_value_widget.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goal_provider.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({super.key});

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalListProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightPink.withOpacity(0.08),
              AppTheme.softPurple.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.lightPink, AppTheme.softPurple],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.flag_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text('Goals'),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RefreshIndicator(
                  onRefresh: () async => ref.refresh(goalListProvider.future),
                  color: AppTheme.lightPink,
                  child: AsyncValueWidget<List<GoalEntity>>(
                    value: goals,
                    onRetry: () => ref.refresh(goalListProvider),
                    builder: (data) {
                      if (data.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(48),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightPink.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.flag_outlined,
                                  size: 50,
                                  color: AppTheme.lightPink,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No goals yet',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Set goals to achieve your dreams',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      final completedCount = data.where((g) => g.completed).length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.lightPink.withOpacity(0.2),
                                  AppTheme.softPurple.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightPink,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Achievements',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        '$completedCount of ${data.length} completed',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Your Goals',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...data.asMap().entries.map((entry) {
                            final index = entry.key;
                            final g = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildGoalCard(context, g, index),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Goal'),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, GoalEntity goal, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: goal.completed ? AppTheme.lightPink : AppTheme.neutralGrey.withOpacity(0.3),
          width: goal.completed ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (goal.completed ? AppTheme.lightPink : AppTheme.neutralGrey).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => ref.read(goalListProvider.notifier).toggleComplete(goal),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: goal.completed ? AppTheme.lightPink : Colors.transparent,
                border: Border.all(
                  color: goal.completed ? AppTheme.lightPink : AppTheme.neutralGrey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: goal.completed
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              goal.description,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: goal.completed
                    ? AppTheme.textSecondary
                    : AppTheme.textPrimary,
                decoration: goal.completed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          if (goal.completed)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.lightPink.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.emoji_events_rounded,
                color: AppTheme.lightPink,
                size: 20,
              ),
            ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 80).ms, duration: 400.ms)
        .slideX(begin: -0.1, end: 0, delay: (index * 80).ms, duration: 400.ms, curve: Curves.easeOut);
  }

  Future<void> _openDialog(BuildContext context) async {
    _descController.clear();
    
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.neutralGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.lightPink, AppTheme.softPurple],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.flag_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'New Goal',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _descController,
                maxLines: 3,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'What do you want to achieve?',
                  prefixIcon: const Icon(Icons.flag_outlined),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Describe your goal...',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_descController.text.trim().isEmpty) return;
                    await ref.read(goalListProvider.notifier).createGoal(_descController.text.trim());
                    if (mounted) Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Create Goal'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
