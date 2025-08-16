import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  String id; 
  final String name;
  final String phoneNumber;
  final AddressType addressType;
  final String unitNumber; 
  final String buildingName; 
  final String street;
  final String city;
  final String district;
  final String postalCode;
  final String country;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.addressType,
    required this.unitNumber,
    required this.buildingName,
    required this.street,
    required this.city,
    required this.district,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
  });

  set setId(String newId) => id = newId;
  Address copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    AddressType? addressType,
    String? unitNumber,
    String? buildingName,
    String? street,
    String? city,
    String? district,
    String? postalCode,
    String? country,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      addressType: addressType ?? this.addressType,
      unitNumber: unitNumber ?? this.unitNumber,
      buildingName: buildingName ?? this.buildingName,
      street: street ?? this.street,
      city: city ?? this.city,
      district: district ?? this.district,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }
}

enum AddressType {
  @JsonValue('House')
  home,
  @JsonValue('Apartment')
  work,
}
