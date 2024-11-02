import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nest_f/services/properties_services.dart';

class House {
  final String id;
  final String address;
  final int price;
  final int? bedrooms;
  final int? bathrooms;
  final dynamic sqft;
  final List<String> images;
  final String description;
  final String location;
  final bool isNewConstruction;
  final String contactPhone;
  final String contactWhatsapp;
  final String yearBuilt;
  final List<String> amenities;
  final PropertyType propertyType;

  House({
    required this.id,
    required this.address,
    required this.price,
    this.bedrooms,
    this.bathrooms,
    required this.sqft,
    required this.images,
    required this.description,
    required this.location,
    required this.isNewConstruction,
    required this.contactPhone,
    required this.contactWhatsapp,
    required this.yearBuilt,
    required this.amenities,
    required this.propertyType,
  });

  factory House.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return House(
      id: data['id'],
      address: data['address'],
      price: data['price'] ?? 0,
      bedrooms: data['bedrooms'] ?? 0,
      bathrooms: data['bathrooms'] ?? 0,
      sqft: data['sqft'] ?? 0,
      images: List<String>.from(data['images']),
      description: data['description'],
      location: data['location'],
      isNewConstruction: data['isNewConstruction'],
      contactPhone: data['phone'],
      contactWhatsapp: data['contactWhatsapp'],
      yearBuilt: data['yearBuilt'],
      amenities: List<String>.from(data['amenities']),
      propertyType:
          PropertyType.values.byName(data['propertyType'].toLowerCase()),
    );
  }
}
