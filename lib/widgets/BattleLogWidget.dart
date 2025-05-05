import 'package:flutter/material.dart';
import '../models/battle_log.dart';

class BattleLogWidget extends StatelessWidget {
  final List<BattleLog> logs;
  final ScrollController scrollController;
  final bool showTimestamp;
  final int maxVisibleLines;

  const BattleLogWidget({
    super.key,
    required this.logs,
    required this.scrollController,
    this.showTimestamp = false,
    this.maxVisibleLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    final lineHeight = 24.0;
    final headerHeight = 50.0;
    final paddingHeight = 16.0; // Vertical padding

    return Positioned(
      top: 60,
      left: 16,
      right: 16,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: headerHeight + (maxVisibleLines * lineHeight) + paddingHeight,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            SizedBox(
              height: headerHeight - 20, // Account for padding
              child: Row(
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
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Log entries
            SizedBox(
              height: maxVisibleLines * lineHeight,
              child: SingleChildScrollView(
                physics: logs.length > maxVisibleLines
                    ? const ClampingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                controller: scrollController,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: logs.map((log) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          Expanded(
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                                      fontSize: 14,
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
                  }).toList(),
                ),
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