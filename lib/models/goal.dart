import 'dart:convert';

class Goal {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final String emoji;
  final int colorValue;
  final DateTime? deadline;

  Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.emoji,
    required this.colorValue,
    this.deadline,
  });

  double get progress => targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  double get remaining => (targetAmount - savedAmount).clamp(0.0, targetAmount);
  bool get isCompleted => savedAmount >= targetAmount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'emoji': emoji,
      'colorValue': colorValue,
      'deadline': deadline?.toIso8601String(),
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      targetAmount: (map['targetAmount'] as num).toDouble(),
      savedAmount: (map['savedAmount'] as num).toDouble(),
      emoji: map['emoji'] ?? '🎯',
      colorValue: map['colorValue'] ?? 0xFF5B4FFF,
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
    );
  }

  String toJson() => json.encode(toMap());
  factory Goal.fromJson(String source) => Goal.fromMap(json.decode(source));

  Goal copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? savedAmount,
    String? emoji,
    int? colorValue,
    DateTime? deadline,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      emoji: emoji ?? this.emoji,
      colorValue: colorValue ?? this.colorValue,
      deadline: deadline ?? this.deadline,
    );
  }
}
