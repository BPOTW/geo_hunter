import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/puzzle_card.dart';

// Color palette (vibrant version)
const Color kPrimary = Color(0xFF4A6CF7);
const Color kAccent = Color(0xFF56CCF2);
const Color kSoftBg = Color(0xFFF0F3FF); // slightly bluish background
const Color kCardBg = Color(0xFFFDFDFE); // softer white
const Color kMutedText = Color(0xFF596273);
const Color kHighlight = Color(0xFFEEF3FF); // for cards

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _annController = PageController(viewportFraction: 0.9);
  int _annIndex = 0;
  Timer? _annTimer;

  @override
  void initState() {
    super.initState();
    // Auto-scroll announcements
    _annTimer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (_annController.hasClients) {
        final next = (_annIndex + 1) % _annItems.length;
        _annController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
    _annController.addListener(() {
      final idx = _annController.page?.round() ?? 0;
      if (idx != _annIndex) setState(() => _annIndex = idx);
    });
  }

  @override
  void dispose() {
    _annTimer?.cancel();
    _annController.dispose();
    super.dispose();
  }

  // (moved color constants to file scope)

  // sample announcements
  final List<String> _annItems = [
    "New weekly challenge: Solve 5 puzzles to earn 200 bonus coins!",
    "Double rewards weekend starts Friday — be ready!",
    "Puzzle Creator Contest: Win a feature spot and 1000 coins.",
  ];

  // sample puzzles
  final List<Map<String, dynamic>> activePuzzles = [
    {
      'title': 'Hidden Lake Trail',
      'reward': 150,
      'negativePoints': 100,
      'difficulty': 'Medium',
      'category': 'Nature',
      'creator': 'Zain Ali',
      'players': 128,
      'progress': 0.45,
      'timeLeft': '2h 15m',
      'status': 'Active',
      'isActive': true,
    },
    {
      'title': 'Old Town Mystery',
      'reward': 200,
      'negativePoints': 90,
      'difficulty': 'Hard',
      'category': 'Urban',
      'creator': 'GeoMaster',
      'players': 215,
      'progress': 0.2,
      'timeLeft': '5h 10m',
      'status': 'Active',
      'isActive': true,
    },
  ];

  final List<Map<String, dynamic>> newPuzzles = [
    {
      'title': 'Riverside Route',
      'reward': 75,
      'negativePoints': 20,
      'difficulty': 'Easy',
      'category': 'Nature',
      'creator': 'ExplorerX',
      'players': 90,
      'status': 'New',
      'isActive': false,
    },
    {
      'title': 'Market Maze',
      'reward': 120,
      'negativePoints': 40,
      'difficulty': 'Medium',
      'category': 'Urban',
      'creator': 'PuzzlePro',
      'players': 145,
      'status': 'New',
      'isActive': false,
    },
    {
      'title': 'Hilltop Riddle',
      'reward': 180,
      'negativePoints': 60,
      'difficulty': 'Hard',
      'category': 'Hiking',
      'creator': 'GeoGuru',
      'players': 178,
      'status': 'New',
      'isActive': false,
    },
  ];

  final List<Map<String, dynamic>> _topLeaders = [
    {'name': 'Ayesha', 'points': 1900},
    {'name': 'Ali', 'points': 1720},
    {'name': 'Zain', 'points': 1650},
    {'name': 'Sarah', 'points': 1510},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSoftBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCompactStats(),
                    const SizedBox(height: 14),
                    _buildAnnouncements(),
                    const SizedBox(height: 18),
                    _sectionTitle("Your Active Puzzles"),
                    const SizedBox(height: 8),
                    _horizontalCards(activePuzzles),
                    const SizedBox(height: 18),
                    _sectionTitle("New Puzzles"),
                    const SizedBox(height: 8),
                    _horizontalCards(newPuzzles),
                    const SizedBox(height: 22),
                    _sectionTitle("Top Players"),
                    const SizedBox(height: 8),
                    _buildTop3LeaderPodium(_topLeaders),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 14),
                        ),
                        child: const Text(
                          "View Full Leaderboard",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- UI Components --------------------

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimary, kAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: kPrimary, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Geo Finder",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 2),
                Text(
                  "Zain Explorer • Level 4",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.stars, color: Colors.white, size: 18),
                SizedBox(width: 6),
                Text(
                  "1250",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No new notifications")),
              );
            },
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncements() {
    return SizedBox(
      height: 90,
      child: PageView.builder(
        controller: _annController,
        itemCount: _annItems.length,
        itemBuilder: (context, index) {
          final text = _annItems[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  kPrimary.withOpacity(0.1),
                  kAccent.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.campaign, color: kPrimary, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF223254),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompactStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _coloredBadge("Solved", "32", kPrimary.withOpacity(0.12), kPrimary),
        _coloredBadge("Uploaded", "3", kAccent.withOpacity(0.12), kAccent),
        _coloredBadge("Wins", "7", const Color(0xFF00C853).withOpacity(0.12),
            const Color(0xFF00C853)),
        _coloredBadge("Streak", "3d", Colors.orange.withOpacity(0.12),
            Colors.orangeAccent),
      ],
    );
  }

  Widget _coloredBadge(String title, String value, Color bg, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(title,
                style: const TextStyle(fontSize: 12, color: kMutedText)),
          ],
        ),
      ),
    );
  }

  Widget _horizontalCards(List<Map<String, dynamic>> puzzles) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: puzzles.isEmpty
            ? [const Text("No puzzles available yet")]
            : puzzles.map((puzzle) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: PuzzleCard(
                    title: puzzle['title'],
                    reward: puzzle['reward'].toString(),
                    negativePoints: puzzle['negativePoints'].toString(),
                    difficulty: puzzle['difficulty'],
                    category: puzzle['category'],
                    creator: puzzle['creator'],
                    players: puzzle['players'],
                    timeLeft: puzzle['timeLeft'],
                    progress: puzzle['progress'],
                    status: puzzle['status'],
                    isActive: puzzle['isActive'],
                    onTap: () {},
                  ),
                );
              }).toList(),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF223254),
      ),
    );
  }

  Widget _buildTop3LeaderPodium(List<Map<String, dynamic>> leaders) {
    final first = leaders.isNotEmpty ? leaders[0] : {"name": "-", "points": 0};
    final second = leaders.length > 1 ? leaders[1] : {"name": "-", "points": 0};
    final third = leaders.length > 2 ? leaders[2] : {"name": "-", "points": 0};

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _leaderMiniCard(2, second['name'], second['points']),
          _leaderMiniCard(1, first['name'], first['points'], highlight: true),
          _leaderMiniCard(3, third['name'], third['points']),
        ],
      ),
    );
  }

  Widget _leaderMiniCard(int rank, String name, int points,
      {bool highlight = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: highlight ? 32 : 28,
          backgroundColor: highlight ? kPrimary : kAccent.withOpacity(0.3),
          child: Text(
            name[0],
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: highlight ? 20 : 16),
          ),
        ),
        const SizedBox(height: 8),
        Text(name,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: highlight ? kPrimary : Colors.black87)),
        Text("$points pts", style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}


/// --- PLACEHOLDER / SUPPORT SCREENS --------------------------------------

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Upload Puzzle"),
          backgroundColor: Colors.white,
        ),
        body: const Center(
          child: Text("Upload screen - implement upload form here"),
        ),
      ),
    );
  }
}

class FullLeaderboardScreen extends StatelessWidget {
  const FullLeaderboardScreen({super.key});

  final List<Map<String, dynamic>> allLeaders = const [
    {'name': 'Ayesha', 'points': 1900},
    {'name': 'Ali', 'points': 1720},
    {'name': 'Zain', 'points': 1650},
    {'name': 'Sarah', 'points': 1510},
    {'name': 'Hassan', 'points': 1400},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Leaderboard"),
          backgroundColor: Colors.white,
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: allLeaders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, idx) {
            final item = allLeaders[idx];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(child: Text(item['name'][0])),
                title: Text(item['name']),
                trailing: Text("${item['points']} pts"),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: Colors.white,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                title: const Text("Account"),
                subtitle: const Text("Manage your profile"),
              ),
            ),
            const SizedBox(height: 8),
            Card(child: ListTile(title: const Text("Notifications"))),
            const SizedBox(height: 8),
            Card(child: ListTile(title: const Text("Help & Support"))),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text("Logout"),
                onTap: () {
                  /* handle logout */
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

