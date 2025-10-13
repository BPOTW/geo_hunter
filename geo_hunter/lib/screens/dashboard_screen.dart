import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/puzzle_card.dart';

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
    return SafeArea(
      child: Column(
        children: [
          // Custom top bar with integrated profile & quick info
          _buildTopBar(context),

          // main content scroll area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // compact stats badges (redundant with topbar but keeps visibility)
                  _buildCompactStats(),

                  const SizedBox(height: 14),

                  // Announcements carousel
                  _buildAnnouncements(),

                  const SizedBox(height: 18),

                  // Active puzzles
                  _sectionTitle("Your Active Puzzles"),
                  const SizedBox(height: 8),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: activePuzzles.map((puzzle) {
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
                            onTap: () {
                              print("${puzzle} tapped");
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // New puzzles
                  _sectionTitle("New Puzzles"),
                  const SizedBox(height: 8),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: newPuzzles.map((puzzle) {
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
                            onTap: () {
                              print("${puzzle} tapped");
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Leaderboard (Top 3 only) anchored near bottom
                  _sectionTitle("Top Players"),
                  const SizedBox(height: 8),
                  _buildTop3LeaderPodium(_topLeaders),

                  const SizedBox(height: 20),

                  // CTA: View full leaderboard
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // navigate to full leaderboard page inside shell:
                        // we use a root Navigator pop+push via BottomNavigationBar in MainShell in real app.
                        // Here we simply show a new screen.
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FullLeaderboardScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6CF7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("View Full Leaderboard"),
                    ),
                  ),

                  const SizedBox(height: 40), // bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- UI Building Helpers ------------------------------------

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.06)),
        ),
      ),
      child: Row(
        children: [
          // profile avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF4A6CF7),
            child: const Icon(Icons.person, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),

          // title and rank
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Geo Finder",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  "Zain Explorer • Level 4",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          // rewards / coins
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4A6CF7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.stars, color: Color(0xFF4A6CF7), size: 18),
                SizedBox(width: 6),
                Text("1250", style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // notifications icon
          IconButton(
            onPressed: () {
              // show notifications (placeholder)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No new notifications")),
              );
            },
            icon: const Icon(Icons.notifications_none),
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
          final item = _annItems[index];
          return _announcementCard(item);
        },
      ),
    );
  }

  Widget _announcementCard(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.campaign, color: Color(0xFF4A6CF7), size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "NEW",
                style: TextStyle(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactStats() {
    // small badge-style stats
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _smallBadge(title: "Solved", value: "32"),
        _smallBadge(title: "Uploaded", value: "3"),
        _smallBadge(title: "Wins", value: "7"),
        _smallBadge(title: "Streak", value: "3d"),
      ],
    );
  }

  Widget _smallBadge({required String title, required String value}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTop3LeaderPodium(List<Map<String, dynamic>> leaders) {
    // show top 3 visually: Center is 1st, left 2nd, right 3rd
    final first = leaders.length > 0 ? leaders[0] : {'name': '—', 'points': 0};
    final second = leaders.length > 1 ? leaders[1] : {'name': '—', 'points': 0};
    final third = leaders.length > 2 ? leaders[2] : {'name': '—', 'points': 0};

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _leaderMiniCard(
              rank: 2,
              name: second['name'],
              points: second['points'],
            ),
            _leaderMiniCard(
              rank: 1,
              name: first['name'],
              points: first['points'],
              highlight: true,
            ),
            _leaderMiniCard(
              rank: 3,
              name: third['name'],
              points: third['points'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _leaderMiniCard({
    required int rank,
    required String name,
    required int points,
    bool highlight = false,
  }) {
    final colors = highlight ? Colors.amber : Colors.grey.shade200;
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            CircleAvatar(
              radius: highlight ? 32 : 26,
              backgroundColor: highlight
                  ? const Color(0xFF4A6CF7)
                  : Colors.grey.shade200,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: highlight ? Colors.white : Colors.black87,
                  fontSize: highlight ? 20 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              right: -6,
              top: -6,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: colors,
                child: Text(
                  "#$rank",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: highlight ? Colors.black87 : Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
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
