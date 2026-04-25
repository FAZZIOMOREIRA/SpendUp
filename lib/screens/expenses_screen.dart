import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../widgets/expense_card.dart';
import '../utils/constants.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  // 'all' | 'expenses' | 'incomes' | <categoryId>
  String _selectedFilter = 'all';
  bool _fabExpanded = false;

  List<Expense> _filteredExpenses(List<Expense> all) {
    if (_selectedFilter == 'all') return all;
    if (_selectedFilter == 'expenses') return all.where((e) => !e.isIncome).toList();
    if (_selectedFilter == 'incomes') return all.where((e) => e.isIncome).toList();
    return all.where((e) => !e.isIncome && e.categoryId == _selectedFilter).toList();
  }

  Map<String, List<Expense>> _groupByDate(List<Expense> expenses) {
    final map = <String, List<Expense>>{};
    for (final e in expenses) {
      final key = DateFormat('yyyy-MM-dd').format(e.date);
      map.putIfAbsent(key, () => []).add(e);
    }
    return map;
  }

  String _formatDateGroup(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final target = DateTime(date.year, date.month, date.day);

    if (target == today) return "Aujourd'hui";
    if (target == yesterday) return 'Hier';
    return DateFormat('EEEE dd MMMM', 'fr_FR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final sorted = provider.expensesSorted;
    final filtered = _filteredExpenses(sorted);
    final grouped = _groupByDate(filtered);
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, provider),
            _buildFilterTabs(context),
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 90),
                      itemCount: sortedKeys.length,
                      itemBuilder: (_, i) {
                        final dateKey = sortedKeys[i];
                        final items = grouped[dateKey]!;

                        final dayExpenses = items
                            .where((e) => !e.isIncome)
                            .fold(0.0, (s, e) => s + e.amount);
                        final dayIncomes = items
                            .where((e) => e.isIncome)
                            .fold(0.0, (s, e) => s + e.amount);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _formatDateGroup(dateKey),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if (dayIncomes > 0)
                                        Text(
                                          '+${NumberFormat('#,###', 'fr_FR').format(dayIncomes)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Color(0xFF00C6AE),
                                          ),
                                        ),
                                      if (dayIncomes > 0 && dayExpenses > 0)
                                        Text(
                                          '  ',
                                          style: TextStyle(
                                              color: Colors.grey.shade400),
                                        ),
                                      if (dayExpenses > 0)
                                        Text(
                                          '-${NumberFormat('#,###', 'fr_FR').format(dayExpenses)} $kCurrency',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Color(0xFFFF3B5C),
                                          ),
                                        ),
                                      if (dayIncomes > 0 && dayExpenses == 0)
                                        Text(
                                          ' $kCurrency',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Color(0xFF00C6AE),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            ...items.map((e) => ExpenseCard(
                                  expense: e,
                                  onDelete: () => context
                                      .read<ExpenseProvider>()
                                      .deleteExpense(e.id),
                                )),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(context, isDark),
    );
  }

  Widget _buildFab(BuildContext context, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_fabExpanded) ...[
          _FabAction(
            label: 'Ajouter un revenu',
            icon: Icons.arrow_downward_rounded,
            color: const Color(0xFF00C6AE),
            onTap: () {
              setState(() => _fabExpanded = false);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const AddExpenseScreen(startAsIncome: true)),
              );
            },
          ),
          const SizedBox(height: 10),
          _FabAction(
            label: 'Ajouter une dépense',
            icon: Icons.arrow_upward_rounded,
            color: const Color(0xFF5B4FFF),
            onTap: () {
              setState(() => _fabExpanded = false);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AddExpenseScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
        FloatingActionButton(
          onPressed: () => setState(() => _fabExpanded = !_fabExpanded),
          backgroundColor: _fabExpanded
              ? Colors.grey.shade600
              : const Color(0xFF5B4FFF),
          child: AnimatedRotation(
            turns: _fabExpanded ? 0.125 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              _fabExpanded ? Icons.close_rounded : Icons.add_rounded,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, ExpenseProvider provider) {
    final totalExpenses = provider.totalThisMonth;
    final totalIncomes = provider.totalIncomeThisMonth;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transactions',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _SummaryChip(
                label: 'Dépenses',
                amount: totalExpenses,
                color: const Color(0xFFFF3B5C),
                prefix: '-',
              ),
              const SizedBox(width: 10),
              _SummaryChip(
                label: 'Revenus',
                amount: totalIncomes,
                color: const Color(0xFF00C6AE),
                prefix: '+',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context) {
    final expenseFilters = [
      ('all', 'Tout', Icons.grid_view_rounded, const Color(0xFF5B4FFF)),
      ('expenses', 'Dépenses', Icons.arrow_upward_rounded, const Color(0xFFFF3B5C)),
      ('incomes', 'Revenus', Icons.arrow_downward_rounded, const Color(0xFF00C6AE)),
      ...kCategories.map((c) => (c.id, c.name, c.icon, c.color)),
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: expenseFilters.length,
        itemBuilder: (_, i) {
          final (id, name, icon, color) = expenseFilters[i];
          final isSelected = _selectedFilter == id;

          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? color : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: isSelected ? Colors.white : color,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    name.split(' ').first,
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_rounded,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Aucune transaction',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur + pour ajouter',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final String prefix;

  const _SummaryChip({
    required this.label,
    required this.amount,
    required this.color,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$prefix${NumberFormat('#,###', 'fr_FR').format(amount)} $kCurrency',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FabAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _FabAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.small(
            heroTag: label,
            onPressed: onTap,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
