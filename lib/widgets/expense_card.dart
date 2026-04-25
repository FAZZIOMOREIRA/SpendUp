import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../utils/constants.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onDelete;
  final bool compact;

  const ExpenseCard({
    super.key,
    required this.expense,
    this.onDelete,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Revenus : icône et couleur spéciales
    final isIncome = expense.isIncome;
    final incomeColor = const Color(0xFF00C6AE);
    final category = isIncome
        ? CategoryData(
            id: 'income',
            name: 'Revenu',
            icon: Icons.arrow_downward_rounded,
            color: incomeColor,
          )
        : getCategoryById(expense.categoryId);

    return Dismissible(
      key: Key(expense.id),
      direction: onDelete != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B5C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 26),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        padding: EdgeInsets.all(compact ? 12 : 14),
        decoration: BoxDecoration(
          color: isIncome
              ? incomeColor.withOpacity(isDark ? 0.12 : 0.06)
              : (isDark ? const Color(0xFF221E3A) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: isIncome
              ? Border.all(color: incomeColor.withOpacity(0.25))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: compact ? 42 : 48,
              height: compact ? 42 : 48,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(category.icon,
                  color: category.color, size: compact ? 20 : 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: compact ? 13 : 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: category.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          category.name,
                          style: TextStyle(
                            color: category.color,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd MMM', 'fr_FR').format(expense.date),
                        style:
                            TextStyle(color: Colors.grey.shade500, fontSize: 11),
                      ),
                    ],
                  ),
                  if (expense.note.isNotEmpty && !compact) ...[
                    const SizedBox(height: 3),
                    Text(
                      expense.note,
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Text(
              isIncome
                  ? '+${NumberFormat('#,###', 'fr_FR').format(expense.amount)}'
                  : '-${NumberFormat('#,###', 'fr_FR').format(expense.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: compact ? 13 : 15,
                color: isIncome
                    ? const Color(0xFF00C6AE)
                    : const Color(0xFFFF3B5C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
