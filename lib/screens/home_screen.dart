import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/expense_provider.dart';
import '../providers/budget_provider.dart';
import '../providers/goal_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/expense_card.dart';
import '../widgets/goal_card.dart';
import '../utils/constants.dart';
import 'add_expense_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Bonjour';
    if (h < 18) return 'Bon après-midi';
    return 'Bonsoir';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async =>
              await Future.delayed(const Duration(milliseconds: 400)),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader(context)),
              SliverToBoxAdapter(child: _buildBalanceCard(context)),
              SliverToBoxAdapter(child: _buildFinancialAlert(context)),
              SliverToBoxAdapter(child: _buildQuickStats(context)),
              SliverToBoxAdapter(child: _buildQuickActions(context)),
              SliverToBoxAdapter(child: _buildRecentTitle(context)),
              SliverToBoxAdapter(child: _buildRecentTransactions(context)),
              SliverToBoxAdapter(child: _buildGoalsSection(context)),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final user = context.watch<AuthProvider>().currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getGreeting()}, ${user?.firstName ?? ''}  👋',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
              Text(
                'SpendUp',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => themeProvider.toggleTheme(),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                    key: ValueKey(isDark),
                    color: isDark ? Colors.amber : const Color(0xFF5B4FFF),
                  ),
                ),
                style: IconButton.styleFrom(
                  backgroundColor:
                      isDark ? const Color(0xFF221E3A) : Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen())),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B4FFF), Color(0xFF7C6FFF)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      user?.initials ?? '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Carte de solde ───────────────────────────────────────────────────────────

  Widget _buildBalanceCard(BuildContext context) {
    final exp = context.watch<ExpenseProvider>();
    final budget = context.watch<BudgetProvider>();
    final totalSpent = exp.totalThisMonth;
    final extraIncome = exp.totalIncomeThisMonth;
    final balance =
        budget.getBalance(totalSpent, extraIncome: extraIncome);
    final rawBalance =
        budget.getRawBalance(totalSpent, extraIncome: extraIncome);
    final isOverdrawn = rawBalance < 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isOverdrawn
                ? [const Color(0xFFFF3B5C), const Color(0xFFFF6B8A)]
                : [
                    const Color(0xFF3D30FF),
                    const Color(0xFF5B4FFF),
                    const Color(0xFF7868FF)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (isOverdrawn
                      ? const Color(0xFFFF3B5C)
                      : const Color(0xFF5B4FFF))
                  .withOpacity(0.45),
              blurRadius: 24,
              offset: const Offset(0, 10),
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
                  'Solde disponible',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateFormat('MMMM yyyy', 'fr_FR').format(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              NumberFormat('#,###', 'fr_FR').format(balance),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            Text(
              kCurrency,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7), fontSize: 14),
            ),
            const SizedBox(height: 20),
            Container(height: 1, color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 16),
            Row(
              children: [
                _BalanceItem(
                  label: 'Revenus',
                  amount: budget.monthlyIncome + extraIncome,
                  icon: Icons.arrow_downward_rounded,
                  color: const Color(0xFF00E5C0),
                ),
                const SizedBox(width: 24),
                _BalanceItem(
                  label: 'Dépenses',
                  amount: totalSpent,
                  icon: Icons.arrow_upward_rounded,
                  color: const Color(0xFFFF6B8A),
                  isNegative: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Alerte financière intelligente ──────────────────────────────────────────

  Widget _buildFinancialAlert(BuildContext context) {
    final exp = context.watch<ExpenseProvider>();
    final budget = context.watch<BudgetProvider>();
    final totalSpent = exp.totalThisMonth;
    final extraIncome = exp.totalIncomeThisMonth;
    final alert = budget.getAlert(totalSpent, extraIncome: extraIncome);
    final usagePct = budget.getUsagePercent(totalSpent);

    if (alert == FinancialAlert.none || totalSpent == 0) {
      return const SizedBox.shrink();
    }

    _AlertStyle style;
    switch (alert) {
      case FinancialAlert.balanceExhausted:
        style = _AlertStyle(
          icon: '🛑',
          color: const Color(0xFFFF3B5C),
          bg: const Color(0xFFFF3B5C),
          title: 'Solde épuisé',
          message:
              'Votre solde est à 0 FCFA. Ajoutez des revenus ou réduisez vos dépenses.',
        );
        break;
      case FinancialAlert.budgetExceeded:
        final over = totalSpent - budget.monthlyLimit;
        style = _AlertStyle(
          icon: '🚨',
          color: const Color(0xFFFF6B00),
          bg: const Color(0xFFFF6B00),
          title: 'Budget dépassé',
          message:
              'Vous avez dépassé votre budget de ${NumberFormat('#,###', 'fr_FR').format(over)} $kCurrency. Revoyez vos dépenses !',
        );
        break;
      case FinancialAlert.nearLimit:
        style = _AlertStyle(
          icon: '⚠️',
          color: const Color(0xFFFF9500),
          bg: const Color(0xFFFF9500),
          title: 'Limite approchée',
          message:
              'Vous avez utilisé ${(usagePct * 100).toInt()}% de votre budget. Attention !',
        );
        break;
      case FinancialAlert.warning:
        style = _AlertStyle(
          icon: '💡',
          color: const Color(0xFF5B4FFF),
          bg: const Color(0xFF5B4FFF),
          title: 'Suivi en cours',
          message:
              '${(usagePct * 100).toInt()}% du budget utilisé. Restant : ${NumberFormat('#,###', 'fr_FR').format(budget.getRemainingBudget(totalSpent))} $kCurrency.',
        );
        break;
      case FinancialAlert.good:
        style = _AlertStyle(
          icon: '✅',
          color: const Color(0xFF00C6AE),
          bg: const Color(0xFF00C6AE),
          title: 'Bonne gestion',
          message:
              'Vous gérez bien votre budget ce mois. Continuez comme ça !',
        );
        break;
      case FinancialAlert.none:
        return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: style.bg.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: style.color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Text(style.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.title,
                    style: TextStyle(
                      color: style.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    style.message,
                    style: TextStyle(
                      color: style.color.withOpacity(0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Stats rapides ────────────────────────────────────────────────────────────

  Widget _buildQuickStats(BuildContext context) {
    final exp = context.watch<ExpenseProvider>();
    final budget = context.watch<BudgetProvider>();
    final totalSpent = exp.totalThisMonth;
    final remaining = budget.getRemainingBudget(totalSpent);
    final usagePct = budget.getUsagePercent(totalSpent);
    final txCount =
        exp.thisMonthExpenses.length + exp.thisMonthIncomes.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: 'Budget restant',
              value: NumberFormat('#,###', 'fr_FR').format(remaining),
              subtitle: kCurrency,
              color: usagePct > 0.8
                  ? const Color(0xFFFF3B5C)
                  : const Color(0xFF00CF8D),
              icon: Icons.account_balance_wallet_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              label: 'Transactions',
              value: '$txCount',
              subtitle: 'ce mois',
              color: const Color(0xFF5B4FFF),
              icon: Icons.receipt_rounded,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Actions rapides ──────────────────────────────────────────────────────────

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              label: 'Dépense',
              icon: Icons.arrow_upward_rounded,
              gradient: const LinearGradient(
                  colors: [Color(0xFF5B4FFF), Color(0xFF7C6FFF)]),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const AddExpenseScreen(startAsIncome: false))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              label: 'Revenu',
              icon: Icons.arrow_downward_rounded,
              gradient: const LinearGradient(
                  colors: [Color(0xFF00C6AE), Color(0xFF00E5C0)]),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const AddExpenseScreen(startAsIncome: true))),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Transactions récentes ────────────────────────────────────────────────────

  Widget _buildRecentTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Transactions récentes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          TextButton(
            onPressed: () {},
            child: const Text('Voir tout',
                style: TextStyle(fontSize: 12, color: Color(0xFF5B4FFF))),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    final all = context.watch<ExpenseProvider>().expensesSorted;
    final recent = all.take(5).toList();

    if (recent.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.receipt_long_rounded,
                  size: 52, color: Colors.grey.shade300),
              const SizedBox(height: 10),
              Text('Aucune transaction',
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                'Ajoutez votre première dépense ou revenu',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
        children: recent
            .map((e) => ExpenseCard(expense: e, compact: true))
            .toList());
  }

  // ─── Objectifs ────────────────────────────────────────────────────────────────

  Widget _buildGoalsSection(BuildContext context) {
    final goals = context.watch<GoalProvider>().goals;
    if (goals.isEmpty) return const SizedBox.shrink();
    final preview = goals.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Objectifs d\'épargne',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              TextButton(
                onPressed: () {},
                child: const Text('Voir tout',
                    style:
                        TextStyle(fontSize: 12, color: Color(0xFF5B4FFF))),
              ),
            ],
          ),
        ),
        ...preview.map((g) => GoalCard(goal: g)),
      ],
    );
  }
}

// ─── Sous-widgets ──────────────────────────────────────────────────────────────

class _AlertStyle {
  final String icon;
  final Color color;
  final Color bg;
  final String title;
  final String message;
  const _AlertStyle({
    required this.icon,
    required this.color,
    required this.bg,
    required this.title,
    required this.message,
  });
}

class _BalanceItem extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isNegative;

  const _BalanceItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 11)),
            Text(
              '${isNegative ? '-' : '+'}${NumberFormat('#,###', 'fr_FR').format(amount)}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF221E3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(value,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: color)),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.grey.shade400, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
