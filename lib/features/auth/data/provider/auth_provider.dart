import 'package:flutter/material.dart';
import 'package:stayzio_app/features/auth/data/model/user.dart';
import 'package:stayzio_app/services/sqlite_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  final SqliteService _sqliteService = SqliteService();
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = await _sqliteService.getUserByEmail(email);

      if (user != null && user.password == password) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(User newUser) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check if user with email already exists
      final existingUser = await _sqliteService.getUserByEmail(newUser.email);
      if (existingUser != null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final userId = await _sqliteService.insertUser(newUser);
      if (userId > 0) {
        // Get the user with the newly created ID
        final createdUser = await _sqliteService.getUserById(userId);
        _currentUser = createdUser;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  Future<bool> updateUserInfo(User updatedUser) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _sqliteService.updateUser(updatedUser);

      if (result > 0) {
        _currentUser = updatedUser;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
