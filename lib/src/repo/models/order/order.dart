import 'dart:convert';

import 'package:benji/src/repo/models/address/address_model.dart';
import 'package:benji/src/repo/models/product/product.dart';
import 'package:benji/src/repo/models/user/user_model.dart';
import 'package:benji/src/repo/models/vendor/vendor.dart';
import 'package:benji/src/repo/services/api_url.dart';
import 'package:benji/src/repo/utils/constants.dart';
import 'package:benji/src/repo/utils/helpers.dart';
import 'package:http/http.dart' as http;

// ignore_for_file: public_member_api_docs, sort_constructors_first

class Order {
  String id;
  String code;
  double totalPrice;
  double deliveryFee;
  double preTotal;
  String deliveryStatus;
  User client;
  List<OrderItem> orderitems;
  String created;
  BusinessModel business;
  Address deliveryAddress;

  Order({
    required this.id,
    required this.code,
    required this.totalPrice,
    required this.deliveryFee,
    required this.preTotal,
    required this.deliveryStatus,
    required this.client,
    required this.orderitems,
    required this.created,
    required this.business,
    required this.deliveryAddress,
  });

  factory Order.fromJson(Map<String, dynamic>? json) {
    print(json);
    json ??= {};
    return Order(
      id: json["id"] ?? notAvailable,
      code: json["code"] ?? notAvailable,
      totalPrice: json["total_price"] == null
          ? 0.0
          : double.parse(json["total_price"].toString()),
      deliveryFee: json["delivery_fee"] == null
          ? 0.0
          : double.parse(json["delivery_fee"].toString()),
      preTotal: json["pre_total"] == null
          ? 0.0
          : double.parse(json["pre_total"].toString()),
      deliveryStatus: json["delivery_status"] ?? "PEND",
      client: User.fromJson(json["client"]),
      orderitems: json["orderitems"] == null
          ? []
          : (json["orderitems"] as List)
              .map((item) => OrderItem.fromJson(item))
              .toList(),
      created: json["created"] ?? notAvailable,
      business: BusinessModel.fromJson(json["business"]),
      deliveryAddress: Address.fromJson(json["delivery_address"]),
    );
  }
}

class OrderItem {
  String id;
  Product product;
  int quantity;
  Address deliveryAddress;

  OrderItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.deliveryAddress,
  });

  factory OrderItem.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return OrderItem(
      id: json["id"] ?? notAvailable,
      product: Product.fromJson(json["product"]),
      deliveryAddress: Address.fromJson(json["delivery_address"]),
      quantity: json["quantity"] ?? 0,
    );
  }
}

Future<List<Order>> getOrders(id) async {
  final response = await http.get(
    Uri.parse('$baseURL/clients/listClientOrders/$id'),
    headers: await authHeader(),
  );
  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((item) => Order.fromJson(item))
        .toList();
  } else {
    return [];
  }
}
