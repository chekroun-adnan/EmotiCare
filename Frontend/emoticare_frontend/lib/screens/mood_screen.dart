import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({Key? key}) : super(key: key);

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  double _intensity = 5;
  String _selectedMood = 'Happy';
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> _moods = [
    {'name': 'Awful', 'icon': FontAwesomeIcons.faceDizzy},
    {'name': 'Bad', 'icon': FontAwesomeIcons.faceFrown},
    {'name': 'Okay', 'icon': FontAwesomeIcons.faceMeh},
    {'name': 'Good', 'icon': FontAwesomeIcons.faceSmile},
    {'name': 'Great', 'icon': FontAwesomeIcons.faceGrinBeam},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Text('Mood Tracker', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('How are you feeling today, Alex?', style: TextStyle(color: AppTheme.textSecondary, fontSize: 18)),
          const SizedBox(height: 32),

          // Mood Input Card
          DashboardCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select your mood', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 24),
                // Mood Icons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _moods.map((mood) {
                      final isSelected = _selectedMood == mood['name'];
                      return GestureDetector(
                        onTap: () => setState(() => _selectedMood = mood['name']),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.primary : AppTheme.background,
                                  shape: BoxShape.circle,
                                  boxShadow: isSelected ? [BoxShadow(color: AppTheme.primary.withOpacity(0.5), blurRadius: 10)] : [],
                                ),
                                child: Icon(mood['icon'], color: isSelected ? Colors.black : Colors.grey, size: 32),
                              ),
                              const SizedBox(height: 8),
                              Text(mood['name'], style: TextStyle(color: isSelected ? Colors.white : Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 32),
                
                // Intensity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Intensity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('${_intensity.toInt()} / 10', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 16),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppTheme.primary,
                    inactiveTrackColor: AppTheme.background,
                    thumbColor: Colors.white,
                    overlayColor: AppTheme.primary.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: _intensity,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (val) => setState(() => _intensity = val),
                  ),
                ),
                
                const SizedBox(height: 32),
                const Text('Add a note (optional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 16),
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.background,
                    hintText: "What's on your mind?...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Provider.of<AppProvider>(context, listen: false).trackMood...
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mood logged!')));
                      _noteController.clear();
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Log Mood'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          const Text('Recent Entries', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          
          // Recent Entries List
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              if (provider.moods.isEmpty) {
                 return const Center(child: Padding(
                     padding: EdgeInsets.all(32.0),
                     child: Text("No moods logged yet.", style: TextStyle(color: AppTheme.textSecondary)),
                   ));
              }
              // Render list items directly in the main ListView
              return Column(
                children: provider.moods.map((mood) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Row(
                      children: [
                         Container(
                           padding: const EdgeInsets.all(8),
                           decoration: const BoxDecoration(color: AppTheme.background, shape: BoxShape.circle),
                           child: const Icon(Icons.mood, color: AppTheme.primary), 
                         ),
                         const SizedBox(width: 16),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(mood.mood, style: const TextStyle(fontWeight: FontWeight.bold)),
                               Text(mood.timestamp != null ? mood.timestamp.toString().substring(0, 16) : 'Just now', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                               if (mood.note != null && mood.note!.isNotEmpty)
                                 Padding(
                                   padding: const EdgeInsets.only(top: 4.0),
                                   child: Text(mood.note!, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                                 )
                             ],
                           ),
                         )
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
