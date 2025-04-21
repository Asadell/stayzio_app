import 'package:flutter/material.dart';
import 'package:stayzio_app/features/booking/data/model/payment_card.dart';
import 'package:stayzio_app/services/sqlite_service.dart';

class PaymentCardProvider with ChangeNotifier {
  List<PaymentCard> _cards = [];
  final SqliteService _sqliteService = SqliteService();
  bool _isLoading = false;

  List<PaymentCard> get cards => _cards;
  bool get isLoading => _isLoading;

  Future<void> loadUserCards(int userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _cards = await _sqliteService.getPaymentCardsByUserId(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addNewCard(PaymentCard card) async {
    print('masonhhh');
    try {
      _isLoading = true;
      notifyListeners();

      final cardId = await _sqliteService.insertPaymentCard(card);

      if (cardId > 0) {
        await loadUserCards(card.userId);
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

  Future<bool> setDefaultCard(int userId, int cardId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result =
          await _sqliteService.updatePaymentCardDefault(userId, cardId);

      if (result > 0) {
        await loadUserCards(userId);
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

  Future<bool> deleteCard(int userId, int cardId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await _sqliteService.deletePaymentCard(cardId);

      if (result > 0) {
        await loadUserCards(userId);
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
