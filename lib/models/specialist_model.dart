class SpecialistModel {
  final String id;
  final String? name;
  final String? specialization;
  final String? hospital;
  final String? city;
  final String? state;
  final String? address;
  final int? experience;
  final double? rating;
  final String? phone;
  final String? website;
  final String? mapsUrl;

  const SpecialistModel({
    required this.id,
    this.name,
    this.specialization,
    this.hospital,
    this.city,
    this.state,
    this.address,
    this.experience,
    this.rating,
    this.phone,
    this.website,
    this.mapsUrl,
  });

  factory SpecialistModel.fromJson(Map<String, dynamic> json) {
    return SpecialistModel(
      id: json['id']?.toString() ?? json['doctorId']?.toString() ?? '',
      name: json['name'] as String?,
      specialization: json['specialization'] as String?,
      hospital: json['hospital'] as String? ?? json['hospitalClinic'] as String? ?? json['clinic'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      address: json['address'] as String?,
      experience: json['experience'] as int?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      phone: json['phone'] as String?,
      website: json['website'] as String?,
      mapsUrl: json['mapsUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'hospital': hospital,
      'city': city,
      'state': state,
      'address': address,
      'experience': experience,
      'rating': rating,
      'phone': phone,
      'website': website,
      'mapsUrl': mapsUrl,
    };
  }
}
