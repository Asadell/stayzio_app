class Booking {
  final int? id;
  final int userId;
  final int hotelId;
  final String checkInDate;
  final String checkOutDate;
  final int guests;
  final String? roomType;
  final double totalPrice;
  final double? cleaningFee;
  final double? serviceFee;
  final double? adminFee;
  final String status; // pending, confirmed, cancelled, completed
  final int? paymentMethodId;
  final String? promoCode;
  final String? createdAt;

  Booking({
    this.id,
    required this.userId,
    required this.hotelId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    this.roomType,
    required this.totalPrice,
    this.cleaningFee,
    this.serviceFee,
    this.adminFee,
    required this.status,
    this.paymentMethodId,
    this.promoCode,
    this.createdAt,
  });
}
