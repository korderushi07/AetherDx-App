class ClinicModel {
  final String id;
  final String name;
  final double rating;
  final int reviewCount;
  final double distance;
  final String address;
  final String phone;
  final String website;
  final String photoUrl;
  final double latitude;
  final double longitude;
  final bool isOpen;
  final String openingHours;
  final String city;

  const ClinicModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.address,
    required this.phone,
    required this.website,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
    required this.isOpen,
    required this.openingHours,
    required this.city,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      distance: (json['distance'] as num).toDouble(),
      address: json['address'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      photoUrl: json['photoUrl'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isOpen: json['isOpen'] as bool,
      openingHours: json['openingHours'] as String,
      city: json['city'] as String? ?? 'Los Angeles',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'reviewCount': reviewCount,
      'distance': distance,
      'address': address,
      'phone': phone,
      'website': website,
      'photoUrl': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
      'isOpen': isOpen,
      'openingHours': openingHours,
      'city': city,
    };
  }
}
