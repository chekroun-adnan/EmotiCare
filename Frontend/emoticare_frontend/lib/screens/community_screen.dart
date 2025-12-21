import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/dashboard_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _postController = TextEditingController();

  void _createPost() {
    if (_postController.text.isEmpty) return;
    Provider.of<AppProvider>(context, listen: false).createPost(_postController.text);
    _postController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post shared!')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Community', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  const Text('Share your journey and inspire others.', style: TextStyle(color: AppTheme.textSecondary)),
                  const SizedBox(height: 32),
                  
                  // Create Post
                  DashboardCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Create a Post', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _postController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "What's on your mind?...",
                            filled: true,
                            fillColor: AppTheme.background,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _createPost,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Post'),
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text('Recent Posts', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              if (provider.communityPosts.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("No posts yet. Be the first to share!", style: TextStyle(color: AppTheme.textSecondary)),
                  )),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = provider.communityPosts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                      child: DashboardCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: AppTheme.background,
                                  child: Icon(Icons.person, color: AppTheme.textSecondary),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Anonymous Member', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(post.timestamp != null ? post.timestamp.toString().substring(0, 16) : 'Just now', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(post.text, style: const TextStyle(height: 1.5)),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(FontAwesomeIcons.heart, size: 16, color: AppTheme.textSecondary),
                                const SizedBox(width: 8),
                                const Text('Support', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                                const SizedBox(width: 24),
                                Icon(FontAwesomeIcons.comment, size: 16, color: AppTheme.textSecondary),
                                const SizedBox(width: 8),
                                const Text('Comment', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: provider.communityPosts.length,
                ),
              );
            }
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
