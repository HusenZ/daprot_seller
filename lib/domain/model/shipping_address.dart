import 'dart:convert';

class Shipping {
  final String name;
  final String houseNum;
  final String street;
  final String city;
  final String state; // Optional
  final String postalCode;
  final String country;
  final String phoneNumber;

  Shipping(
      {required this.name,
      required this.houseNum,
      required this.street,
      required this.city,
      required this.state,
      required this.postalCode,
      required this.country,
      required this.phoneNumber});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'name': name});
    result.addAll({'houseNum': houseNum});
    result.addAll({'street': street});
    result.addAll({'city': city});
    result.addAll({'state': state});
    result.addAll({'postalCode': postalCode});
    result.addAll({'country': country});
    result.addAll({'phoneNumber': phoneNumber});

    return result;
  }

  factory Shipping.fromMap(Map<String, dynamic> map) {
    return Shipping(
      name: map['name'] ?? '',
      houseNum: map['houseNum'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalCode: map['postalCode'] ?? '',
      country: map['country'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Shipping.fromJson(String source) =>
      Shipping.fromMap(json.decode(source));
}
