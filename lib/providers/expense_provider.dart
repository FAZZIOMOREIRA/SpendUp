import 'dart:math';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];
  final StorageService _storage = StorageService();
  bool _initialized = false;

  List<Expense> get expenses => List.unmodifiable(_expenses);

  List<Expense> get expensesSorted {
    final sorted = [..._expenses];
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  List<Expense> get thisMonthAll {
    final now = DateTime.now();
    return _expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .toList();
  }

  // Dépenses uniquement (pas revenus)
  List<Expense> get thisMonthExpenses =>
      thisMonthAll.where((e) => !e.isIncome).toList();

  // Revenus uniquement
  List<Expense> get thisMonthIncomes =>
      thisMonthAll.where((e) => e.isIncome).toList();

  double get totalThisMonth =>
      thisMonthExpenses.fold(0.0, (s, e) => s + e.amount);

  double get totalIncomeThisMonth =>
      thisMonthIncomes.fold(0.0, (s, e) => s + e.amount);

  double get totalAll =>
      _expenses.where((e) => !e.isIncome).fold(0.0, (s, e) => s + e.amount);

  Map<String, double> get expensesByCategory {
    final map = <String, double>{};
    for (final e in thisMonthExpenses) {
      map[e.categoryId] = (map[e.categoryId] ?? 0) + e.amount;
    }
    return map;
  }

  Map<String, double> get expensesByMonth {
    final map = <String, double>{};
    for (final e in _expenses.where((e) => !e.isIncome)) {
      final key =
          '${e.date.year}-${e.date.month.toString().padLeft(2, '0')}';
      map[key] = (map[key] ?? 0) + e.amount;
    }
    return map;
  }

  Future<void> init() async {
    if (_initialized) return;
    _expenses = await _storage.loadExpenses();
    _initialized = true;
    notifyListeners();
  }

  // Nouveau compte : démarre à zéro
  Future<void> initFresh() async {
    _expenses = [];
    await _storage.saveExpenses(_expenses);
    await _storage.markInitialized();
    _initialized = true;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    _expenses.add(expense);
    await _storage.saveExpenses(_expenses);
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await _storage.saveExpenses(_expenses);
    notifyListeners();
  }

  static String generateId() {
    final rand = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${rand.nextInt(99999)}';
  }
}
