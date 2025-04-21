// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:stayzio_app/features/hotel/data/model/hotel_facility.dart';

class Hotel {
  final int? id;
  final String name;
  final String location;
  final double? latitude;
  final double? longitude;
  final String? description;
  final double pricePerNight;
  final double? rating;
  final String? imageUrl;
  final String? createdAt;
  final List<HotelFacility>? facilities;

  Hotel({
    this.id,
    required this.name,
    required this.location,
    this.latitude,
    this.longitude,
    this.description,
    required this.pricePerNight,
    this.rating,
    this.imageUrl,
    this.createdAt,
    this.facilities,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'pricePerNight': pricePerNight,
      'rating': rating,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'facilities': facilities?.map((x) => x.toMap()).toList(),
    };
  }

  factory Hotel.fromMap(Map<String, dynamic> map) {
    return Hotel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      location: map['location'] as String,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      pricePerNight: map['pricePerNight'] as double,
      rating: map['rating'] != null ? map['rating'] as double : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      facilities: (map['facilities'] as List<dynamic>?)
          ?.map((facility) => facility as HotelFacility)
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Hotel.fromJson(String source) =>
      Hotel.fromMap(json.decode(source) as Map<String, dynamic>);
}
