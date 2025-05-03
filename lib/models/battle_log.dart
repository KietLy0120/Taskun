import 'package:flutter/material.dart';

class BattleLog {
  @override
  String toString() {
    return 'BattleLog{message: $message, color: $color, timestamp: $timestamp}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BattleLog &&
              runtimeType == other.runtimeType &&
              message == other.message &&
              color == other.color &&
              timestamp == other.timestamp;

  @override
  int get hashCode => message.hashCode ^ color.hashCode ^ timestamp.hashCode;

  final String message;
  final Color color;
  final DateTime timestamp;

  BattleLog(this.message, this.color, {DateTime? time})
      : timestamp = time ?? DateTime.now();
}

