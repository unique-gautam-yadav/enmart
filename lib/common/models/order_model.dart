// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  inCart,
  delivered,
  
  pending,
}

class OrderModel {
  String orderId;
  DateTime successAt;
  OrderStatus status;
  String productId;
  int quantity;
  int dispatched;
  OrderModel({
    required this.orderId,
    required this.successAt,
    required this.status,
    required this.productId,
    required this.quantity,
    required this.dispatched,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'successAt': Timestamp.fromDate(successAt),
      'status': status.toString(),
      'productId': productId,
      'quantity': quantity,
      'dispatched': dispatched,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] as String,
      successAt: (map['successAt'] as Timestamp).toDate(),
      status: stringToStatusEnum(map['status']),
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
      dispatched: int.tryParse("${map['dispatched']}") ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

OrderStatus stringToStatusEnum(String value) {
  return switch (value) {
    'OrderStatus.inCart' => OrderStatus.inCart,
    'OrderStatus.delivered' => OrderStatus.delivered,
    // 'OrderStatus.partiallyDelivered' => OrderStatus.partiallyDelivered,
    // 'OrderStatus.canceled' => OrderStatus.canceled,
    // 'OrderStatus.rejected' => OrderStatus.rejected,
    // 'OrderStatus.pendingDelivery' => OrderStatus.pendingDelivery,
    'OrderStatus.pending' => OrderStatus.pending,
    String() => OrderStatus.pending,
    // String() => OrderStatus.canceled,
  };
}
