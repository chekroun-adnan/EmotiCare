import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({Key? key}) : super(key: key);

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
                   Text('My Journal', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                   const Text('Your Safe Space', style: TextStyle(color: AppTheme.textSecondary)),
                 ],
               ),
               Icon(Icons.notifications_none, color: AppTheme.textSecondary),
            ],
          ),
          const SizedBox(height: 32),
          
          // Input Area
          DashboardCard(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "What's on your mind today, Alex?",
                    border: OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)), borderSide: BorderSide.none),
                    contentPadding: EdgeInsets.all(24),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                     border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
                  ),
                  child: Row(
                    children: [
                      const Text('FEELING:', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      const SizedBox(width: 8),
                      // Icons...
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {}, // Save functionality
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary, 
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                        ),
                        child: const Text('Save Entry'),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Search and Filter
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search entries by keyword...',
                    filled: true,
                    fillColor: AppTheme.surface,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Filter chips...
            ],
          ),
          
          const SizedBox(height: 24),
          
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, _) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: provider.journals.length,
                  itemBuilder: (context, index) {
                    final journal = provider.journals[index];
                     return DashboardCard(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Icon(Icons.spa, color: AppTheme.primary), // Dynamic sentiment icon
                               Icon(Icons.more_horiz, color: Colors.grey),
                             ],
                           ),
                           const SizedBox(height: 12),
                           Text(
                             journal.text.length > 30 ? '${journal.text.substring(0, 30)}...' : journal.text, 
                             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                           ),
                           const SizedBox(height: 8),
                           Text(
                             journal.text,
                             maxLines: 3,
                             overflow: TextOverflow.ellipsis,
                             style: const TextStyle(color: AppTheme.textSecondary),
                           ),
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
