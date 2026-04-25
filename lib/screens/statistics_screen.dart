import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildTabBar(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPieView(context),
                  _buildBarView(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques',
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

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF221E3A)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: const Color(0xFF5B4FFF),
            borderRadius: BorderRadius.circular(10),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          dividerColor: Colors.transparent,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'Camembert'),
            Tab(text: 'Barres'),
          ],
        ),
      ),
    );
  }

  // ─── Pie Chart View ──────────────────────────────────────────────────────────

  Widget _buildPieView(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final byCategory = provider.expensesByCategory;
    final total = provider.totalThisMonth;

    if (byCategory.isEmpty) return _buildNoData();

    final sections = byCategory.entries.map((entry) {
      final cat = getCategoryById(entry.key);
      final index = byCategory.keys.toList().indexOf(entry.key);
      final isTouched = index == _touchedIndex;
      final percent = total > 0 ? (entry.value / total * 100) : 0.0;

      return PieChartSectionData(
        value: entry.value,
        color: cat.color,
        title: isTouched ? '${percent.toStringAsFixed(1)}%' : '',
        radius: isTouched ? 80 : 65,
        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        badgeWidget: isTouched
            ? Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: cat.color.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(cat.icon, color: cat.color, size: 16),
              )
            : null,
        badgePositionPercentageOffset: 1.1,
      );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 260,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 3,
                centerSpaceRadius: 55,
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response?.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex = response!
                          .touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
              ),
            ),
          ),
          // Centre label
          const SizedBox(height: 8),
          Text(
            'Total: ${NumberFormat('#,###', 'fr_FR').format(total)} $kCurrency',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 20),
          _buildLegend(context, byCategory, total),
        ],
      ),
    );
  }

  Widget _buildLegend(
    BuildContext context,
    Map<String, double> byCategory,
    double total,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sorted = byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: sorted.map((entry) {
          final cat = getCategoryById(entry.key);
          final percent = total > 0 ? entry.value / total : 0.0;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF221E3A) : Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: cat.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(cat.icon, color: cat.color, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cat.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ),
                Text(
                  '${(percent * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: cat.color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${NumberFormat('#,###', 'fr_FR').format(entry.value)}',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Bar Chart View ──────────────────────────────────────────────────────────

  Widget _buildBarView(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final expenses = provider.expenses;

    // Regrouper par semaine du mois courant
    final now = DateTime.now();
    final weeks = <int, double>{1: 0, 2: 0, 3: 0, 4: 0};
    for (final e in expenses) {
      if (e.date.year == now.year && e.date.month == now.month) {
        final week = ((e.date.day - 1) ~/ 7) + 1;
        weeks[week] = (weeks[week] ?? 0) + e.amount;
      }
    }

    final maxY = weeks.values.isEmpty
        ? 100000.0
        : weeks.values.reduce((a, b) => a > b ? a : b) * 1.2;

    final barGroups = weeks.entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value,
            gradient: const LinearGradient(
              colors: [Color(0xFF5B4FFF), Color(0xFF7868FF)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 28,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: maxY,
              color: const Color(0xFF5B4FFF).withOpacity(0.07),
            ),
          ),
        ],
      );
    }).toList();

    if (barGroups.isEmpty) return _buildNoData();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dépenses par semaine',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.1),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final labels = ['', 'Sem 1', 'Sem 2', 'Sem 3', 'Sem 4'];
                        final idx = value.toInt();
                        if (idx < 1 || idx > 4) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            labels[idx],
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 55,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          NumberFormat('#,###', 'fr_FR').format(value),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF3D30FF),
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${NumberFormat('#,###', 'fr_FR').format(rod.toY)} $kCurrency',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildWeekSummary(context, weeks),
        ],
      ),
    );
  }

  Widget _buildWeekSummary(BuildContext context, Map<int, double> weeks) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labels = {1: 'Semaine 1', 2: 'Semaine 2', 3: 'Semaine 3', 4: 'Semaine 4'};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détail hebdomadaire',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 12),
        ...weeks.entries.map((e) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF221E3A) : Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B4FFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.calendar_view_week_rounded,
                          color: Color(0xFF5B4FFF), size: 16),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      labels[e.key] ?? 'Sem ${e.key}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Text(
                  '${NumberFormat('#,###', 'fr_FR').format(e.value)} $kCurrency',
                  style: const TextStyle(
                    color: Color(0xFFFF3B5C),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildNoData() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_rounded, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Pas encore de données',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
