import 'package:flutter/material.dart';

class PuzzleCard extends StatelessWidget {
  final String title;
  final String reward;
  final String difficulty;
  final String category;
  final String? creator;
  final String? timeLeft;
  final double? progress;
  final bool isActive;
  final int? players;
  final String? negativePoints;
  final String? status;
  final VoidCallback onTap;

  const PuzzleCard({
    super.key,
    required this.title,
    required this.reward,
    required this.difficulty,
    required this.category,
    this.creator,
    this.timeLeft,
    this.progress,
    required this.isActive,
    this.players,
    this.negativePoints,
    this.status,
    required this.onTap,
  });

  Color _getDifficultyColor(String level) {
    switch (level.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: isActive ? 180 : 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row: difficulty, category, status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildTag(difficulty, _getDifficultyColor(difficulty)),
                    const SizedBox(width: 6),
                    _buildTag(category, Colors.blueGrey),
                  ],
                ),
                if (status != null) _buildTag(status!, Colors.purple.shade300),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Creator
            if (creator != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  'by $creator',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ),
            const SizedBox(height: 6),

            // Reward and Penalty Row
            Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 16,
                  color: Colors.green,
                ),
                const SizedBox(width: 4),
                Text(
                  '+$reward pts',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.remove_circle_outline,
                  size: 16,
                  color: Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  '-${negativePoints ?? "0"} pts',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Players & Time Left
            Row(
              children: [
                const Icon(
                  Icons.people_alt_outlined,
                  size: 16,
                  color: Colors.blueGrey,
                ),
                const SizedBox(width: 4),
                Text(
                  '${players ?? 0} Players',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 12),
                if (timeLeft != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeLeft!,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),

            if (isActive && progress != null)
              SizedBox(
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueAccent,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            const Spacer(),

            if (!isActive)
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onTap,
                    child: Text(
                      isActive ? "Continue" : "Start Puzzle",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
