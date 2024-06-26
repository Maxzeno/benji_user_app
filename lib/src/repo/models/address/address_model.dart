import 'dart:convert';

import 'package:benji/src/repo/models/user/user_model.dart';
import 'package:benji/src/repo/services/api_url.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class Address {
  final String id;
  final String title;
  final String details;
  final String phone;
  final bool isCurrent;
  final String latitude;
  final String longitude;

  Address({
    required this.id,
    required this.title,
    required this.details,
    required this.phone,
    required this.isCurrent,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Address(
      id: json['id'] ?? '0',
      title: json['title'] ?? notAvailable,
      details: json['details'] ?? notAvailable,
      phone: json['phone'] ?? notAvailable,
      isCurrent: json['is_current'] ?? false,
      latitude: json['latitude'] ?? notAvailable,
      longitude: json['longitude'] ?? notAvailable,
    );
  }
}

Future<List<Address>> getAddressesByUser() async {
  int? userId = (await getUser() as User).id;

  final response = await http.get(
    Uri.parse('$baseURL/clients/listMyAddresses?user_id=$userId'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => Address.fromJson(item))
        .toList();
  } else {
    return [];
  }
}

Future<Address> getCurrentAddress() async {
  int? userId = (await getUser())!.id;

  final response = await http.get(
    Uri.parse('$baseURL/clients/getCurrentAddress/$userId'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return Address.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to get user address');
  }
}

Future<Address> setCurrentAddress(
  String addressId,
) async {
  int? userId = (await getUser())!.id;

  final response = await http.put(
    Uri.parse('$baseURL/clients/setCurrentAddress/$addressId?user_id=$userId'),
    headers: await authHeader(),
  );

  if (response.statusCode == 200) {
    return Address.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to set address');
  }
}

Future<bool> deleteAddress(
  String addressId,
) async {
  final response = await http.delete(
    Uri.parse('$baseURL/address/deleteAddress/$addressId/'),
    headers: await authHeader(),
  );
  print(response.body);
  return response.statusCode == 200;
}
