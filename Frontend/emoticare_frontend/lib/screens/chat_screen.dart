import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _initSpeech();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _controller.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
           if(mounted) setState(() => _isListening = false);
        }
      },
      onError: (error) {
        if(mounted) setState(() => _isListening = false);
      },
    );
    if(mounted) setState(() {});
  }

  void _listen() async {
    if (!_isListening) {
      if (_speechEnabled) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _controller.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.speak(text);
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    Provider.of<AppProvider>(context, listen: false).sendMessage(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Emoticare Assistant', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Row(
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        const Text('Online & Ready to listen', style: TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: (){
                    // Crisis support action
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2), 
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  child: const Text('Crisis Support'),
                )
              ],
            ),
          ),
          
          // Chat Area
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, _) {
                final history = provider.chatHistory;
                if (history.isEmpty) {
                   return Center(
                     child: Text("Start a conversation with your AI Coach...", style: TextStyle(color: AppTheme.textSecondary)),
                   );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(32),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final msg = history[index];
                    return _buildMessage(
                      isMe: msg.isUser,
                      text: msg.text,
                      time: msg.time,
                      sentiment: msg.sentiment,
                      recommendations: msg.recommendations,
                      isCrisis: msg.isCrisis,
                    );
                  },
                );
              }
            ),
          ),
          
          // Suggestions
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSuggestionChip('I feel anxious', () => _controller.text = "I feel anxious"),
                  const SizedBox(width: 12),
                   _buildSuggestionChip('Help me sleep', () => _controller.text = "Help me sleep"),
                   const SizedBox(width: 12),
                   _buildSuggestionChip('Motivate me', () => _controller.text = "Motivate me"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Input
          Container(
            padding: const EdgeInsets.all(32),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mood, color: Colors.grey),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type your thoughts here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : Colors.grey),
                    onPressed: _listen,
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.send, color: Colors.black, size: 20),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMessage({
    required bool isMe, 
    required String text, 
    required String time, 
    String? sentiment, 
    String? recommendations,
    bool isCrisis = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
             const CircleAvatar(
               backgroundColor: AppTheme.surface, 
               child: Icon(Icons.smart_toy, color: AppTheme.primary)
             ),
             const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(isMe ? 'You' : 'Emoticare Assistant', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Text(time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    if (!isMe)
                      IconButton(
                        icon: const Icon(Icons.volume_up, size: 16, color: Colors.grey),
                        onPressed: () => _speak(text),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isCrisis ? Colors.red.withOpacity(0.2) : (isMe ? AppTheme.primary : AppTheme.surface),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : const Radius.circular(20),
                    ),
                    border: isCrisis ? Border.all(color: Colors.red) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(text, style: TextStyle(color: isMe ? Colors.black : Colors.white, height: 1.5)),
                      if (recommendations != null && recommendations.isNotEmpty) ...[
                         const SizedBox(height: 12),
                         Container(
                           padding: const EdgeInsets.all(12),
                           decoration: BoxDecoration(
                             color: Colors.black.withOpacity(0.2),
                             borderRadius: BorderRadius.circular(10)
                           ),
                           child: Row(
                             children: [
                               const Icon(Icons.lightbulb_outline, size: 16, color: AppTheme.accentYellow),
                               const SizedBox(width: 8),
                               Expanded(child: Text("Suggestion: $recommendations", style: const TextStyle(fontSize: 12, color: AppTheme.accentYellow))),
                             ],
                           ),
                         )
                      ],
                      if (sentiment != null && sentiment.isNotEmpty) ...[
                         const SizedBox(height: 8),
                         Text("Feeling detected: $sentiment", style: TextStyle(fontSize: 10, color: (isMe ? Colors.black : Colors.white).withOpacity(0.5), fontStyle: FontStyle.italic)),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 12),
             const CircleAvatar(
               backgroundColor: AppTheme.surface,
               child: Icon(Icons.person, color: Colors.white),
             ),
          ]
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
