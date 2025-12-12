import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../../presentation/providers/mood_provider.dart';
import '../../presentation/providers/auth_provider.dart';

class QuickMoodTracker extends ConsumerStatefulWidget {
  const QuickMoodTracker({super.key});

  @override
  ConsumerState<QuickMoodTracker> createState() => _QuickMoodTrackerState();
}

class _QuickMoodTrackerState extends ConsumerState<QuickMoodTracker> {
  String? _selectedMood;

  final Map<String, Map<String, dynamic>> _moods = {
    '😊': {'label': 'Happy', 'color': AppTheme.lightPink},
    '😌': {'label': 'Calm', 'color': AppTheme.softBlue},
    '😢': {'label': 'Sad', 'color': AppTheme.lavender},
    '😰': {'label': 'Anxious', 'color': const Color(0xFFFFB74D)},
    '😴': {'label': 'Tired', 'color': AppTheme.neutralGrey},
  };

  Future<void> _trackMood(String mood) async {
    setState(() => _selectedMood = mood);
    final auth = ref.read(authProvider);
    if (auth.user?.id != null) {
      await ref.read(moodHistoryProvider.notifier).track(mood);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('Mood tracked: ${_moods[mood]!['label']}'),
              ],
            ),
            backgroundColor: AppTheme.softPurple,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => _selectedMood = null);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.softPurple.withOpacity(0.12),
            AppTheme.lavender.withOpacity(0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.softPurple.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.softPurple, AppTheme.lavender],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.mood_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How are you feeling?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Track your mood quickly',
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
          const SizedBox(height: 24),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: _moods.entries.map((entry) {
              final isSelected = _selectedMood == entry.key;
              final moodColor = entry.value['color'] as Color;
              return _EmotionBubble(
                emoji: entry.key,
                label: entry.value['label'] as String,
                color: moodColor,
                isSelected: isSelected,
                onTap: () => _trackMood(entry.key),
              );
            }).toList(),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOut);
  }
}

class _EmotionBubble extends StatefulWidget {
  const _EmotionBubble({
    required this.emoji,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_EmotionBubble> createState() => _EmotionBubbleState();
}

class _EmotionBubbleState extends State<_EmotionBubble>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _glowController;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(_EmotionBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _bounceController.forward(from: 0).then((_) {
        _bounceController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_glowController, _bounceController]),
          builder: (context, child) {
            final glowOpacity = 0.3 + (_glowController.value * 0.2);
            final bounceScale = 1.0 + (_bounceController.value * 0.15);
            final hoverScale = _isHovered ? 1.05 : 1.0;
            final finalScale = bounceScale * hoverScale;

            return Transform.scale(
              scale: finalScale,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                decoration: BoxDecoration(
                  gradient: widget.isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.color,
                            widget.color.withOpacity(0.8),
                          ],
                        )
                      : null,
                  color: widget.isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.isSelected
                        ? widget.color
                        : AppTheme.neutralGrey.withOpacity(0.3),
                    width: widget.isSelected ? 2.5 : 1.5,
                  ),
                  boxShadow: [
                    if (widget.isSelected || _isHovered)
                      BoxShadow(
                        color: widget.color.withOpacity(
                          widget.isSelected ? glowOpacity : 0.2,
                        ),
                        blurRadius: widget.isSelected ? 20 : 12,
                        spreadRadius: widget.isSelected ? 4 : 2,
                        offset: const Offset(0, 6),
                      ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.emoji,
                      style: TextStyle(
                        fontSize: 28 + (_bounceController.value * 4),
                      ),
                    )
                        .animate(target: widget.isSelected ? 1 : 0)
                        .shake(duration: 200.ms),
                    const SizedBox(width: 10),
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: widget.isSelected
                                ? Colors.white
                                : AppTheme.textPrimary,
                            fontSize: 15,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 400.ms);
  }
}
