import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../providers/proactive_provider.dart';

class ProactiveCheckinScreen extends ConsumerWidget {
  const ProactiveCheckinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(proactiveProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Check-in'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check how the AI is doing',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Trigger a manual probe to receive a supportive reply tailored to your current data.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await ref.read(proactiveProvider.notifier).manualCheckIn();
                      },
                      icon: const Icon(Icons.flash_on_rounded),
                      label: const Text('Run Manual Check-in'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            state.when(
              data: (msg) => msg == null
                  ? const SizedBox.shrink()
                  : Card(
                      color: AppTheme.lavender.withOpacity(0.06),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          msg,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.textPrimary,
                              ),
                        ),
                      ),
                    ).animate().fadeIn(),
              loading: () => Center(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text('Contacting AI...', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              error: (err, st) => Card(
                color: Colors.red.withOpacity(0.06),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text('Error: ${err.toString()}'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
