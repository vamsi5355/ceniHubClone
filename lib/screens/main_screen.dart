import 'package:flutter/material.dart';
import '../data/profiles_data.dart';
import '../models/models.dart';
import 'home/home_page.dart';
import 'messages/messages_page.dart';
import 'notifications/notifications_page.dart';
import 'AI/ai.dart';
import 'projects/projects_page.dart';
import 'profile/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // ── Shared state ─────────────────────────────────────────────────────
  final Set<int> _bookmarked = {};
  final Set<int> _collaborated = {0, 2}; // seeded for demo
  final Map<String, List<ChatMessage>> _conversations = {};

  @override
  void initState() {
    super.initState();
    _seedConversation(kAllProfiles[0], [
      ChatMessage(
          id: '1',
          text: 'Hey! Thanks for the collaboration request 🎬',
          isSent: false,
          time: _ago(120),
          isRead: true),
      ChatMessage(
          id: '2',
          text: 'Would love to work on your next project!',
          isSent: false,
          time: _ago(118),
          isRead: true),
      ChatMessage(
          id: '3',
          text: 'Absolutely! I was thinking a short documentary.',
          isSent: true,
          time: _ago(115),
          isRead: true),
      ChatMessage(
          id: '4',
          text: 'That sounds amazing. When are you thinking?',
          isSent: false,
          time: _ago(100),
          isRead: true),
      ChatMessage(
          id: '5',
          text: 'Maybe late July? We can plan a recce first.',
          isSent: true,
          time: _ago(90),
          isRead: true),
      ChatMessage(
          id: '6',
          text: 'Perfect. I\'ll keep those dates free 👍',
          isSent: false,
          time: _ago(10),
          isRead: false),
    ]);
    _seedConversation(kAllProfiles[2], [
      ChatMessage(
          id: '1',
          text: 'Hi! Saw your collaboration request. Interested!',
          isSent: false,
          time: _ago(300),
          isRead: true),
      ChatMessage(
          id: '2',
          text: 'Great to hear. I need a lead for a thriller.',
          isSent: true,
          time: _ago(290),
          isRead: true),
      ChatMessage(
          id: '3',
          text: 'Thriller is my favourite genre 😄',
          isSent: false,
          time: _ago(285),
          isRead: true),
      ChatMessage(
          id: '4',
          text: 'Script will be ready by end of month.',
          isSent: true,
          time: _ago(280),
          isRead: true),
      ChatMessage(
          id: '5',
          text: 'Excited to read it! 🎭',
          isSent: false,
          time: _ago(60),
          isRead: false),
    ]);
  }

  DateTime _ago(int minutes) =>
      DateTime.now().subtract(Duration(minutes: minutes));

  void _seedConversation(ProfileData p, List<ChatMessage> msgs) {
    _conversations[p.name] = msgs;
  }

  void _toggleBookmark(int index) {
    setState(() {
      _bookmarked.contains(index)
          ? _bookmarked.remove(index)
          : _bookmarked.add(index);
    });
  }

  void _addCollaboration(int index) {
    setState(() => _collaborated.add(index));
    final profile = kAllProfiles[index];
    if (!_conversations.containsKey(profile.name)) {
      _conversations[profile.name] = [
        ChatMessage(
          id: '1',
          text: 'Hi! I received your collaboration request 🙌',
          isSent: false,
          time: DateTime.now(),
          isRead: false,
        ),
      ];
    }
  }

  void _onSendMessage(String profileName, ChatMessage msg) {
    setState(() {
      _conversations[profileName] ??= [];
      _conversations[profileName]!.add(msg);
    });
  }

  int get _unreadMessageCount {
    int count = 0;
    for (final msgs in _conversations.values) {
      count += msgs.where((m) => !m.isSent && !m.isRead).length;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // ── Home: pass allProfiles for search + messages nav + unread count ──
      HomePage(
        allProfiles: kAllProfiles,
        onNavigateToMessages: () => setState(() => _currentIndex = 3),
        unreadMessages: _unreadMessageCount,
      ),
      ProjectsPage(
        allProfiles: kAllProfiles,
        bookmarked: _bookmarked,
        collaborated: _collaborated,
        onBookmark: _toggleBookmark,
        onCollaborate: _addCollaboration,
      ),
      const AIPage(),
      MessagesPage(
        allProfiles: kAllProfiles,
        collaborated: _collaborated,
        conversations: _conversations,
        onSendMessage: _onSendMessage,
      ),
      ProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: 72,
        decoration: BoxDecoration(
          color: const Color(0xff111111),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(icon: Icons.home_rounded, label: "Home", index: 0),
            _navItem(
                icon: Icons.movie_creation_outlined,
                label: "Projects",
                index: 1),
            _navItem(
                icon: Icons.auto_awesome_outlined,
                label: "AI",
                index: 2),
            _navItem(
                icon: Icons.message_outlined,
                label: "Messages",
                index: 3,
                badge: _unreadMessageCount),
            _navItem(
                icon: Icons.person_outline_rounded,
                label: "Profile",
                index: 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
    int badge = 0,
  }) {
    final bool sel = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: sel
                  ? const LinearGradient(
                      colors: [Color(0xffFF8C00), Color(0xffFF3D00)])
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white),
                if (sel) ...[
                  const SizedBox(width: 6),
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ],
            ),
          ),
          if (badge > 0)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffFF3D00),
                ),
                child: Center(
                  child: Text('$badge',
                      style: const TextStyle(
                          fontSize: 9, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}