import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../models/goal.dart';
import '../models/budget.dart';
import '../models/user_profile.dart';

class StorageService {
  static const _expensesKey = 'expenses';
  static const _goalsKey = 'goals';
  static const _budgetKey = 'budget';
  static const _themeKey = 'isDarkMode';
  static const _initializedKey = 'isInitialized';
  static const _usersKey = 'users';
  static const _currentUserIdKey = 'currentUserId';

  // ─── Dépenses ────────────────────────────────────────────────────────────────

  Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_expensesKey);
    if (jsonStr == null) return [];
    final List<dynamic> list = json.decode(jsonStr);
    return list.map((e) => Expense.fromMap(e)).toList();
  }

  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _expensesKey, json.encode(expenses.map((e) => e.toMap()).toList()));
  }

  // ─── Objectifs ───────────────────────────────────────────────────────────────

  Future<List<Goal>> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_goalsKey);
    if (jsonStr == null) return [];
    final List<dynamic> list = json.decode(jsonStr);
    return list.map((g) => Goal.fromMap(g)).toList();
  }

  Future<void> saveGoals(List<Goal> goals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _goalsKey, json.encode(goals.map((g) => g.toMap()).toList()));
  }

  // ─── Budget ──────────────────────────────────────────────────────────────────

  Future<Budget?> loadBudget() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_budgetKey);
    if (jsonStr == null) return null;
    return Budget.fromJson(jsonStr);
  }

  Future<void> saveBudget(Budget budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_budgetKey, budget.toJson());
  }

  // ─── Thème ───────────────────────────────────────────────────────────────────

  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  // ─── Initialisation ──────────────────────────────────────────────────────────

  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_initializedKey) ?? false);
  }

  Future<void> markInitialized() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_initializedKey, true);
  }

  // ─── Utilisateurs ────────────────────────────────────────────────────────────

  Future<List<UserProfile>> loadAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_usersKey);
    if (jsonStr == null) return [];
    final List<dynamic> list = json.decode(jsonStr);
    return list.map((u) => UserProfile.fromMap(u)).toList();
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await loadAllUsers();
    final idx = users.indexWhere((u) => u.id == profile.id);
    if (idx >= 0) {
      users[idx] = profile;
    } else {
      users.add(profile);
    }
    await prefs.setString(
        _usersKey, json.encode(users.map((u) => u.toMap()).toList()));
  }

  Future<UserProfile?> getUserByEmail(String email) async {
    final users = await loadAllUsers();
    try {
      return users.firstWhere(
          (u) => u.email.toLowerCase() == email.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCurrentUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserIdKey, id);
  }

  Future<UserProfile?> loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_currentUserIdKey);
    if (id == null) return null;
    final users = await loadAllUsers();
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserIdKey);
  }
}
