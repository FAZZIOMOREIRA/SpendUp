import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user_profile.dart';
import '../providers/auth_provider.dart';
import '../providers/budget_provider.dart';
import '../utils/constants.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    if (user == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, user),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildFinancialSummary(context, user),
                _buildInfoSection(context, user, isDark),
                _buildActions(context, user, isDark),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, UserProfile user) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
      ),
      actions: [
        IconButton(
          onPressed: () => _showEditProfile(context, user),
          icon: const Icon(Icons.edit_rounded, color: Colors.white),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3D30FF), Color(0xFF7C6FFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.4), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      user.initials,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.fullName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75), fontSize: 13),
                ),
                const SizedBox(height: 8),
                _LevelBadge(level: user.financialLevel),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFinancialSummary(BuildContext context, UserProfile user) {
    final budget = context.watch<BudgetProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF221E3A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Résumé financier',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _FinancialItem(
                    label: 'Revenu mensuel',
                    value:
                        '${NumberFormat('#,###', 'fr_FR').format(budget.monthlyIncome)} $kCurrency',
                    icon: Icons.arrow_downward_rounded,
                    color: const Color(0xFF00C6AE),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FinancialItem(
                    label: 'Budget limite',
                    value:
                        '${NumberFormat('#,###', 'fr_FR').format(budget.monthlyLimit)} $kCurrency',
                    icon: Icons.account_balance_wallet_rounded,
                    color: const Color(0xFF5B4FFF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
      BuildContext context, UserProfile user, bool isDark) {
    final employmentLabel = kEmploymentStatuses
        .firstWhere((e) => e['id'] == user.employmentStatus,
            orElse: () => kEmploymentStatuses.last)['label']!;
    final goalLabel = kMainGoals
        .firstWhere((g) => g['id'] == user.mainGoal,
            orElse: () => kMainGoals.last)['label']!;
    final goalIcon = kMainGoals
        .firstWhere((g) => g['id'] == user.mainGoal,
            orElse: () => kMainGoals.last)['icon']!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF221E3A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informations personnelles',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 16),
            if (user.age != null)
              _InfoRow(
                icon: Icons.cake_outlined,
                label: 'Âge',
                value: '${user.age} ans',
              ),
            _InfoRow(
              icon: Icons.work_outline_rounded,
              label: 'Situation',
              value: employmentLabel,
            ),
            _InfoRow(
              icon: Icons.flag_outlined,
              label: 'Objectif principal',
              value: '$goalIcon $goalLabel',
            ),
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Membre depuis',
              value: DateFormat('MMMM yyyy', 'fr_FR')
                  .format(user.createdAt),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(
      BuildContext context, UserProfile user, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.edit_outlined,
            label: 'Modifier le profil',
            color: const Color(0xFF5B4FFF),
            onTap: () => _showEditProfile(context, user),
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _ActionTile(
            icon: Icons.logout_rounded,
            label: 'Se déconnecter',
            color: const Color(0xFFFF3B5C),
            onTap: () => _confirmLogout(context),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  void _showEditProfile(BuildContext context, UserProfile user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(user: user),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Se déconnecter'),
        content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final auth = context.read<AuthProvider>();
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (_) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B5C),
            ),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}

// ─── Edit Profile Sheet ───────────────────────────────────────────────────────

class _EditProfileSheet extends StatefulWidget {
  final UserProfile user;
  const _EditProfileSheet({required this.user});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _ageCtrl;
  late final TextEditingController _incomeCtrl;
  late String _employmentStatus;
  late String _mainGoal;
  late String _financialLevel;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl =
        TextEditingController(text: widget.user.firstName);
    _lastNameCtrl =
        TextEditingController(text: widget.user.lastName);
    _ageCtrl = TextEditingController(
        text: widget.user.age?.toString() ?? '');
    _incomeCtrl = TextEditingController(
        text: widget.user.monthlyIncome.toInt().toString());
    _employmentStatus = widget.user.employmentStatus;
    _mainGoal = widget.user.mainGoal;
    _financialLevel = widget.user.financialLevel;
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _ageCtrl.dispose();
    _incomeCtrl.dispose();
    super.dispose();
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
                'Modifier le profil',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _firstNameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Prénom'),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _lastNameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Nom'),
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _ageCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: 'Âge'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _incomeCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Revenu mensuel ($kCurrency)'),
              ),
              const SizedBox(height: 16),
              Text('Situation professionnelle',
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kEmploymentStatuses.map((s) {
                  final sel = _employmentStatus == s['id'];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _employmentStatus = s['id']!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFF5B4FFF).withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel
                              ? const Color(0xFF5B4FFF)
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        '${s['icon']} ${s['label']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: sel ? const Color(0xFF5B4FFF) : null,
                          fontWeight: sel
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final updated = widget.user.copyWith(
                      firstName: _firstNameCtrl.text.trim(),
                      lastName: _lastNameCtrl.text.trim(),
                      age: int.tryParse(_ageCtrl.text),
                      monthlyIncome:
                          double.tryParse(_incomeCtrl.text) ??
                              widget.user.monthlyIncome,
                      employmentStatus: _employmentStatus,
                      mainGoal: _mainGoal,
                      financialLevel: _financialLevel,
                    );
                    await context
                        .read<AuthProvider>()
                        .updateProfile(updated);
                    final income = double.tryParse(_incomeCtrl.text);
                    if (income != null) {
                      await context
                          .read<BudgetProvider>()
                          .updateBudget(monthlyIncome: income);
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5B4FFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Enregistrer',
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

// ─── Sous-widgets ─────────────────────────────────────────────────────────────

class _LevelBadge extends StatelessWidget {
  final String level;
  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    final data = kFinancialLevels.firstWhere(
      (l) => l['id'] == level,
      orElse: () => kFinancialLevels.first,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        '${data['icon']} ${data['label']}',
        style: const TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _FinancialItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _FinancialItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey.shade400),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                    color: Colors.grey.shade500, fontSize: 13),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF221E3A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.15 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: color == const Color(0xFFFF3B5C) ? color : null),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded,
                color: Colors.grey.shade400, size: 20),
          ],
        ),
      ),
    );
  }
}
