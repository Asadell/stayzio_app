import 'package:flutter/material.dart';
import 'package:stayzio_app/features/booking/data/model/booking.dart';
import 'package:stayzio_app/services/sqlite_service.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  List<Booking> _activeBookings = []; // pending or confirmed
  List<Booking> _historyBookings = []; // completed or cancelled
  final SqliteService _sqliteService = SqliteService();
  bool _isLoading = false;

  List<Booking> get bookings => _bookings;
  List<Booking> get activeBookings => _activeBookings;
  List<Booking> get historyBookings => _historyBookings;
  bool get isLoading => _isLoading;

  Future<void> loadBookingsByUser(int userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _bookings = await _sqliteService.getBookingsByUserId(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBookingsByStatus(int userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load active bookings (pending or confirmed)
      _activeBookings = await _sqliteService
          .getBookingsByUserIdAndStatus(userId, ['pending', 'confirmed']);

      // Load history bookings (completed or cancelled)
      _historyBookings = await _sqliteService
          .getBookingsByUserIdAndStatus(userId, ['completed', 'cancelled']);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createBooking(Booking booking) async {
    try {
      _isLoading = true;
      notifyListeners();

      final bookingId = await _sqliteService.insertBooking(booking);

      if (bookingId > 0) {
        await loadBookingsByStatus(booking.userId);
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

  Future<bool> updateBookingStatus(int bookingId, String status) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result =
          await _sqliteService.updateBookingStatus(bookingId, status);

      if (result > 0) {
        // Find the booking in the appropriate list and update its status
        final bookingInActive =
            _activeBookings.indexWhere((b) => b.id == bookingId);
        final bookingInHistory =
            _historyBookings.indexWhere((b) => b.id == bookingId);

        if (bookingInActive != -1) {
          if (status == 'completed' || status == 'cancelled') {
            // Move from active to history
            final booking = _activeBookings[bookingInActive];
            booking.status = status;
            _activeBookings.removeAt(bookingInActive);
            _historyBookings.add(booking);
          } else {
            // Update in active list
            _activeBookings[bookingInActive].status = status;
          }
        } else if (bookingInHistory != -1) {
          if (status == 'pending' || status == 'confirmed') {
            // Move from history to active
            final booking = _historyBookings[bookingInHistory];
            booking.status = status;
            _historyBookings.removeAt(bookingInHistory);
            _activeBookings.add(booking);
          } else {
            // Update in history list
            _historyBookings[bookingInHistory].status = status;
          }
        }

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

  Future<Map<String, dynamic>?> getFullBookingDetails(int bookingId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final details = await _sqliteService.getFullBookingById(bookingId);

      _isLoading = false;
      notifyListeners();
      return details;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
