import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/goal_provider.dart';
import '../../screens/main_navigation.dart';
import '../../utils/constants.dart';

class OnboardingScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String passwordHash;

  const OnboardingScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.passwordHash,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  // Step 1 — Profil personnel
  final _ageCtrl = TextEditingController();
  String _employmentStatus = 'salarié';

  // Step 2 — Finances
  final _incomeCtrl = TextEditingController();
  final _expensesCtrl = TextEditingController();

  // Step 3 — Objectifs et niveau
  String _mainGoal = 'budget';
  String _financialLevel = 'débutant';

  @override
  void dispose() {
    _pageCtrl.dispose();
    _ageCtrl.dispose();
    _incomeCtrl.dispose();
    _expensesCtrl.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    } else {
      _finish();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageCtrl.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage--);
    }
  }

  Future<void> _finish() async {
    setState(() => _isLoading = true);
    final income = double.tryParse(_incomeCtrl.text.replaceAll(' ', '')) ?? 0;
    final expenses =
        double.tryParse(_expensesCtrl.text.replaceAll(' ', '')) ?? 0;

    final profile = UserProfile(
      id: '${DateTime.now().millisecondsSinceEpoch}',
      firstName: widget.firstName,
      lastName: widget.lastName,
      email: widget.email,
      passwordHash: widget.passwordHash,
      age: int.tryParse(_ageCtrl.text),
      employmentStatus: _employmentStatus,
      monthlyIncome: income,
      monthlyExpenses: expenses > 0 ? expenses : income * 0.7,
      mainGoal: _mainGoal,
      financialLevel: _financialLevel,
      createdAt: DateTime.now(),
    );

    final authProvider = context.read<AuthProvider>();
    final budgetProvider = context.read<BudgetProvider>();
    final expProvider = context.read<ExpenseProvider>();
    final goalProvider = context.read<GoalProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final error = await authProvider.register(profile);
    if (!mounted) return;
    if (error != null) {
      setState(() => _isLoading = false);
      messenger.showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    await budgetProvider.initFromUser(
      monthlyIncome: income,
      monthlyLimit: expenses > 0 ? expenses : income * 0.7,
    );
    await expProvider.initFresh();
    await goalProvider.init(expProvider);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const MainNavigation(),
          transitionsBuilder: (_, anim, _, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final steps = ['Profil', 'Finances', 'Objectifs'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          Row(
            children: [
              if (_currentPage > 0)
                IconButton(
                  onPressed: _prevPage,
                  icon: const Icon(Icons.arrow_back_rounded),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              else
                const SizedBox(width: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Étape ${_currentPage + 2}/4',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 12),
                    ),
                    Text(
                      steps[_currentPage],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B4FFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentPage + 1}/3',
                  style: const TextStyle(
                    color: Color(0xFF5B4FFF),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(3, (i) {
              return Expanded(
                child: Container(
                  height: 5,
                  margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: i <= _currentPage
                        ? const Color(0xFF5B4FFF)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('👤', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'Parlez-nous de vous',
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.w700),
          ),
          Text(
            'Ces informations nous aident à personnaliser votre expérience.',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 28),
          TextFormField(
            controller: _ageCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              labelText: 'Votre âge (optionnel)',
              prefixIcon: Icon(Icons.cake_outlined, size: 20),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Situation professionnelle',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ...kEmploymentStatuses.map((s) {
            final selected = _employmentStatus == s['id'];
            return GestureDetector(
              onTap: () => setState(() => _employmentStatus = s['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF5B4FFF).withOpacity(0.08)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF5B4FFF)
                        : Colors.grey.shade200,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(s['icon']!,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Text(
                      s['label']!,
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: selected ? const Color(0xFF5B4FFF) : null,
                      ),
                    ),
                    const Spacer(),
                    if (selected)
                      const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF5B4FFF), size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    final income = double.tryParse(_incomeCtrl.text.replaceAll(' ', '')) ?? 0;
    final budget = double.tryParse(_expensesCtrl.text.replaceAll(' ', '')) ?? 0;
    final budgetExceedsIncome = income > 0 && budget > income;
    final budgetPct = income > 0 && budget > 0
        ? ((budget / income) * 100).toStringAsFixed(0)
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💳', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'Vos finances',
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.w700),
          ),
          Text(
            'Définissez vos revenus et le plafond de dépenses que vous vous fixez.',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 28),
          TextFormField(
            controller: _incomeCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Revenu mensuel ($kCurrency)',
              prefixIcon: const Icon(Icons.attach_money_rounded, size: 20),
              helperText: 'Salaire, freelance, pension, etc.',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _expensesCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Budget mensuel maximum ($kCurrency)',
              prefixIcon: const Icon(Icons.account_balance_wallet_outlined, size: 20),
              helperText: 'Plafond de dépenses que vous souhaitez ne pas dépasser',
              suffixText: budgetPct != null ? '$budgetPct% des revenus' : null,
              suffixStyle: TextStyle(
                color: budgetExceedsIncome
                    ? const Color(0xFFFF3B5C)
                    : const Color(0xFF00C6AE),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          if (budgetExceedsIncome) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF3B5C).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFFF3B5C).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Votre budget dépasse vos revenus. Pour éviter un déficit, fixez un budget ≤ ${_incomeCtrl.text} $kCurrency.',
                      style: const TextStyle(
                          color: Color(0xFFFF3B5C), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (!budgetExceedsIncome && income > 0 && budget > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00C6AE).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFF00C6AE).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Text('✅', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Épargne potentielle : ${(income - budget).toStringAsFixed(0)} $kCurrency/mois (${(((income - budget) / income) * 100).toStringAsFixed(0)}% de vos revenus).',
                      style: const TextStyle(
                          color: Color(0xFF00C6AE), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF5B4FFF).withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Règle 50/30/20 : 50% aux besoins essentiels, 30% aux loisirs, 20% à l\'épargne.',
                    style: TextStyle(
                        color: Colors.grey.shade700, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🎯', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'Vos objectifs',
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.w700),
          ),
          Text(
            'Quel est votre principal objectif financier ?',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 20),
          ...kMainGoals.map((g) {
            final selected = _mainGoal == g['id'];
            return GestureDetector(
              onTap: () => setState(() => _mainGoal = g['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF5B4FFF).withOpacity(0.08)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF5B4FFF)
                        : Colors.grey.shade200,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(g['icon']!,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        g['label']!,
                        style: TextStyle(
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color:
                              selected ? const Color(0xFF5B4FFF) : null,
                        ),
                      ),
                    ),
                    if (selected)
                      const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF5B4FFF), size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          Text(
            'Votre niveau de connaissance financière',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ...kFinancialLevels.map((l) {
            final selected = _financialLevel == l['id'];
            return GestureDetector(
              onTap: () => setState(() => _financialLevel = l['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF00C6AE).withOpacity(0.08)
                      : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF00C6AE)
                        : Colors.grey.shade200,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(l['icon']!,
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l['label']!,
                            style: TextStyle(
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                          Text(
                            l['desc']!,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (selected)
                      const Icon(Icons.check_circle_rounded,
                          color: Color(0xFF00C6AE), size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    final isLast = _currentPage == 2;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _nextPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: isLast
                ? const Color(0xFF00C6AE)
                : const Color(0xFF5B4FFF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLast ? 'Commencer SpendUp 🚀' : 'Continuer',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (!isLast) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
