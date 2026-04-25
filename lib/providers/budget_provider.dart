import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../services/storage_service.dart';

class BudgetProvider extends ChangeNotifier {
  Budget _budget = Budget(monthlyLimit: 300000, monthlyIncome: 500000);
  final StorageService _storage = StorageService();
  bool _initialized = false;

  Budget get budget => _budget;
  double get monthlyLimit => _budget.monthlyLimit;
  double get monthlyIncome => _budget.monthlyIncome;

  // totalExpenses = dépenses du mois, totalIncome = revenus supplémentaires du mois
  double getBalance(double totalExpenses, {double extraIncome = 0}) {
    final raw = _budget.monthlyIncome + extraIncome - totalExpenses;
    return raw < 0 ? 0 : raw;
  }

  // Valeur réelle (peut être négative — pour les alertes)
  double getRawBalance(double totalExpenses, {double extraIncome = 0}) =>
      _budget.monthlyIncome + extraIncome - totalExpenses;

  double getRemainingBudget(double totalSpent) =>
      (_budget.monthlyLimit - totalSpent).clamp(0.0, double.infinity);

  double getUsagePercent(double totalSpent) {
    if (_budget.monthlyLimit <= 0) return 0;
    return (totalSpent / _budget.monthlyLimit).clamp(0.0, 1.0);
  }

  // Catégorie d'alerte financière
  FinancialAlert getAlert(double totalSpent, {double extraIncome = 0}) {
    final usagePct = getUsagePercent(totalSpent);
    final raw = getRawBalance(totalSpent, extraIncome: extraIncome);
    if (raw <= 0) return FinancialAlert.balanceExhausted;
    if (totalSpent > _budget.monthlyLimit) return FinancialAlert.budgetExceeded;
    if (usagePct >= 0.9) return FinancialAlert.nearLimit;
    if (usagePct >= 0.7) return FinancialAlert.warning;
    if (totalSpent == 0) return FinancialAlert.none;
    return FinancialAlert.good;
  }

  Future<void> init() async {
    if (_initialized) return;
    final saved = await _storage.loadBudget();
    if (saved != null) _budget = saved;
    _initialized = true;
    notifyListeners();
  }

  Future<void> initFromUser({
    required double monthlyIncome,
    required double monthlyLimit,
  }) async {
    final saved = await _storage.loadBudget();
    if (saved != null) {
      _budget = saved;
    } else {
      _budget = Budget(
        monthlyIncome: monthlyIncome > 0 ? monthlyIncome : 500000,
        monthlyLimit: monthlyLimit > 0 ? monthlyLimit : monthlyIncome * 0.7,
      );
      await _storage.saveBudget(_budget);
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> updateBudget({
    double? monthlyLimit,
    double? monthlyIncome,
  }) async {
    _budget = _budget.copyWith(
      monthlyLimit: monthlyLimit,
      monthlyIncome: monthlyIncome,
    );
    await _storage.saveBudget(_budget);
    notifyListeners();
  }
}

enum FinancialAlert { none, good, warning, nearLimit, budgetExceeded, balanceExhausted }
