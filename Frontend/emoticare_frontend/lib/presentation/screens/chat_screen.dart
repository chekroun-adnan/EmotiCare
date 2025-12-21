import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../../data/models/conversation_models.dart';
import '../../core/theme/app_theme.dart';
import '../providers/chat_provider.dart';
import '../../core/widgets/async_value_widget.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/goal_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/auth_provider.dart';
import '../../data/api/dio_client.dart';
import '../../core/constants/endpoints.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _isRecording = false;
  String? _currentRecordingPath;
  Duration _recordingDuration = Duration.zero;
  String? _playingAudioUrl;
  bool _isPlaying = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission is required')),
          );
        }
        return;
      }

      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
      
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _currentRecordingPath = path;
        _recordingDuration = Duration.zero;
      });

      // Update recording duration
      _updateRecordingDuration();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting recording: $e')),
        );
      }
    }
  }

  void _updateRecordingDuration() {
    if (!_isRecording) return;
    
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording && mounted) {
        setState(() {
          _recordingDuration = _recordingDuration + const Duration(seconds: 1);
        });
        _updateRecordingDuration();
      }
    });
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (path != null && mounted) {
        setState(() {
          _isRecording = false;
          _currentRecordingPath = path;
        });
        // Send audio message
        await _sendAudioMessage(path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error stopping recording: $e')),
        );
      }
    }
  }

  Future<void> _sendAudioMessage(String audioPath) async {
    try {
      final user = ref.read(authProvider).user;
      if (user?.id == null) return;

      // For now, we'll convert audio to text using speech_to_text
      // In production, you'd upload the audio file to your server
      // and use a speech-to-text service
      
      // Show a message that audio was recorded
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audio message recorded. Transcribe and send as text for now.'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Clean up the temporary file
      final file = File(audioPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending audio: $e')),
        );
      }
    }
  }

  Future<void> _playAudio(String url) async {
    try {
      if (_isPlaying && _playingAudioUrl == url) {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
          _playingAudioUrl = null;
        });
        return;
      }

      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      
      setState(() {
        _isPlaying = true;
        _playingAudioUrl = url;
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _playingAudioUrl = null;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(chatHistoryProvider);
    final isSending = ref.watch(chatSendingProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.softPurple.withOpacity(0.05),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                bottom: 16,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.softPurple.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Return/Back button
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: AppTheme.textPrimary,
                    tooltip: 'Back',
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.softPurple, AppTheme.lavender],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Chat Support',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Your emotional wellness assistant',
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
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => ref.refresh(chatHistoryProvider.future),
                color: AppTheme.softPurple,
                child: AsyncValueWidget<List<ConversationMessageModel>>(
                  value: history,
                  onRetry: () => ref.refresh(chatHistoryProvider),
                  builder: (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppTheme.softPurple.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chat_bubble_outline,
                                size: 50,
                                color: AppTheme.softPurple,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Start a conversation',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ask me anything about your emotional wellness',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Or use the microphone to send voice messages',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.all(20),
                      itemCount: data.length,
                      itemBuilder: (_, i) {
                        final msg = data[data.length - 1 - i];
                        final isUser = (msg.sender ?? '').toLowerCase() == 'user';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildMessageBubble(context, msg, isUser, i),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            // Recording indicator
            if (_isRecording)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                color: AppTheme.lightPink.withOpacity(0.1),
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
                    const SizedBox(width: 12),
                    Text(
                      'Recording: ${_formatDuration(_recordingDuration)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightPink,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            // Message Input
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 8,
                top: 12,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.softPurple.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Audio recording button
                  GestureDetector(
                    onTapDown: (_) => _startRecording(),
                    onTapUp: (_) => _stopRecording(),
                    onTapCancel: () => _stopRecording(),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _isRecording ? AppTheme.lightPink : AppTheme.softBlue,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording ? AppTheme.lightPink : AppTheme.softBlue).withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                        .animate(target: _isRecording ? 1 : 0)
                        .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 200.ms),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.warmWhite,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppTheme.neutralGrey.withOpacity(0.3),
                        ),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.6)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.softPurple, AppTheme.lavender],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isSending ? null : _send,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: 48,
                          height: 48,
                          alignment: Alignment.center,
                          child: isSending
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.send_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    ConversationMessageModel msg,
    bool isUser,
    int index,
  ) {
    // Check if message has audio URL (for future audio message support)
    final hasAudio = false; // You can add audio URL to the message model
    
    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.softPurple, AppTheme.lavender],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  gradient: isUser
                      ? LinearGradient(
                          colors: [AppTheme.softPurple, AppTheme.lavender],
                        )
                      : null,
                  color: isUser ? null : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(24),
                    topRight: const Radius.circular(24),
                    bottomLeft: Radius.circular(isUser ? 24 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isUser ? AppTheme.softPurple : AppTheme.neutralGrey).withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasAudio)
                      _buildAudioPlayer(context, '', isUser)
                    else
                      Text(
                        msg.content ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isUser ? Colors.white : AppTheme.textPrimary,
                          height: 1.5,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isUser) ...[
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.lightPink.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_rounded, color: AppTheme.lightPink, size: 20),
              ),
            ],
          ],
        ),
        if (!isUser && msg.suggestions != null) ...[
          const SizedBox(height: 12),
          _buildSuggestions(context, msg.suggestions!),
        ],
      ],
    )
        .animate()
        .fadeIn(delay: (index * 50).ms, duration: 300.ms)
        .slideX(
          begin: isUser ? 0.2 : -0.2,
          end: 0,
          delay: (index * 50).ms,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildAudioPlayer(BuildContext context, String audioUrl, bool isUser) {
    final isPlayingThis = _isPlaying && _playingAudioUrl == audioUrl;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _playAudio(audioUrl),
          icon: Icon(
            isPlayingThis ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: isUser ? Colors.white : AppTheme.softPurple,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Audio message',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isUser ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context, Map<String, dynamic> suggestions) {
    final goals = (suggestions['goals'] as List<dynamic>?) ?? [];
    final habits = (suggestions['habits'] as List<dynamic>?) ?? [];

    if (goals.isEmpty && habits.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 44, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (goals.isNotEmpty) ...[
            Text(
              'Suggested Goals',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: goals.map((g) {
                final map = g as Map<String, dynamic>;
                return ActionChip(
                  avatar: const Icon(Icons.flag_rounded, size: 16),
                  label: Text(map['title'] ?? 'Goal'),
                  onPressed: () {
                    final desc = map['description'] ?? map['title'];
                    ref.read(goalListProvider.notifier).createGoal(desc);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Goal added: ${map['title']}')),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
          if (habits.isNotEmpty) ...[
            Text(
              'Suggested Habits',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: habits.map((h) {
                final map = h as Map<String, dynamic>;
                return ActionChip(
                  avatar: const Icon(Icons.check_circle_rounded, size: 16),
                  label: Text(map['name'] ?? 'Habit'),
                  onPressed: () {
                    ref.read(habitListProvider.notifier).createHabit(
                      HabitEntity(
                        name: map['name'],
                        description: map['frequency'],
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Habit added: ${map['name']}')),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    await ref.read(chatHistoryProvider.notifier).send(text);
    _messageController.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
