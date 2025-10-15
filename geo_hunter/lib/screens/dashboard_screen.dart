import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/puzzle_card.dart';

// Enhanced Color palette
const Color kPrimary = Color(0xFF4A6CF7);
const Color kPrimaryDark = Color(0xFF3451D9);
const Color kAccent = Color(0xFF56CCF2);
const Color kAccentDark = Color(0xFF2EB5E5);
const Color kSuccess = Color(0xFF00D68F);
const Color kWarning = Color(0xFFFFAA00);
const Color kBackground = Color(0xFFF5F7FF);
const Color kCardBg = Color(0xFFFFFFFF);
const Color kTextPrimary = Color(0xFF192038);
const Color kTextSecondary = Color(0xFF8F9BB3);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  final PageController _annController = PageController(viewportFraction: 0.92);
  int _annIndex = 0;
  Timer? _annTimer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for stats
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    // Auto-scroll announcements
    _annTimer = Timer.periodic(const Duration(seconds: 5), (t) {
      if (_annController.hasClients) {
        final next = (_annIndex + 1) % _annItems.length;
        _annController.animateToPage(
          next,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
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
    _pulseController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _annItems = [
    {
      'text': "New weekly challenge: Solve 5 puzzles to earn 200 bonus coins!",
      'icon': Icons.emoji_events,
      'gradient': [Color(0xFFFFD700), Color(0xFFFFA500)],
    },
    {
      'text': "Double rewards weekend starts Friday — be ready!",
      'icon': Icons.bolt,
      'gradient': [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
    },
    {
      'text': "Puzzle Creator Contest: Win a feature spot and 1000 coins.",
      'icon': Icons.star,
      'gradient': [Color(0xFF667EEA), Color(0xFF764BA2)],
    },
  ];

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
    {'name': 'Ayesha', 'points': 1900, 'avatar': 'A'},
    {'name': 'Ali', 'points': 1720, 'avatar': 'A'},
    {'name': 'Zain', 'points': 1650, 'avatar': 'Z'},
    {'name': 'Sarah', 'points': 1510, 'avatar': 'S'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kBackground,
              Color(0xFFFFFFFF).withOpacity(0.5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildEnhancedTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildEnhancedStats(),
                      const SizedBox(height: 24),
                      _buildEnhancedAnnouncements(),
                      const SizedBox(height: 28),
                      _buildSectionHeader("Your Active Puzzles", Icons.play_circle_filled, 
                        subtitle: "Continue your adventure"),
                      const SizedBox(height: 12),
                      _horizontalCards(activePuzzles),
                      const SizedBox(height: 28),
                      _buildSectionHeader("Discover New Puzzles", Icons.explore,
                        subtitle: "Fresh challenges await"),
                      const SizedBox(height: 12),
                      _horizontalCards(newPuzzles),
                      const SizedBox(height: 32),
                      _buildSectionHeader("Top Explorers", Icons.leaderboard,
                        subtitle: "Hall of fame"),
                      const SizedBox(height: 12),
                      _buildEnhancedLeaderboard(_topLeaders),
                      const SizedBox(height: 20),
                      _buildViewAllButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- Enhanced UI Components --------------------

  Widget _buildEnhancedTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kPrimary, kPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: kAccent.withOpacity(0.2),
                child: const Icon(Icons.person, color: kPrimary, size: 28),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome back! 👋",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Zain Explorer",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, color: Colors.amber, size: 22),
                const SizedBox(width: 8),
                const Text(
                  "1250",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("No new notifications"),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: kSuccess,
                        shape: BoxShape.circle,
                        border: Border.all(color: kPrimary, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedAnnouncements() {
    return Column(
      children: [
        SizedBox(
          height: 110,
          child: PageView.builder(
            controller: _annController,
            itemCount: _annItems.length,
            itemBuilder: (context, index) {
              final item = _annItems[index];
              return AnimatedBuilder(
                animation: _annController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_annController.position.haveDimensions) {
                    value = _annController.page! - index;
                    value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
                  }
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: item['gradient'],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: item['gradient'][0].withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            item['icon'],
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item['text'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _annItems.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _annIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _annIndex == index ? kPrimary : kTextSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedStats() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimary.withOpacity(0.2), kAccent.withOpacity(0.2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bar_chart_rounded, color: kPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Your Statistics",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kTextPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kSuccess.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Text(
                      "Level 4",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: kSuccess,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.verified, color: kSuccess, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 🟩 3 Cards in One Row
          Row(
            children: [
              _enhancedStatCard(
                "Solved",
                "32",
                Icons.check_circle_rounded,
                [Color(0xFF667EEA), Color(0xFF764BA2)],
                0,
              ),
              const SizedBox(width: 12),
              _enhancedStatCard(
                "Uploaded",
                "3",
                Icons.upload_rounded,
                [Color(0xFF56CCF2), Color(0xFF2F80ED)],
                100,
              ),
              const SizedBox(width: 12),
              _enhancedStatCard(
                "Wins",
                "7",
                Icons.emoji_events_rounded,
                [Color(0xFFFFA726), Color(0xFFFF7043)],
                200,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _enhancedStatCard(String label, String value, IconData icon, List<Color> colors, int delay) {
    return Expanded(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 600 + delay),
        curve: Curves.easeOutBack,
        builder: (context, double scale, child) {
          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kPrimary.withOpacity(0.2), kAccent.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: kPrimary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kTextPrimary,
                    letterSpacing: 0.3,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: kTextSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _horizontalCards(List<Map<String, dynamic>> puzzles) {
    return Container(
      
      height: 290,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: puzzles.length,
        itemBuilder: (context, index) {
          final puzzle = puzzles[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 400 + (index * 100)),
              curve: Curves.easeOutCubic,
              builder: (context, double value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedLeaderboard(List<Map<String, dynamic>> leaders) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kCardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Podium
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (leaders.length > 1) _podiumPlace(leaders[1], 2, 100),
                const SizedBox(width: 16),
                if (leaders.isNotEmpty) _podiumPlace(leaders[0], 1, 120),
                const SizedBox(width: 16),
                if (leaders.length > 2) _podiumPlace(leaders[2], 3, 80),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            // Remaining leaders
            ...leaders.skip(3).take(1).map((leader) => _leaderListItem(leader, 4)),
          ],
        ),
      ),
    );
  }

  Widget _podiumPlace(Map<String, dynamic> leader, int rank, double height) {
    final colors = rank == 1
        ? [Color(0xFFFFD700), Color(0xFFFFA500)]
        : rank == 2
            ? [Color(0xFFC0C0C0), Color(0xFFA8A8A8)]
            : [Color(0xFFCD7F32), Color(0xFFB87333)];

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: colors),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              leader['avatar'] ?? leader['name'][0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            rank == 1 ? "👑" : rank == 2 ? "🥈" : "🥉",
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          leader['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: kTextPrimary,
          ),
        ),
        Text(
          "${leader['points']} pts",
          style: TextStyle(
            color: kTextSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors.map((c) => c.withOpacity(0.3)).toList(),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _leaderListItem(Map<String, dynamic> leader, int rank) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: kTextSecondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                "$rank",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kTextSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: kAccent.withOpacity(0.2),
            child: Text(
              leader['avatar'] ?? leader['name'][0],
              style: const TextStyle(
                color: kPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              leader['name'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: kTextPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${leader['points']} pts",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewAllButton() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [kPrimary, kPrimaryDark],
          ),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "View Full Leaderboard",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- Support Screens --------------------

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Upload Puzzle"),
          backgroundColor: Colors.white,
          elevation: 0,
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
          elevation: 0,
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
          elevation: 0,
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
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}