import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/animated_background.dart';
import '../../domain/entities/twin_entity.dart';
import '../providers/twin_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';

class TwinScreen extends ConsumerStatefulWidget {
  const TwinScreen({super.key});

  @override
  ConsumerState<TwinScreen> createState() => _TwinScreenState();
}

class _TwinScreenState extends ConsumerState<TwinScreen> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  bool _isSpeaking = false;
  String _spokenText = '';
  final List<Map<String, dynamic>> _conversation = [];

  @override
  void initState() {
    super.initState();
    _initializeTTS();
    _initializeSpeech();
  }

  Future<void> _initializeTTS() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    
    _tts.setStartHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = true;
        });
      }
    });
    
    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
    
    _tts.setErrorHandler((msg) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('TTS Error: $msg')),
        );
      }
    });
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (error) {
        setState(() {
          _isListening = false;
        });
      },
    );
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition not available')),
        );
      }
    }
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _spokenText = '';
        });
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _spokenText = result.recognizedWords;
            });
            if (result.finalResult) {
              _handleVoiceInput(result.recognizedWords);
            }
          },
        );
      }
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  Future<void> _handleVoiceInput(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _conversation.add({
        'sender': 'user',
        'text': text,
        'timestamp': DateTime.now(),
      });
    });

    // Send to chat API
    final user = ref.read(authProvider).user;
    if (user?.id != null) {
      try {
        // Send message and wait for response
        await ref.read(chatHistoryProvider.notifier).send(text);
        
        // Wait a bit for the response to be processed
        await Future.delayed(const Duration(milliseconds: 800));
        
        // Get the latest response from chat history
        final historyAsync = ref.read(chatHistoryProvider);
        historyAsync.when(
          data: (history) {
            if (history.isNotEmpty) {
              // Find the latest assistant message
              final assistantMessages = history.where((msg) => msg.sender == 'assistant').toList();
              if (assistantMessages.isNotEmpty) {
                final lastResponse = assistantMessages.last;
                final response = lastResponse.content ?? '';
                
                if (response.isNotEmpty) {
                  setState(() {
                    _conversation.add({
                      'sender': 'twin',
                      'text': response,
                      'timestamp': DateTime.now(),
                    });
                  });
                  
                  // Speak the response
                  _speak(response);
                }
              }
            }
          },
          loading: () {},
          error: (error, stack) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${error.toString()}'),
                  backgroundColor: AppTheme.lightPink,
                ),
              );
            }
          },
        );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error sending message: $e'),
              backgroundColor: AppTheme.lightPink,
            ),
          );
        }
      }
    }
  }

  Future<void> _speak(String text) async {
    if (text.trim().isEmpty) return;
    
    setState(() {
      _isSpeaking = true;
    });
    
    // Speak the text
    await _tts.speak(text);
    
    // Wait for speech to complete
    await _tts.awaitSpeakCompletion(true);
    
    // Small delay to ensure state updates properly
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (mounted) {
      setState(() {
        _isSpeaking = false;
      });
    }
  }

  String _getModelUrl(TwinEntity twin) {
    // Use different models or animations based on emotion
    final emotion = twin.dominantEmotion?.toLowerCase() ?? 'neutral';
    
    // Using local model from web/assets/
    // IMPORTANT: model-viewer only supports .glb or .gltf files, NOT .fbx
    // If you have rp_nathan_animated_003_walking.fbx, you need to convert it to .glb first
    // You can use Blender or online converters to convert .fbx to .glb
    
    // Try to load the model - if it's .glb or .gltf, it will work
    // If it's still .fbx, it won't load and you'll see the fallback
    return '/assets/rp_nathan_animated_003_walking.glb';
    
    // Alternative: If you have a different .glb file, use that instead:
    // return '/assets/your_model.glb';
  }
  
  // Get animation or pose based on emotion for behavior mirroring
  String? _getModelAnimation(TwinEntity twin) {
    final emotion = twin.dominantEmotion?.toLowerCase() ?? 'neutral';
    
    // Map emotions to animations (if your model supports animations)
    if (emotion.contains('happy') || emotion.contains('joy')) {
      return 'happy'; // Animation name in your glTF model
    } else if (emotion.contains('sad') || emotion.contains('depressed')) {
      return 'sad';
    } else if (emotion.contains('angry') || emotion.contains('frustrated')) {
      return 'angry';
    } else if (emotion.contains('anxious') || emotion.contains('worried')) {
      return 'anxious';
    }
    return 'idle'; // Default animation
  }

  Widget _build3DModelViewer(BuildContext context, TwinEntity twin) {
    final modelUrl = _getModelUrl(twin);
    
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // 3D Model Viewer
          ModelViewer(
            src: modelUrl,
            alt: 'Your Digital Twin',
            ar: true,
            autoRotate: true,
            cameraControls: true,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final twinState = ref.watch(twinProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      body: AnimatedBackground(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
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
                title: Row(
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
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Digital Twin',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: 0.5,
                          ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => ref.read(twinProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh',
                  color: AppTheme.textPrimary,
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 3D Human Model Container
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.softPurple.withOpacity(0.1),
                            AppTheme.lavender.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.softPurple.withOpacity(0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.softPurple.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          children: [
                            twinState.when(
                              data: (twin) => _build3DModelViewer(context, twin),
                              loading: () => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.softPurple,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Loading your digital twin...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              error: (error, stack) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline_rounded,
                                      size: 48,
                                      color: AppTheme.lightPink,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Failed to load twin',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () =>
                                          ref.read(twinProvider.notifier).refresh(),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Speaking indicator
                            if (_isSpeaking)
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.softPurple.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.softPurple.withOpacity(0.5),
                                        blurRadius: 15,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.volume_up_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                )
                                    .animate(onPlay: (controller) => controller.repeat())
                                    .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2), duration: 500.ms)
                                    .then()
                                    .scale(begin: const Offset(1.2, 1.2), end: const Offset(1, 1), duration: 500.ms),
                              ),
                            // Speaking overlay with pulsing effect
                            if (_isSpeaking)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: AppTheme.softPurple.withOpacity(0.5),
                                      width: 3,
                                    ),
                                  ),
                                )
                                    .animate(onPlay: (controller) => controller.repeat())
                                    .fadeIn(duration: 800.ms)
                                    .then()
                                    .fadeOut(duration: 800.ms),
                              ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0, duration: 600.ms),

                    const SizedBox(height: 24),

                    // Voice Interaction Controls
                    _buildVoiceControls(context)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms)
                        .slideY(begin: 0.2, end: 0, delay: 200.ms, duration: 500.ms),

                    const SizedBox(height: 24),

                    // Conversation History
                    if (_conversation.isNotEmpty)
                      _buildConversationHistory(context)
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 500.ms),

                    const SizedBox(height: 24),

                    // Twin Information Cards
                    twinState.when(
                      data: (twin) => _buildTwinInfoCards(context, twin),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 24),

                    // Update Button
                    twinState.when(
                      data: (twinData) => ElevatedButton.icon(
                        onPressed: () async {
                          await ref.read(twinProvider.notifier).updateTwin();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Updating your digital twin...'),
                                backgroundColor: AppTheme.softPurple,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.update_rounded),
                        label: const Text('Update Twin'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.softPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0, delay: 400.ms, duration: 500.ms),
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceControls(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softPurple.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.mic_rounded,
                color: AppTheme.softPurple,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Voice Interaction',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isListening && _spokenText.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppTheme.softPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _spokenText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Listen Button
              ElevatedButton.icon(
                onPressed: _isListening ? _stopListening : _startListening,
                icon: Icon(_isListening ? Icons.stop_rounded : Icons.mic_rounded),
                label: Text(_isListening ? 'Stop Listening' : 'Start Speaking'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: _isListening ? AppTheme.lightPink : AppTheme.softPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Stop Speaking Button
              if (_isSpeaking)
                ElevatedButton.icon(
                  onPressed: () async {
                    await _tts.stop();
                    setState(() {
                      _isSpeaking = false;
                    });
                  },
                  icon: const Icon(Icons.volume_off_rounded),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    backgroundColor: AppTheme.softBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
          ),
          if (_isListening)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppTheme.lightPink,
                      shape: BoxShape.circle,
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .scale(begin: const Offset(1, 1), end: const Offset(1.5, 1.5), duration: 500.ms)
                      .then()
                      .scale(begin: const Offset(1.5, 1.5), end: const Offset(1, 1), duration: 500.ms),
                  const SizedBox(width: 8),
                  Text(
                    'Listening...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConversationHistory(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.softPurple.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppTheme.softPurple,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Conversation',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._conversation.reversed.take(5).map((msg) {
            final isUser = msg['sender'] == 'user';
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.softPurple, AppTheme.lavender],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppTheme.softPurple.withOpacity(0.1)
                            : AppTheme.lavender.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        msg['text'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                      ),
                    ),
                  ),
                  if (isUser) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.softBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppTheme.softBlue,
                        size: 16,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTwinInfoCards(BuildContext context, TwinEntity twin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInfoCard(
          context,
          'Dominant Emotion',
          twin.dominantEmotion ?? 'Neutral',
          Icons.mood_rounded,
          AppTheme.softPurple,
        )
            .animate()
            .fadeIn(delay: 200.ms, duration: 500.ms)
            .slideX(begin: -0.1, end: 0, delay: 200.ms, duration: 500.ms),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          'Stress Trigger',
          twin.stressTrigger ?? 'Unknown',
          Icons.warning_rounded,
          AppTheme.lightPink,
        )
            .animate()
            .fadeIn(delay: 300.ms, duration: 500.ms)
            .slideX(begin: -0.1, end: 0, delay: 300.ms, duration: 500.ms),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          'Preferred Coping',
          twin.preferredCoping ?? 'Unknown',
          Icons.favorite_rounded,
          AppTheme.lavender,
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 500.ms)
            .slideX(begin: -0.1, end: 0, delay: 400.ms, duration: 500.ms),
        if (twin.updatedAt != null) ...[
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            'Last Updated',
            DateFormat('MMM d, y • h:mm a').format(twin.updatedAt!),
            Icons.access_time_rounded,
            AppTheme.softBlue,
          )
              .animate()
              .fadeIn(delay: 500.ms, duration: 500.ms)
              .slideX(begin: -0.1, end: 0, delay: 500.ms, duration: 500.ms),
        ],
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    _tts.stop();
    super.dispose();
  }
}
