import 'package:flutter/material.dart';
import 'package:stayzio_app/features/message/data/model/message.dart';
import 'package:stayzio_app/features/auth/data/model/user.dart';
import 'package:stayzio_app/services/sqlite_service.dart';

class MessageProvider with ChangeNotifier {
  List<Map<String, dynamic>> _conversations = [];
  List<Message> _currentChat = [];
  User? _chatPartner;
  final SqliteService _sqliteService = SqliteService();
  bool _isLoading = false;

  List<Map<String, dynamic>> get conversations => _conversations;
  List<Message> get currentChat => _currentChat;
  User? get chatPartner => _chatPartner;
  bool get isLoading => _isLoading;

  Future<void> loadConversations(int userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _conversations = await _sqliteService.getConversationList(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadChat(int currentUserId, int otherUserId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentChat = await _sqliteService.getMessagesBetweenUsers(
          currentUserId, otherUserId);

      _chatPartner = await _sqliteService.getUserById(otherUserId);

      // Mark messages as read
      for (var message in _currentChat) {
        if (message.receiverId == currentUserId && message.isRead == 0) {
          await _sqliteService.updateMessageReadStatus(message.id!, 1);
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendMessage(Message message) async {
    try {
      _isLoading = true;
      notifyListeners();

      final messageId = await _sqliteService.insertMessage(message);

      if (messageId > 0) {
        // Reload the chat to include the new message
        await loadChat(message.senderId, message.receiverId);
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

  void clearCurrentChat() {
    _currentChat = [];
    _chatPartner = null;
    notifyListeners();
  }
}
