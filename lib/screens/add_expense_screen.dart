import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../utils/constants.dart';

class AddExpenseScreen extends StatefulWidget {
  final bool startAsIncome;
  const AddExpenseScreen({super.key, this.startAsIncome = false});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen>
    with SingleTickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedCategory = 'food';
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  late bool _isIncome;

  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  Color get _themeColor =>
      _isIncome ? const Color(0xFF00C6AE) : const Color(0xFF5B4FFF);

  @override
  void initState() {
    super.initState();
    _isIncome = widget.startAsIncome;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(primary: _themeColor),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _appendToAmount(String digit) {
    setState(() {
      if (digit == 'C') {
        _amountController.clear();
        return;
      }
      if (digit == '⌫') {
        final text = _amountController.text;
        if (text.isNotEmpty) {
          _amountController.text = text.substring(0, text.length - 1);
        }
        return;
      }
      if (digit == '.' && _amountController.text.contains('.')) return;
      _amountController.text += digit;
    });
  }

  Future<void> _save() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un montant')),
      );
      return;
    }
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Montant invalide')),
      );
      return;
    }

    String title = _titleController.text.trim();
    if (title.isEmpty) {
      title = _isIncome
          ? 'Revenu'
          : getCategoryById(_selectedCategory).name;
    }

    setState(() => _isSaving = true);

    final expense = Expense(
      id: ExpenseProvider.generateId(),
      title: title,
      amount: amount,
      categoryId: _isIncome ? 'income' : _selectedCategory,
      date: _selectedDate,
      note: _noteController.text.trim(),
      isIncome: _isIncome,
    );

    final expProvider = context.read<ExpenseProvider>();
    final messenger = ScaffoldMessenger.of(context);
    await expProvider.addExpense(expense);

    if (mounted) {
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
              _isIncome ? 'Revenu ajouté avec succès ✓' : 'Dépense enregistrée ✓'),
          backgroundColor: _themeColor,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D0B1E) : const Color(0xFFF4F6FF),
      body: SafeArea(
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildTypeToggle(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      _buildAmountDisplay(context),
                      const SizedBox(height: 20),
                      _buildNumpad(context),
                      const SizedBox(height: 20),
                      if (!_isIncome) _buildCategorySelector(context),
                      if (_isIncome) _buildIncomeSourceSelector(context),
                      const SizedBox(height: 16),
                      _buildTitleField(context),
                      const SizedBox(height: 12),
                      _buildDateField(context),
                      const SizedBox(height: 12),
                      _buildNoteField(context),
                      const SizedBox(height: 24),
                      _buildSaveButton(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Text(
            _isIncome ? 'Ajouter un revenu' : 'Nouvelle dépense',
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF221E3A)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isIncome = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: !_isIncome
                        ? const Color(0xFF5B4FFF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_upward_rounded,
                          size: 16,
                          color: !_isIncome
                              ? Colors.white
                              : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Dépense',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: !_isIncome
                                ? Colors.white
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isIncome = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _isIncome
                        ? const Color(0xFF00C6AE)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_downward_rounded,
                          size: 16,
                          color: _isIncome
                              ? Colors.white
                              : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Revenu',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: _isIncome
                                ? Colors.white
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountDisplay(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isIncome
              ? [const Color(0xFF00C6AE), const Color(0xFF00E5C0)]
              : [const Color(0xFF5B4FFF), const Color(0xFF7C6FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _themeColor.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isIncome
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                _isIncome ? 'Montant reçu' : 'Montant dépensé',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _amountController.text.isEmpty
                    ? '0'
                    : NumberFormat('#,###', 'fr_FR')
                        .format(double.tryParse(_amountController.text) ?? 0),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6, left: 6),
                child: Text(
                  kCurrency,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumpad(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttons = [
      '7', '8', '9',
      '4', '5', '6',
      '1', '2', '3',
      'C', '0', '⌫',
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: buttons.length,
      itemBuilder: (_, i) {
        final btn = buttons[i];
        final isBack = btn == '⌫';
        final isClear = btn == 'C';
        return GestureDetector(
          onTap: () => _appendToAmount(btn),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            decoration: BoxDecoration(
              color: isBack
                  ? const Color(0xFFFF3B5C).withOpacity(0.12)
                  : isClear
                      ? Colors.orange.withOpacity(0.12)
                      : isDark
                          ? const Color(0xFF221E3A)
                          : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                btn,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isBack
                      ? const Color(0xFFFF3B5C)
                      : isClear
                          ? Colors.orange
                          : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategorySelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Catégorie',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 10),
        SizedBox(
          height: 82,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: kCategories.length,
            itemBuilder: (_, i) {
              final cat = kCategories[i];
              final isSelected = cat.id == _selectedCategory;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? cat.color : cat.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: cat.color.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat.icon,
                          color: isSelected ? Colors.white : cat.color,
                          size: 22),
                      const SizedBox(height: 4),
                      Text(
                        cat.name.split(' ').first,
                        style: TextStyle(
                          color: isSelected ? Colors.white : cat.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIncomeSourceSelector(BuildContext context) {
    final sources = [
      {'id': 'salaire', 'label': 'Salaire', 'icon': Icons.work_rounded},
      {'id': 'freelance', 'label': 'Freelance', 'icon': Icons.laptop_rounded},
      {'id': 'business', 'label': 'Business', 'icon': Icons.storefront_rounded},
      {'id': 'investissement', 'label': 'Investissement', 'icon': Icons.trending_up_rounded},
      {'id': 'autre', 'label': 'Autre', 'icon': Icons.add_circle_outline_rounded},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Source de revenu',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        const SizedBox(height: 10),
        SizedBox(
          height: 82,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sources.length,
            itemBuilder: (_, i) {
              final s = sources[i];
              final isSelected = _selectedCategory == s['id'];
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedCategory = s['id'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF00C6AE)
                        : const Color(0xFF00C6AE).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color:
                                  const Color(0xFF00C6AE).withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        s['icon'] as IconData,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF00C6AE),
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s['label'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF00C6AE),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: _isIncome ? 'Description (optionnelle)' : 'Titre (optionnel)',
        prefixIcon: const Icon(Icons.edit_rounded, size: 20),
        hintText: _isIncome ? 'Ex: Salaire avril...' : 'Ex: Déjeuner, Carburant...',
      ),
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 20, color: Colors.grey.shade500),
            const SizedBox(width: 12),
            Text(
              DateFormat('EEEE dd MMMM yyyy', 'fr_FR').format(_selectedDate),
              style: const TextStyle(fontSize: 14),
            ),
            const Spacer(),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteField(BuildContext context) {
    return TextField(
      controller: _noteController,
      decoration: const InputDecoration(
        labelText: 'Note (optionnelle)',
        prefixIcon: Icon(Icons.note_rounded, size: 20),
        hintText: 'Ajouter une note...',
      ),
      maxLines: 2,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: _themeColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: _themeColor.withOpacity(0.4),
        ),
        child: _isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isIncome
                        ? Icons.arrow_downward_rounded
                        : Icons.check_rounded,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isIncome
                        ? 'Enregistrer le revenu'
                        : 'Enregistrer la dépense',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}
