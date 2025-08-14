// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      addressType: $enumDecode(_$AddressTypeEnumMap, json['addressType']),
      unitNumber: json['unitNumber'] as String,
      buildingName: json['buildingName'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'addressType': _$AddressTypeEnumMap[instance.addressType]!,
      'unitNumber': instance.unitNumber,
      'buildingName': instance.buildingName,
      'street': instance.street,
      'city': instance.city,
      'district': instance.district,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'isDefault': instance.isDefault,
    };

const _$AddressTypeEnumMap = {
  AddressType.home: 'House',
  AddressType.work: 'Apartment',
};
