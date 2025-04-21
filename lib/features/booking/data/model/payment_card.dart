// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaymentCard {
  final int? id;
  final int userId;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String? cvv;
  final String cardType; // visa, mastercard
  final int isDefault; // 0 for not default, 1 for default
  final double? currentBalance;
  final String? createdAt;

  PaymentCard({
    this.id,
    required this.userId,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    this.cvv,
    required this.cardType,
    this.isDefault = 0,
    this.currentBalance,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardType': cardType,
      'isDefault': isDefault,
      'currentBalance': currentBalance,
      'createdAt': createdAt,
    };
  }

  factory PaymentCard.fromMap(Map<String, dynamic> map) {
    return PaymentCard(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['userId'] as int,
      cardNumber: map['cardNumber'] as String,
      cardHolderName: map['cardHolderName'] as String,
      expiryDate: map['expiryDate'] as String,
      cvv: map['cvv'] != null ? map['cvv'] as String : null,
      cardType: map['cardType'] as String,
      isDefault: map['isDefault'] as int,
      currentBalance: map['currentBalance'] != null
          ? map['currentBalance'] as double
          : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentCard.fromJson(String source) =>
      PaymentCard.fromMap(json.decode(source) as Map<String, dynamic>);
}
