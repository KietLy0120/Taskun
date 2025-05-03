import 'package:flutter/material.dart';
import '../models/battle_log.dart';

class BattleLogWidget extends StatelessWidget {
  final List<BattleLog> logs;
  final ScrollController scrollController;
  final bool showTimestamp;  // New optional parameter

  const BattleLogWidget({
    super.key,
    required this.logs,
    required this.scrollController,
    this.showTimestamp = false,  // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      height: 140,  // Slightly increased height
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),  // More opaque
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BATTLE LOG',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 18, color: Colors.white70),
                  onPressed: () {},  // Add your close functionality
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Log entries
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bullet point
                        Padding(
                          padding: const EdgeInsets.only(top: 2, right: 4),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: log.color.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        // Message with optional timestamp
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                if (showTimestamp)
                                  TextSpan(
                                    text: '[${_formatTime(log.timestamp)}] ',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                TextSpan(
                                  text: log.message,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,  // Slightly smaller
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}