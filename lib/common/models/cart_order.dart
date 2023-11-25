// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:retailed_mart/common/constant/app_collections.dart';
import 'package:retailed_mart/common/models/order_model.dart';

class OrderCartModel {
  String id;
  String uid;
  DateTime orderedAt;
  List<OrderModel> items;
  OrderStatus status;
  int totalQuantity;
  int deliveredQuantity;
  OrderCartModel({
    required this.id,
    required this.orderedAt,
    required this.items,
    required this.uid,
    required this.status,
    required this.totalQuantity,
    required this.deliveredQuantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'id': id,
      'orderedAt': Timestamp.fromDate(orderedAt),
      'items': items.map((x) => x.toMap()).toList(),
      'status': status.toString(),
      'totalQuantity': totalQuantity,
      'deliveredQuantity': deliveredQuantity,
    };
  }

  factory OrderCartModel.fromMap(Map<String, dynamic> map) {
    return OrderCartModel(
      status: stringToStatusEnum(map['status']),
      uid: map['uid'] as String,
      id: map['id'] as String,
      orderedAt: (map['orderedAt'] as Timestamp).toDate(),
      items: List<OrderModel>.from(
        (map['items'] as List<dynamic>).map<OrderModel>(
          (x) => OrderModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalQuantity: map['totalQuantity'] as int,
      deliveredQuantity: map['deliveredQuantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderCartModel.fromJson(String source) =>
      OrderCartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
