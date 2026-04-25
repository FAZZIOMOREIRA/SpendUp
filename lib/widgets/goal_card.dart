import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/goal.dart';
import '../utils/constants.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF221E3A) : Colors.white;
    final goalColor = Color(goal.colorValue);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: goalColor.withOpacity(isDark ? 0.15 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Emoji icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: goalColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(goal.emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (goal.deadline != null)
                        Text(
                          'Objectif: ${DateFormat('dd MMM yyyy', 'fr_FR').format(goal.deadline!)}',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),

                // Pourcentage
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: goal.isCompleted
                        ? const Color(0xFF00CF8D).withOpacity(0.15)
                        : goalColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    goal.isCompleted
                        ? '✓ Atteint'
                        : '${(goal.progress * 100).toInt()}%',
                    style: TextStyle(
                      color: goal.isCompleted
                          ? const Color(0xFF00CF8D)
                          : goalColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),

                if (onDelete != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.grey.shade400,
                      size: 18,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Barre de progression
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: goal.progress),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    backgroundColor: goalColor.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      goal.isCompleted ? const Color(0xFF00CF8D) : goalColor,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Montants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _AmountInfo(
                  label: 'Épargné',
                  amount: goal.savedAmount,
                  color: goalColor,
                ),
                _AmountInfo(
                  label: 'Restant',
                  amount: goal.remaining,
                  color: Colors.grey.shade500,
                  isRight: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountInfo extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool isRight;

  const _AmountInfo({
    required this.label,
    required this.amount,
    required this.color,
    this.isRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
        ),
        Text(
          '${NumberFormat('#,###', 'fr_FR').format(amount)} $kCurrency',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
