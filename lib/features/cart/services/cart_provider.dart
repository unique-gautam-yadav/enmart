// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retailed_mart/common/constant/app_collections.dart';
import 'package:retailed_mart/common/models/order_model.dart';

class CartProvider extends ChangeNotifier {
  List<OrderModel> _products = [];

  Future<void> initialize() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await cartCollection.doc(uid).get().then((value) {
      if (value.exists) {
        log((value.data() as Map<String, dynamic>).toString());

        var map = value.data() as Map<String, dynamic>;

        _products = List<OrderModel>.from(
          (map['items'] as List<dynamic>).map<OrderModel>(
            (x) => OrderModel.fromMap(x as Map<String, dynamic>),
          ),
        );
      }
    });
  }

  List<OrderModel> get products => _products;

  addToCart(OrderModel order) async {
    try {
      await cartCollection.doc(FirebaseAuth.instance.currentUser?.uid).update(
        {
          'items': FieldValue.arrayUnion([order.toMap()]),
        },
      );
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        await cartCollection.doc(FirebaseAuth.instance.currentUser?.uid).set(
          {
            'items': FieldValue.arrayUnion([order.toMap()]),
          },
        );
      }
    }
    _products.add(order);
    notifyListeners();
  }

  Future<void> clearCart() async {
    _products.clear();
    notifyListeners();
    await cartCollection.doc(FirebaseAuth.instance.currentUser?.uid).delete();
  }
}
