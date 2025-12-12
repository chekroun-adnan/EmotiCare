import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../core/widgets/stat_card.dart';
import '../../core/widgets/progress_card.dart';
import '../../core/widgets/quick_mood_tracker.dart';
import '../../core/widgets/recent_activity_item.dart';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/animated_welcome_card.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/mood_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/goal_provider.dart';
import '../../core/widgets/async_value_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final moods = ref.watch(moodHistoryProvider);
    final habits = ref.watch(habitListProvider);
    final goals = ref.watch(goalListProvider);

    // Calculate statistics
    final moodCount = moods.valueOrNull?.length ?? 0;
    final habitCount = habits.valueOrNull?.length ?? 0;
    final completedHabits = habits.valueOrNull?.where((h) => h.completed).length ?? 0;
    final habitProgress = habitCount > 0 ? completedHabits / habitCount : 0.0;
    
    final goalCount = goals.valueOrNull?.length ?? 0;
    final completedGoals = goals.valueOrNull?.where((g) => g.completed).length ?? 0;
    final goalProgress = goalCount > 0 ? completedGoals / goalCount : 0.0;

    // Get recent mood
    final recentMood = moods.valueOrNull?.isNotEmpty == true
        ? moods.valueOrNull!.first
        : null;

    // Get today's date
    final today = DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      body: AnimatedBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.refresh(moodHistoryProvider);
            ref.refresh(habitListProvider);
            ref.refresh(goalListProvider);
          },
          color: AppTheme.softPurple,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Enhanced App Bar with glassmorphism
              SliverAppBar(
                expandedHeight: 160,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.7),
                          Colors.white.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 18),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppTheme.softPurple, AppTheme.lavender],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                              .animate(onPlay: (controller) => controller.repeat())
                              .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
                          const SizedBox(width: 10),
                          Text(
                            'EmotiCare',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                  letterSpacing: 0.5,
                                ),
                          )
                              .animate()
                              .fadeIn(duration: 600.ms)
                              .slideX(begin: -0.2, end: 0),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        today,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 400.ms),
                    ],
                  ),
                ),
                actions: [
                  // Chat icon button
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.softPurple, AppTheme.lavender],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.softPurple.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => context.go('/chat'),
                      icon: const Icon(Icons.chat_bubble_rounded),
                      tooltip: 'Chat',
                      color: Colors.white,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms)
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                  // Theme toggle button
                  Consumer(
                    builder: (context, ref, child) {
                      final themeMode = ref.watch(themeModeProvider);
                      final isDark = themeMode == ThemeMode.dark;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.softPurple.withOpacity(0.1),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
                          icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                          tooltip: isDark ? 'Light mode' : 'Dark mode',
                          color: AppTheme.textPrimary,
                        ),
                      );
                    },
                  )
                      .animate()
                      .fadeIn(delay: 350.ms)
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                  // Logout button
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.softPurple.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => ref.read(authProvider.notifier).logout(ref),
                      icon: const Icon(Icons.logout_rounded),
                      tooltip: 'Logout',
                      color: AppTheme.textPrimary,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms)
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                ],
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Enhanced Animated Welcome Card
                      AnimatedWelcomeCard(
                        name: user?.firstName ?? 'there',
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: -0.3, end: 0, duration: 600.ms, curve: Curves.easeOut),

                      const SizedBox(height: 28),

                      // Quick Mood Tracker with enhanced spacing
                      const QuickMoodTracker()
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0, delay: 300.ms, duration: 500.ms),
                      const SizedBox(height: 28),

                      // Statistics Section
                      Text(
                        'Your Statistics',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 400.ms)
                          .slideX(begin: -0.1, end: 0, delay: 200.ms, duration: 400.ms),
                      const SizedBox(height: 16),

                      // Stats Grid
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: 'Moods Tracked',
                              value: '$moodCount',
                              icon: Icons.mood_rounded,
                              color: AppTheme.softPurple,
                              subtitle: recentMood != null
                                  ? 'Last: ${recentMood.mood}'
                                  : 'Start tracking',
                              delay: 400.ms,
                              progress: moodCount > 0 ? (moodCount / 30).clamp(0.0, 1.0) : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: StatCard(
                              title: 'Active Habits',
                              value: '$habitCount',
                              icon: Icons.check_circle_rounded,
                              color: AppTheme.softBlue,
                              subtitle: '$completedHabits completed today',
                              delay: 500.ms,
                              progress: habitCount > 0 ? habitProgress : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: 'Goals Set',
                              value: '$goalCount',
                              icon: Icons.flag_rounded,
                              color: AppTheme.lightPink,
                              subtitle: '$completedGoals achieved',
                              delay: 600.ms,
                              progress: goalCount > 0 ? goalProgress : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: StatCard(
                              title: 'Wellness Score',
                              value: '${_calculateWellnessScore(habitProgress, goalProgress)}%',
                              icon: Icons.favorite_rounded,
                              color: AppTheme.lavender,
                              subtitle: 'Keep it up!',
                              delay: 700.ms,
                              progress: _calculateWellnessScore(habitProgress, goalProgress) / 100,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Progress Section
                      Text(
                        'Your Progress',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                      )
                          .animate()
                          .fadeIn(delay: 700.ms, duration: 400.ms)
                          .slideX(begin: -0.1, end: 0, delay: 700.ms, duration: 400.ms),
                      const SizedBox(height: 16),

                      ProgressCard(
                        title: 'Habits Progress',
                        progress: habitProgress,
                        color: AppTheme.softBlue,
                        subtitle: '$completedHabits of $habitCount habits completed',
                        onTap: () => context.go('/habits'),
                        delay: 800.ms,
                      ),
                      const SizedBox(height: 12),
                      ProgressCard(
                        title: 'Goals Progress',
                        progress: goalProgress,
                        color: AppTheme.lightPink,
                        subtitle: '$completedGoals of $goalCount goals achieved',
                        onTap: () => context.go('/goals'),
                        delay: 900.ms,
                      ),

                      const SizedBox(height: 32),

                      // Quick Actions Section
                      Text(
                        'Quick Actions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                      )
                          .animate()
                          .fadeIn(delay: 1000.ms, duration: 400.ms)
                          .slideX(begin: -0.1, end: 0, delay: 1000.ms, duration: 400.ms),
                      const SizedBox(height: 16),

                      // Quick Action Cards
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildQuickActionCard(
                            context,
                            'Journal',
                            Icons.book_rounded,
                            AppTheme.lavender,
                            'Write your thoughts',
                            () => context.go('/journal'),
                          )
                              .animate()
                              .fadeIn(delay: 1100.ms, duration: 300.ms)
                              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), delay: 1100.ms, duration: 300.ms),
                          _buildQuickActionCard(
                            context,
                            'Chat',
                            Icons.chat_bubble_rounded,
                            AppTheme.softPurple,
                            'AI support',
                            () => context.go('/chat'),
                          )
                              .animate()
                              .fadeIn(delay: 1200.ms, duration: 300.ms)
                              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), delay: 1200.ms, duration: 300.ms),
                          _buildQuickActionCard(
                            context,
                            'Community',
                            Icons.people_rounded,
                            AppTheme.softBlue,
                            'Connect',
                            () => context.go('/community'),
                          )
                              .animate()
                              .fadeIn(delay: 1300.ms, duration: 300.ms)
                              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), delay: 1300.ms, duration: 300.ms),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Recent Activity Section
                      Text(
                        'Recent Activity',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                      )
                          .animate()
                          .fadeIn(delay: 1400.ms, duration: 400.ms)
                          .slideX(begin: -0.1, end: 0, delay: 1400.ms, duration: 400.ms),
                      const SizedBox(height: 16),

                      // Recent Activity List
                      _buildRecentActivity(context, moods, habits, goals),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String subtitle,
    VoidCallback onTap,
  ) {
    return _AnimatedActionCard(
      title: title,
      icon: icon,
      color: color,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    AsyncValue moods,
    AsyncValue habits,
    AsyncValue goals,
  ) {
    final activities = <Map<String, dynamic>>[];

    // Add recent moods
    if (moods.valueOrNull != null) {
      final moodList = moods.valueOrNull as List?;
      if (moodList?.isNotEmpty == true) {
        final recentMood = moodList!.first;
        activities.add({
          'icon': Icons.mood_rounded,
          'title': 'Mood tracked: ${recentMood.mood}',
          'subtitle': _formatTime(recentMood.timestamp),
          'color': AppTheme.softPurple,
          'onTap': () => context.go('/moods'),
        });
      }
    }

    // Add recent habits
    if (habits.valueOrNull != null) {
      final habitList = habits.valueOrNull as List?;
      if (habitList?.isNotEmpty == true) {
        final recentHabit = habitList!.first;
        activities.add({
          'icon': Icons.check_circle_rounded,
          'title': recentHabit.name ?? 'Habit updated',
          'subtitle': 'Habit tracking',
          'color': AppTheme.softBlue,
          'onTap': () => context.go('/habits'),
        });
      }
    }

    // Add recent goals
    if (goals.valueOrNull != null) {
      final goalList = goals.valueOrNull as List?;
      if (goalList?.isNotEmpty == true) {
        final recentGoal = goalList!.first;
        activities.add({
          'icon': Icons.flag_rounded,
          'title': recentGoal.description ?? 'Goal updated',
          'subtitle': 'Goal progress',
          'color': AppTheme.lightPink,
          'onTap': () => context.go('/goals'),
        });
      }
    }

    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.inbox_rounded,
                size: 48,
                color: AppTheme.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'No recent activity',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: activities.take(3).map((activity) {
        final index = activities.indexOf(activity);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RecentActivityItem(
            icon: activity['icon'] as IconData,
            title: activity['title'] as String,
            subtitle: activity['subtitle'] as String,
            color: activity['color'] as Color,
            onTap: activity['onTap'] as VoidCallback?,
            delay: (1500 + index * 100).ms,
          ),
        );
      }).toList(),
    );
  }

  String _formatTime(DateTime? timestamp) {
    if (timestamp == null) return 'Just now';
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return DateFormat('MMM d').format(timestamp);
  }

  int _calculateWellnessScore(double habitProgress, double goalProgress) {
    final score = ((habitProgress + goalProgress) / 2 * 100).round();
    return score.clamp(0, 100);
  }
}

class _AnimatedActionCard extends StatefulWidget {
  const _AnimatedActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<_AnimatedActionCard> createState() => _AnimatedActionCardState();
}

class _AnimatedActionCardState extends State<_AnimatedActionCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 56) / 3,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              transform: Matrix4.identity()
                ..scale(_isHovered ? 1.05 : 1.0),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(
                      _isHovered ? 0.25 : 0.15,
                    ),
                    blurRadius: _isHovered ? 20 : 15,
                    spreadRadius: _isHovered ? 3 : 0,
                    offset: Offset(0, _isHovered ? 8 : 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.color.withOpacity(0.2),
                              widget.color.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(
                                0.2 + (_pulseController.value * 0.15),
                              ),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.color,
                          size: 28,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
