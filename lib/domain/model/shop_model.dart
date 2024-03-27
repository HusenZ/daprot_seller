import 'dart:convert';

class Shop {
  final String location;
  final String name;
  final String openTime;
  final String cloneTime;
  final String shopImage;
  final String shopLogo;
  final String latitude;
  final String longitude;

  Shop({
    required this.location,
    required this.name,
    required this.openTime,
    required this.cloneTime,
    required this.shopImage,
    required this.shopLogo,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'location': location});
    result.addAll({'name': name});
    result.addAll({'openTime': openTime});
    result.addAll({'cloneTime': cloneTime});
    result.addAll({'shopImage': shopImage});
    result.addAll({'shopLogo': shopLogo});
    result.addAll({'latitude': latitude});
    result.addAll({'longitude': longitude});

    return result;
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      location: map['location'] ?? '',
      name: map['name'] ?? '',
      openTime: map['openTime'] ?? '',
      cloneTime: map['cloneTime'] ?? '',
      shopImage: map['shopImage'] ?? '',
      shopLogo: map['shopLogo'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Shop.fromJson(String source) => Shop.fromMap(json.decode(source));
}
