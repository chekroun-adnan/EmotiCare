import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';

class DigitalTwinScreen extends StatefulWidget {
  const DigitalTwinScreen({Key? key}) : super(key: key);

  @override
  State<DigitalTwinScreen> createState() => _DigitalTwinScreenState();
}

class _DigitalTwinScreenState extends State<DigitalTwinScreen> {
  final TextEditingController _textController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _speechEnabled = false;
  String _twinResponse = "Hello! I am your digital twin. How can I help you today?";
  bool _isListening = false;
  bool _isAudioInput = false;
  bool _isThinking = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
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
        }
    );
    if(mounted) setState(() {});
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _isThinking = true;
      _twinResponse = "Thinking..."; 
    });

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      if (provider.currentUser != null) {
        // Use the common sendMessage method but we'll extract the reply for the twin
        // Alternatively, we could define a specialized method in provider if needed.
        // For now, let's call the api directly or use a simplified version.
        
        final api = provider.apiService; // I need to make sure this is accessible or use a method
        // Using provider's existing sendMessage is tricky because it appends to a list we might not want to show here
        // Let's call the api directly or add a returnable sendMessage to provider.
        
        // Let's assume we want the reply.
        final response = await api.sendChatMessage(provider.currentUser!.id, text);
        
        if (mounted) {
          setState(() {
            _twinResponse = response.reply;
            _isThinking = false;
          });
          
          if (_isAudioInput) {
            _speak(_twinResponse);
          }
        }
      } else {
        throw Exception("User not logged in");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _twinResponse = "I'm having trouble connecting to my central processor. Please try again.";
          _isThinking = false;
        });
      }
    }
    
    _textController.clear();
    setState(() => _isAudioInput = false);
  }
  
  void _toggleListening() async {
    if (!_speechEnabled) {
       _speechEnabled = await _speech.initialize();
    }
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    } else {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _textController.text = val.recognizedWords;
            _isAudioInput = true;
          });
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: SizedBox.expand( // Force full size
        child: Stack(
          children: [
            // 3D Model Background/Center
            Positioned.fill(
              child: ModelViewer(
                // Use a standard test model known to work widely
                src: 'assets/models/rp_nathan_animated_003_walking.glb',
                alt: "A 3D model of your digital twin",
                ar: true,
                autoRotate: true,
                cameraControls: true,
                backgroundColor: AppTheme.background,
                loading: Loading.eager, // Force load
                disableZoom: false,
              ),
            ),
            
            // Chat Overlay
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Response Bubble
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primary)
                    ),
                    child: Row(
                      children: [
                        _isThinking 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary))
                          : const Icon(Icons.record_voice_over, color: AppTheme.primary),
                        const SizedBox(width: 12),
                        Expanded(child: Text(_twinResponse, style: const TextStyle(color: Colors.white, fontSize: 16))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Input
                  Row(
                    children: [
                      // Microphone Button
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: _isListening ? Colors.red : AppTheme.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24)
                        ),
                        child: IconButton(
                          icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.white),
                          onPressed: _toggleListening,
                        ),
                      ),
                      
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Talk to your twin...",
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: AppTheme.surface,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                          ),
                          enabled: !_isThinking,
                          onChanged: (val) {
                            if (_isAudioInput) setState(() => _isAudioInput = false);
                          },
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 16),
                       FloatingActionButton(
                        onPressed: _isThinking ? null : _sendMessage,
                        backgroundColor: _isThinking ? Colors.grey : AppTheme.primary,
                        child: _isThinking ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,)) : const Icon(Icons.send),
                      ),
                    ],
                  )
                ],
              ),
            ),
            
            // Header
             Positioned(
               top: 30,
               left: 30,
               child: Text('Digital Twin', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
             )
          ],
        ),
      ),
    );
  }
}
