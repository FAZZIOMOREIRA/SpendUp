import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../services/storage_service.dart';
import '../providers/expense_provider.dart';

class GoalProvider extends ChangeNotifier {
  List<Goal> _goals = [];
  final StorageService _storage = StorageService();

  List<Goal> get goals => List.unmodifiable(_goals);

  // Nouveau compte : zéro objectif, l'utilisateur crée les siens
  Future<void> init(ExpenseProvider expenseProvider) async {
    _goals = await _storage.loadGoals();
    notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    _goals.add(goal);
    await _storage.saveGoals(_goals);
    notifyListeners();
  }

  Future<void> updateGoal(Goal updated) async {
    final idx = _goals.indexWhere((g) => g.id == updated.id);
    if (idx != -1) {
      _goals[idx] = updated;
      await _storage.saveGoals(_goals);
      notifyListeners();
    }
  }

  Future<void> addToGoal(String goalId, double amount) async {
    final idx = _goals.indexWhere((g) => g.id == goalId);
    if (idx != -1) {
      final g = _goals[idx];
      _goals[idx] = g.copyWith(
        savedAmount: (g.savedAmount + amount).clamp(0.0, g.targetAmount),
      );
      await _storage.saveGoals(_goals);
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    await _storage.saveGoals(_goals);
    notifyListeners();
  }
}
