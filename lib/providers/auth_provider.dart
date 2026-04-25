import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? _currentUser;
  bool _isLoading = true;
  final StorageService _storage = StorageService();

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _currentUser = await _storage.loadCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    final user = await _storage.getUserByEmail(email.toLowerCase().trim());
    if (user == null) return 'Aucun compte trouvé avec cet email';
    if (user.passwordHash != _hash(password)) return 'Mot de passe incorrect';
    _currentUser = user;
    await _storage.saveCurrentUserId(user.id);
    notifyListeners();
    return null;
  }

  Future<String?> register(UserProfile profile) async {
    final existing = await _storage.getUserByEmail(profile.email);
    if (existing != null) return 'Un compte existe déjà avec cet email';
    await _storage.saveUserProfile(profile);
    await _storage.saveCurrentUserId(profile.id);
    _currentUser = profile;
    notifyListeners();
    return null;
  }

  Future<void> updateProfile(UserProfile updated) async {
    await _storage.saveUserProfile(updated);
    _currentUser = updated;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.clearCurrentUser();
    _currentUser = null;
    notifyListeners();
  }

  static String hashPassword(String password) => _hash(password);

  static String _hash(String password) =>
      base64Encode(utf8.encode(password));
}
