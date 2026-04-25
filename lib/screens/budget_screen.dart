import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/expense_provider.dart';
import '../providers/budget_provider.dart';
import '../utils/constants.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildBudgetCard(context),
              const SizedBox(height: 24),
              _buildCategoryBreakdown(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditBudgetDialog(context),
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            DateFormat('MMMM yyyy', 'fr_FR').format(DateTime.now()),
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCard(BuildContext context) {
    final expProvider = context.watch<ExpenseProvider>();
    final budgetProvider = context.watch<BudgetProvider>();
    final spent = expProvider.totalThisMonth;
    final limit = budgetProvider.monthlyLimit;
    final remaining = budgetProvider.getRemainingBudget(spent);
    final percent = budgetProvider.getUsagePercent(spent);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: percent > 0.85
                ? [const Color(0xFFFF3B5C), const Color(0xFFFF6B8A)]
                : [const Color(0xFF3D30FF), const Color(0xFF7868FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (percent > 0.85
                      ? const Color(0xFFFF3B5C)
                      : const Color(0xFF5B4FFF))
                  .withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget mensuel',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(percent * 100).toInt()}% utilisé',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${NumberFormat('#,###', 'fr_FR').format(limit)} $kCurrency',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 20),

            // Barre de progression
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: percent),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BudgetInfoItem(
                  label: 'Dépensé',
                  amount: spent,
                  icon: Icons.arrow_upward_rounded,
                ),
                _BudgetInfoItem(
                  label: 'Restant',
                  amount: remaining,
                  icon: Icons.savings_rounded,
                  highlight: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context) {
    final expProvider = context.watch<ExpenseProvider>();
    final budgetProvider = context.watch<BudgetProvider>();
    final byCategory = expProvider.expensesByCategory;
    final limit = budgetProvider.monthlyLimit;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (byCategory.isEmpty) return const SizedBox.shrink();

    final sorted = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Répartition par catégorie',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        ...sorted.map((entry) {
          final cat = getCategoryById(entry.key);
          final percent = limit > 0 ? entry.value / limit : 0.0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF221E3A) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: cat.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(cat.icon, color: cat.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cat.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${NumberFormat('#,###', 'fr_FR').format(entry.value)} $kCurrency',
                              style: TextStyle(
                                color: cat.color,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: percent.clamp(0.0, 1.0)),
                            duration: const Duration(milliseconds: 800),
                            builder: (_, v, __) => LinearProgressIndicator(
                              value: v,
                              minHeight: 5,
                              backgroundColor: cat.color.withOpacity(0.1),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(cat.color),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${(percent * 100).toStringAsFixed(1)}% du budget',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showEditBudgetDialog(BuildContext context) {
    final budgetProvider = context.read<BudgetProvider>();
    final limitCtrl = TextEditingController(
        text: budgetProvider.monthlyLimit.toInt().toString());
    final incomeCtrl = TextEditingController(
        text: budgetProvider.monthlyIncome.toInt().toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Modifier le budget',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: incomeCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Revenu mensuel ($kCurrency)',
                  prefixIcon: const Icon(Icons.attach_money_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: limitCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Budget limite ($kCurrency)',
                  prefixIcon: const Icon(Icons.account_balance_wallet_rounded),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final income = double.tryParse(incomeCtrl.text) ??
                        budgetProvider.monthlyIncome;
                    final limit = double.tryParse(limitCtrl.text) ??
                        budgetProvider.monthlyLimit;
                    budgetProvider.updateBudget(
                      monthlyIncome: income,
                      monthlyLimit: limit,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Enregistrer'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetInfoItem extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final bool highlight;

  const _BudgetInfoItem({
    required this.label,
    required this.amount,
    required this.icon,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.7), size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
            Text(
              '${NumberFormat('#,###', 'fr_FR').format(amount)} $kCurrency',
              style: TextStyle(
                color: Colors.white,
                fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
