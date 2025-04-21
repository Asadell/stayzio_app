import 'package:flutter/material.dart';
import 'package:stayzio_app/features/hotel/data/model/hotel.dart';
import 'package:stayzio_app/services/sqlite_service.dart';

class HotelProvider with ChangeNotifier {
  List<Hotel> _hotels = [];
  List<Hotel> _popularHotels = []; // Added to store the top 3 popular hotels
  Hotel? _selectedHotel;
  final SqliteService _sqliteService = SqliteService();
  bool _isLoading = false;

  List<Hotel> get hotels => _hotels;
  List<Hotel> get popularHotels => _popularHotels; // Getter for popularHotels
  Hotel? get selectedHotel => _selectedHotel;
  bool get isLoading => _isLoading;

  Future<void> loadHotels() async {
    try {
      _isLoading = true;
      notifyListeners();

      _hotels = await _sqliteService.getAllHotels(); // Load all hotels

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTop3PopularHotels() async {
    // New method to load top 3 popular hotels
    try {
      _isLoading = true;
      notifyListeners();

      _popularHotels = await _sqliteService
          .getTop3HotelsByRating(); // Fetch top 3 popular hotels

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
