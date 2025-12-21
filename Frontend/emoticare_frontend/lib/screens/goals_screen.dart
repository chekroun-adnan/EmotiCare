import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Container(
       padding: const EdgeInsets.all(32),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('My Goals', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                   const Text('Track your journey', style: TextStyle(color: AppTheme.textSecondary)),
                 ],
               ),
               ElevatedButton.icon(
                 onPressed: () {
                   // Add goal dialog
                 },
                 icon: const Icon(Icons.add),
                 label: const Text('New Goal'),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: AppTheme.primary,
                   foregroundColor: Colors.black,
                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                 ),
               ),
             ],
           ),
           const SizedBox(height: 32),
           
           // Daily Spark Quote
           DashboardCard(
             padding: const EdgeInsets.all(24),
             child: Row(
               children: [
                 Container(
                   padding: const EdgeInsets.all(16),
                   decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                   child: const Icon(Icons.lightbulb, color: Colors.green),
                 ),
                 const SizedBox(width: 24),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const Text('DAILY SPARK', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                       const SizedBox(height: 8),
                       const Text('"The only limit to our realization of tomorrow will be our doubts of today."', 
                         style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                       const SizedBox(height: 8),
                       const Text('— Your AI Companion', style: TextStyle(color: AppTheme.textSecondary)),
                     ],
                   )
                 )
               ],
             ),
           ),
           
           const SizedBox(height: 32),
           
           // Filters
           Row(
             children: [
               _buildFilterChip('All Goals', true),
               _buildFilterChip('In Progress', false),
               _buildFilterChip('To Do', false),
               _buildFilterChip('Completed', false),
             ],
           ),
           
           const SizedBox(height: 24),
           
           Expanded(
             child: Consumer<AppProvider>(
               builder: (context, provider, _) {
                 if (provider.goals.isEmpty) {
                   return const Center(child: Text("No goals yet. Create one!", style: TextStyle(color: AppTheme.textSecondary)));
                 }
                 return GridView.builder(
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2,
                     crossAxisSpacing: 16,
                     mainAxisSpacing: 16,
                     childAspectRatio: 1.6,
                   ),
                   itemCount: provider.goals.length,
                   itemBuilder: (context, index) {
                     final goal = provider.goals[index];
                     return DashboardCard(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Container(
                                 padding: const EdgeInsets.all(8),
                                 decoration: BoxDecoration(color: AppTheme.background, shape: BoxShape.circle),
                                 child: Icon(Icons.flag, color: AppTheme.accentYellow),
                               ),
                               Icon(Icons.more_horiz, color: Colors.grey),
                             ],
                           ),
                           const SizedBox(height: 16),
                           Text(goal.description, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                           const Spacer(),
                           Row(
                             children: [
                               Checkbox(
                                 value: goal.completed, 
                                 onChanged: (val) {
                                   provider.toggleGoal(goal.id);
                                 },
                                 activeColor: AppTheme.primary,
                                 checkColor: Colors.black,
                               ),
                               Text(goal.completed ? 'Completed' : 'In Progress', style: TextStyle(color: goal.completed ? Colors.green : AppTheme.textSecondary)),
                             ],
                           ),
                           LinearPercentIndicator(
                             percent: goal.completed ? 1.0 : 0.3, // Mock progress if not available
                             progressColor: goal.completed ? Colors.green : AppTheme.accentYellow,
                             backgroundColor: AppTheme.background,
                             padding: EdgeInsets.zero,
                           )
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

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.black : AppTheme.textSecondary, fontWeight: FontWeight.bold)),
    );
  }
}
