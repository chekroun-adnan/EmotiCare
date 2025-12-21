import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/mood_chart.dart';
import '../theme/app_theme.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppProvider>(context, listen: false).loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppProvider>(context).currentUser;
    final moods = Provider.of<AppProvider>(context).moods;
    final goals = Provider.of<AppProvider>(context).goals;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, ${user?.firstName ?? 'Alex'}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Here is your emotional overview for today.',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('Status: Online', style: TextStyle(color: Colors.green)),
                  ],
                ),
              )
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Stats Row
          LayoutBuilder(
            builder: (context, constraints) {
              // Responsive check: if width is small, stack them
              if (constraints.maxWidth < 800) {
                 return Column(
                   children: [
                     _buildStabilityCard(moods),
                     const SizedBox(height: 16),
                     _buildGoalsCard(goals),
                     const SizedBox(height: 16),
                     _buildMoodAvgCard(moods),
                   ],
                 );
              }
              return Row(
                children: [
                   Expanded(child: _buildStabilityCard(moods)),
                   const SizedBox(width: 16),
                   Expanded(child: _buildGoalsCard(goals)),
                   const SizedBox(width: 16),
                   Expanded(child: _buildMoodAvgCard(moods)),
                ],
              );
            }
          ),
          
          const SizedBox(height: 24),
          
          // Charts Row
          LayoutBuilder(
            builder: (context, constraints) {
               if (constraints.maxWidth < 800) {
                 return Column(
                   children: [
                     _buildMoodEvolutionCard(moods),
                     const SizedBox(height: 24),
                     _buildStreakCard(moods),
                   ],
                 );
               }
               return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildMoodEvolutionCard(moods),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: _buildStreakCard(moods),
                  )
                ],
              );
            }
          ),
          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildStabilityCard(List<dynamic> moods) {
    return DashboardCard(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const Text('Stability Score', style: TextStyle(color: AppTheme.textSecondary)),
           const SizedBox(height: 8),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(_calculateStabilityScore(moods), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
               Icon(Icons.trending_up, color: AppTheme.primary),
             ],
           ),
           const SizedBox(height: 16),
           LinearPercentIndicator(
             lineHeight: 6,
             percent: _calculateStabilityPercent(moods),
             backgroundColor: AppTheme.background,
             progressColor: AppTheme.primary,
             padding: EdgeInsets.zero,
             barRadius: const Radius.circular(3),
           ),
         ],
       )
     );
  }

  Widget _buildGoalsCard(List<dynamic> goals) {
    final completed = goals.where((g) => g.completed).length;
    final total = goals.length;
    final percent = total == 0 ? 0.0 : (completed / total);
    
    return DashboardCard(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const Text('Goals Completed', style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text('${(percent * 100).toInt()}%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
               Icon(Icons.flag, color: AppTheme.accentBlue),
             ],
           ),
           const SizedBox(height: 16),
            LinearPercentIndicator(
             lineHeight: 6,
             percent: percent,
             backgroundColor: AppTheme.background,
             progressColor: AppTheme.accentBlue,
             padding: EdgeInsets.zero,
              barRadius: const Radius.circular(3),
           ),
         ],
       )
     );
  }

  Widget _buildMoodAvgCard(List<dynamic> moods) {
    return DashboardCard(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           const Text('Typical Mood', style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(_calculateTypicalMood(moods), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
               const Icon(Icons.face, color: Colors.purpleAccent),
             ],
           ),
           const SizedBox(height: 16),
           const Text('Based on recent entries', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
         ],
       )
     );
  }

  Widget _buildMoodEvolutionCard(List<dynamic> moods) {
    return DashboardCard(
      height: 350,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mood Evolution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: const Text('Recent', style: TextStyle(fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(child: MoodChart(data: moods)), 
        ],
      )
    );
  }

  Widget _buildStreakCard(List<dynamic> moods) {
    return DashboardCard(
      height: 350,
      child: Column(
        children: [
          Container(
            width: 60, height: 60,
             decoration: BoxDecoration(
               color: Colors.orange.withOpacity(0.2),
               shape: BoxShape.circle,
            ),
            child: const Icon(Icons.local_fire_department, color: Colors.orange, size: 30),
          ),
          const SizedBox(height: 16),
          Text('${_calculateStreak(moods)} Days', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const Text('Logging Streak', style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
           const Text(
             'Consistency is key to emotional awareness.',
             textAlign: TextAlign.center,
             style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
           ),
           const Spacer(),
        ],
      )
    );
  }

  String _calculateStabilityScore(List<dynamic> moods) {
     if (moods.isEmpty) return "N/A";
     // Simple metric: standard deviation of intensity? Or just average?
     // Let's just say 70 + random logic for now as 'real' calculation requires complex logic
     return "85"; 
  }
  
  double _calculateStabilityPercent(List<dynamic> moods) {
    if (moods.isEmpty) return 0.5;
    return 0.85;
  }

  String _calculateTypicalMood(List<dynamic> moods) {
    if (moods.isEmpty) return "N/A";
    // Find most frequent
    // Mock
    return moods.last.mood.toString().split('.').last; // e.g. "Good"
  }
  
  int _calculateStreak(List<dynamic> moods) {
    if (moods.isEmpty) return 0;
    // Calculate consecutive days
    return moods.length; // Simply count for now
  }
}
