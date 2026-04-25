import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/goal_provider.dart';
import '../providers/expense_provider.dart';
import '../models/goal.dart';
import '../widgets/goal_card.dart';
import '../utils/constants.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goals = context.watch<GoalProvider>().goals;
    final completed = goals.where((g) => g.isCompleted).length;
    final totalSaved = goals.fold(0.0, (s, g) => s + g.savedAmount);
    final totalTarget = goals.fold(0.0, (s, g) => s + g.targetAmount);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, goals, completed, totalSaved, totalTarget),
            Expanded(
              child: goals.isEmpty
                  ? _buildEmpty()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      itemCount: goals.length,
                      itemBuilder: (_, i) => GoalCard(
                        goal: goals[i],
                        onTap: () =>
                            _showGoalDetail(context, goals[i]),
                        onDelete: () => context
                            .read<GoalProvider>()
                            .deleteGoal(goals[i].id),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGoalSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nouvel objectif'),
        backgroundColor: const Color(0xFF5B4FFF),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<Goal> goals, int completed,
      double totalSaved, double totalTarget) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overallProgress =
        totalTarget > 0 ? (totalSaved / totalTarget).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Objectifs',
            style: GoogleFonts.poppins(
                fontSize: 24, fontWeight: FontWeight.w700),
          ),
          if (goals.isNotEmpty) ...[
            Text(
              '$completed/${goals.length} atteint${completed != 1 ? 's' : ''}',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF221E3A) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF5B4FFF).withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Épargne totale',
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12)),
                          Text(
                            '${NumberFormat('#,###', 'fr_FR').format(totalSaved)} $kCurrency',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: const Color(0xFF5B4FFF),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Objectif total',
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12)),
                          Text(
                            '${NumberFormat('#,###', 'fr_FR').format(totalTarget)} $kCurrency',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: overallProgress),
                      duration: const Duration(milliseconds: 900),
                      builder: (_, v, __) => LinearProgressIndicator(
                        value: v,
                        minHeight: 8,
                        backgroundColor:
                            const Color(0xFF5B4FFF).withOpacity(0.1),
                        valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF5B4FFF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(overallProgress * 100).toInt()}% accompli',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎯', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          const Text('Aucun objectif',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            'Définissez vos objectifs d\'épargne',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _showGoalDetail(BuildContext context, Goal goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _GoalDetailSheet(goal: goal),
    );
  }

  void _showAddGoalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddGoalSheet(),
    );
  }
}

// ─── Add Goal Sheet ────────────────────────────────────────────────────────────

class _AddGoalSheet extends StatefulWidget {
  const _AddGoalSheet();

  @override
  State<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends State<_AddGoalSheet> {
  final _titleCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _savedCtrl = TextEditingController();
  final _monthlyCtrl = TextEditingController();
  String _emoji = '🎯';
  int _colorValue = 0xFF5B4FFF;

  final _emojis = [
    '🎯', '✈️', '📱', '🚗', '🏠', '💻',
    '🛡️', '🎓', '💍', '🏖️', '📚', '🚀',
  ];
  final _colors = [
    0xFF5B4FFF, 0xFF00C6AE, 0xFFFF8C42, 0xFF34C759,
    0xFFFF3B5C, 0xFFAF52DE, 0xFF007AFF, 0xFFFF9500,
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _targetCtrl.dispose();
    _savedCtrl.dispose();
    _monthlyCtrl.dispose();
    super.dispose();
  }

  Widget _buildEstimatePreview() {
    final target = double.tryParse(_targetCtrl.text) ?? 0;
    final saved = double.tryParse(_savedCtrl.text) ?? 0;
    final monthly = double.tryParse(_monthlyCtrl.text) ?? 0;
    final remaining = (target - saved).clamp(0.0, target);

    if (target <= 0 || monthly <= 0 || remaining <= 0) {
      return const SizedBox.shrink();
    }

    final months = (remaining / monthly).ceil();
    final completionDate = DateTime(
      DateTime.now().year,
      DateTime.now().month + months,
      DateTime.now().day,
    );
    final dateStr = '${completionDate.day}/${completionDate.month}/${completionDate.year}';

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(_colorValue).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(_colorValue).withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Text('📅', style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    color: Colors.grey.shade700, fontSize: 12),
                children: [
                  const TextSpan(text: 'À '),
                  TextSpan(
                    text:
                        '${NumberFormat('#,###', 'fr_FR').format(monthly)} $kCurrency/mois',
                    style: TextStyle(
                        color: Color(_colorValue),
                        fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                      text: ', objectif atteint en '),
                  TextSpan(
                    text: '$months mois',
                    style: TextStyle(
                        color: Color(_colorValue),
                        fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' (vers le $dateStr).'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
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
              const SizedBox(height: 16),
              Text(
                'Nouvel objectif',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              const Text('Icône',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _emojis.length,
                  itemBuilder: (_, i) {
                    final e = _emojis[i];
                    return GestureDetector(
                      onTap: () => setState(() => _emoji = e),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 46,
                        height: 46,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: _emoji == e
                              ? const Color(0xFF5B4FFF).withOpacity(0.15)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: _emoji == e
                              ? Border.all(
                                  color: const Color(0xFF5B4FFF), width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(e,
                              style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              const Text('Couleur',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  itemBuilder: (_, i) {
                    final c = _colors[i];
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _colorValue = c),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Color(c),
                          shape: BoxShape.circle,
                          border: _colorValue == c
                              ? Border.all(
                                  color: Color(c).withOpacity(0.5),
                                  width: 3)
                              : null,
                        ),
                        child: _colorValue == c
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 16)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'objectif',
                  prefixIcon: Icon(Icons.flag_rounded, size: 20),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _targetCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                decoration: InputDecoration(
                  labelText: 'Montant cible ($kCurrency)',
                  prefixIcon: const Icon(Icons.track_changes_rounded,
                      size: 20),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _savedCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Déjà épargné ($kCurrency)',
                  prefixIcon:
                      const Icon(Icons.savings_rounded, size: 20),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _monthlyCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Contribution mensuelle ($kCurrency)',
                  prefixIcon: const Icon(Icons.calendar_month_rounded, size: 20),
                  helperText: 'Montant que vous mettez de côté chaque mois',
                ),
              ),
              _buildEstimatePreview(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleCtrl.text.trim().isEmpty ||
                        _targetCtrl.text.isEmpty) return;
                    final goal = Goal(
                      id: ExpenseProvider.generateId(),
                      title: _titleCtrl.text.trim(),
                      targetAmount:
                          double.tryParse(_targetCtrl.text) ?? 0,
                      savedAmount:
                          double.tryParse(_savedCtrl.text) ?? 0,
                      emoji: _emoji,
                      colorValue: _colorValue,
                      monthlyContribution:
                          double.tryParse(_monthlyCtrl.text) ?? 0,
                    );
                    context.read<GoalProvider>().addGoal(goal);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(_colorValue),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Créer l\'objectif',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 15),
                  ),
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

// ─── Goal Detail Sheet ─────────────────────────────────────────────────────────

class _GoalDetailSheet extends StatefulWidget {
  final Goal goal;
  const _GoalDetailSheet({required this.goal});

  @override
  State<_GoalDetailSheet> createState() => _GoalDetailSheetState();
}

class _GoalDetailSheetState extends State<_GoalDetailSheet> {
  final _amountCtrl = TextEditingController();
  bool _isEditing = false;
  late final TextEditingController _titleEditCtrl;
  late final TextEditingController _targetEditCtrl;
  late final TextEditingController _monthlyEditCtrl;

  @override
  void initState() {
    super.initState();
    _titleEditCtrl = TextEditingController(text: widget.goal.title);
    _targetEditCtrl = TextEditingController(
        text: widget.goal.targetAmount.toInt().toString());
    _monthlyEditCtrl = TextEditingController(
        text: widget.goal.monthlyContribution > 0
            ? widget.goal.monthlyContribution.toInt().toString()
            : '');
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _titleEditCtrl.dispose();
    _targetEditCtrl.dispose();
    _monthlyEditCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goal = widget.goal;
    final goalColor = Color(goal.colorValue);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(goal.emoji,
                      style: const TextStyle(fontSize: 42)),
                  IconButton(
                    onPressed: () =>
                        setState(() => _isEditing = !_isEditing),
                    icon: Icon(
                      _isEditing
                          ? Icons.close_rounded
                          : Icons.edit_rounded,
                      color: goalColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_isEditing) ...[
                TextField(
                  controller: _titleEditCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nom de l\'objectif',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _targetEditCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Montant cible ($kCurrency)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _monthlyEditCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Contribution mensuelle ($kCurrency)',
                    prefixIcon:
                        const Icon(Icons.calendar_month_rounded, size: 20),
                    helperText:
                        'Combien vous mettez de côté par mois pour cet objectif',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final updated = goal.copyWith(
                        title: _titleEditCtrl.text.trim(),
                        targetAmount: double.tryParse(
                                _targetEditCtrl.text) ??
                            goal.targetAmount,
                        monthlyContribution: double.tryParse(
                                _monthlyEditCtrl.text) ??
                            goal.monthlyContribution,
                      );
                      context
                          .read<GoalProvider>()
                          .updateGoal(updated);
                      setState(() => _isEditing = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goalColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Enregistrer'),
                  ),
                ),
              ] else ...[
                Text(
                  goal.title,
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(goal.progress * 100).toInt()}% atteint',
                  style: TextStyle(
                      color: goalColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // Barre de progression
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: goal.progress),
                    duration: const Duration(milliseconds: 800),
                    builder: (_, v, __) => LinearProgressIndicator(
                      value: v,
                      minHeight: 12,
                      backgroundColor: goalColor.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation(goalColor),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _ProgressStat(
                      label: 'Épargné',
                      value:
                          '${NumberFormat('#,###', 'fr_FR').format(goal.savedAmount)} $kCurrency',
                      color: goalColor,
                    ),
                    _ProgressStat(
                      label: 'Restant',
                      value:
                          '${NumberFormat('#,###', 'fr_FR').format(goal.remaining)} $kCurrency',
                      color: Colors.grey.shade500,
                      alignRight: true,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSimulation(goal),
              ],
              const SizedBox(height: 20),

              if (!_isEditing) ...[
                TextField(
                  controller: _amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Ajouter une épargne ($kCurrency)',
                    prefixIcon:
                        const Icon(Icons.add_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final amount =
                          double.tryParse(_amountCtrl.text);
                      if (amount != null && amount > 0) {
                        context
                            .read<GoalProvider>()
                            .addToGoal(goal.id, amount);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goalColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Ajouter l\'épargne',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimulation(Goal goal) {
    final goalColor = Color(goal.colorValue);
    final remaining = goal.remaining;

    if (remaining <= 0) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF34C759).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🏆', style: TextStyle(fontSize: 18)),
            SizedBox(width: 8),
            Text(
              'Objectif atteint ! Félicitations !',
              style: TextStyle(
                  color: Color(0xFF34C759), fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    // Pas de contribution mensuelle définie
    if (goal.monthlyContribution <= 0) {
      return Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Text('💡', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Définissez une contribution mensuelle pour voir quand vous atteindrez cet objectif.',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    final months = goal.estimatedMonthsRemaining!;
    final completionDate = goal.estimatedCompletionDate!;
    final dateStr =
        '${completionDate.day}/${completionDate.month}/${completionDate.year}';

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: goalColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: goalColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📅', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 12),
                    children: [
                      const TextSpan(text: 'À '),
                      TextSpan(
                        text:
                            '${NumberFormat('#,###', 'fr_FR').format(goal.monthlyContribution)} $kCurrency/mois',
                        style: TextStyle(
                            color: goalColor, fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: ', objectif atteint en '),
                      TextSpan(
                        text: '$months mois',
                        style: TextStyle(
                            color: goalColor, fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: ' (vers le $dateStr).'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 4,
              backgroundColor: goalColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(goalColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Restant : ${NumberFormat('#,###', 'fr_FR').format(remaining)} $kCurrency',
            style:
                TextStyle(color: Colors.grey.shade500, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool alignRight;

  const _ProgressStat({
    required this.label,
    required this.value,
    required this.color,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                TextStyle(color: Colors.grey.shade500, fontSize: 11)),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
