import 'package:flutter/material.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel.dart';
import 'package:stayzio_app/services/sqlite_service.dart';

class HotelProvider with ChangeNotifier {
  List<Hotel> _hotels = [];
  Hotel? _selectedHotel;
  final SqliteService _sqliteService = SqliteService();
  bool _isLoading = false;

  List<Hotel> get hotels => _hotels;
  Hotel? get selectedHotel => _selectedHotel;
  bool get isLoading => _isLoading;

  Future<void> loadHotels() async {
    try {
      _isLoading = true;
      notifyListeners();

      _hotels = await _sqliteService.getAllHotels();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHotelById(int hotelId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _selectedHotel = await _sqliteService.getHotelById(hotelId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSelectedHotel() {
    _selectedHotel = null;
    notifyListeners();
  }
}
