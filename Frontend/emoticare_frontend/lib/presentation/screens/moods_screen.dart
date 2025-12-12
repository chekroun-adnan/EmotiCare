import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/async_value_widget.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/mood_entity.dart';
import '../providers/mood_provider.dart';

class MoodsScreen extends ConsumerStatefulWidget {
  const MoodsScreen({super.key});

  @override
  ConsumerState<MoodsScreen> createState() => _MoodsScreenState();
}

class _MoodsScreenState extends ConsumerState<MoodsScreen> {
  final _moodController = TextEditingController();
  final _noteController = TextEditingController();

  final Map<String, Map<String, dynamic>> _moodEmojis = {
    'Happy': {'emoji': '😊', 'color': AppTheme.lightPink},
    'Calm': {'emoji': '😌', 'color': AppTheme.softBlue},
    'Sad': {'emoji': '😢', 'color': AppTheme.lavender},
    'Anxious': {'emoji': '😰', 'color': const Color(0xFFFFB74D)},
    'Tired': {'emoji': '😴', 'color': AppTheme.neutralGrey},
    'Excited': {'emoji': '🤩', 'color': AppTheme.softPurple},
    'Angry': {'emoji': '😠', 'color': const Color(0xFFEF4444)},
  };

  Color _getMoodColor(String mood) {
    final moodLower = mood.toLowerCase();
    for (var entry in _moodEmojis.entries) {
      if (moodLower.contains(entry.key.toLowerCase())) {
        return entry.value['color'] as Color;
      }
    }
    return AppTheme.softPurple;
  }

  String _getMoodEmoji(String mood) {
    final moodLower = mood.toLowerCase();
    for (var entry in _moodEmojis.entries) {
      if (moodLower.contains(entry.key.toLowerCase())) {
        return entry.value['emoji'] as String;
      }
    }
    return '😊';
  }

  @override
  Widget build(BuildContext context) {
    final moods = ref.watch(moodHistoryProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.softPurple.withOpacity(0.08),
              AppTheme.lavender.withOpacity(0.05),
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
                          colors: [AppTheme.softPurple, AppTheme.lavender],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.mood_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Text('Mood Tracker'),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RefreshIndicator(
                  onRefresh: () async => ref.refresh(moodHistoryProvider.future),
                  color: AppTheme.softPurple,
                  child: AsyncValueWidget<List<MoodEntity>>(
                    value: moods,
                    onRetry: () => ref.refresh(moodHistoryProvider),
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
                                  color: AppTheme.softPurple.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.mood_outlined,
                                  size: 50,
                                  color: AppTheme.softPurple,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No moods tracked yet',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start tracking your emotions to see patterns',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Mood History',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...data.asMap().entries.map((entry) {
                            final index = entry.key;
                            final m = entry.value;
                            final moodColor = _getMoodColor(m.mood);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildMoodCard(context, m, moodColor, index),
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
        label: const Text('Track Mood'),
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context, MoodEntity mood, Color color, int index) {
    final emoji = _getMoodEmoji(mood.mood);
    final date = mood.timestamp != null
        ? DateFormat('MMM d, yyyy • h:mm a').format(mood.timestamp!.toLocal())
        : 'Recently';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  color.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mood.mood,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (mood.note != null && mood.note!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    mood.note!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (index * 100).ms, duration: 400.ms)
        .slideY(begin: 0.2, end: 0, delay: (index * 100).ms, duration: 400.ms, curve: Curves.easeOut);
  }

  Future<void> _openDialog(BuildContext context) async {
    _moodController.clear();
    _noteController.clear();
    
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
                        colors: [AppTheme.softPurple, AppTheme.lavender],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.mood_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Track Your Mood',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _moodController,
                decoration: InputDecoration(
                  labelText: 'How are you feeling?',
                  prefixIcon: const Icon(Icons.mood_outlined),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Note (optional)',
                  prefixIcon: const Icon(Icons.note_outlined),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'What\'s on your mind?',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_moodController.text.trim().isEmpty) return;
                    await ref.read(moodHistoryProvider.notifier).track(
                      _moodController.text.trim(),
                      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
                    );
                    if (mounted) Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Save Mood'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
