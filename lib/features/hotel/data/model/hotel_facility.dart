// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HotelFacility {
  final int? id;
  final int hotelId;
  final String facilityName;
  final String? facilityIcon;

  HotelFacility({
    this.id,
    required this.hotelId,
    required this.facilityName,
    this.facilityIcon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'hotelId': hotelId,
      'facilityName': facilityName,
      'facilityIcon': facilityIcon,
    };
  }

  factory HotelFacility.fromMap(Map<String, dynamic> map) {
    return HotelFacility(
      id: map['id'] != null ? map['id'] as int : null,
      hotelId: map['hotelId'] as int,
      facilityName: map['facilityName'] as String,
      facilityIcon:
          map['facilityIcon'] != null ? map['facilityIcon'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HotelFacility.fromJson(String source) =>
      HotelFacility.fromMap(json.decode(source) as Map<String, dynamic>);
}
