// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'hotelId': hotelId,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'guests': guests,
      'roomType': roomType,
      'totalPrice': totalPrice,
      'cleaningFee': cleaningFee,
      'serviceFee': serviceFee,
      'adminFee': adminFee,
      'status': status,
      'paymentMethodId': paymentMethodId,
      'promoCode': promoCode,
      'createdAt': createdAt,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['userId'] as int,
      hotelId: map['hotelId'] as int,
      checkInDate: map['checkInDate'] as String,
      checkOutDate: map['checkOutDate'] as String,
      guests: map['guests'] as int,
      roomType: map['roomType'] != null ? map['roomType'] as String : null,
      totalPrice: map['totalPrice'] as double,
      cleaningFee:
          map['cleaningFee'] != null ? map['cleaningFee'] as double : null,
      serviceFee:
          map['serviceFee'] != null ? map['serviceFee'] as double : null,
      adminFee: map['adminFee'] != null ? map['adminFee'] as double : null,
      status: map['status'] as String,
      paymentMethodId:
          map['paymentMethodId'] != null ? map['paymentMethodId'] as int : null,
      promoCode: map['promoCode'] != null ? map['promoCode'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) =>
      Booking.fromMap(json.decode(source) as Map<String, dynamic>);
}
