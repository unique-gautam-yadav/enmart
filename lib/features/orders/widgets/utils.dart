import 'package:flutter/material.dart';

import '../../../common/models/cart_order.dart';
import '../../../common/models/order_model.dart';
import '../data.dart';

String orderStatusToString(OrderStatus s) => switch (s) {
      OrderStatus.inCart => 'In Cart',
      OrderStatus.delivered => 'Delivered',
      // OrderStatus.partiallyDelivered => 'Partially Delivered',
      // OrderStatus.canceled => 'Canceled',
      // OrderStatus.rejected => 'Rejected',
      // OrderStatus.pendingDelivery => 'Pending Delivery',
      OrderStatus.pending => 'Pending',
    };
Color orderStatusToColor(OrderStatus s) => switch (s) {
      OrderStatus.inCart => Colors.indigo,
      OrderStatus.delivered => Colors.green,
      // OrderStatus.partiallyDelivered => Colors.lightGreen,
      // OrderStatus.canceled => Colors.red,
      // OrderStatus.rejected => Colors.red,
      // OrderStatus.pendingDelivery => Colors.yellow,
      OrderStatus.pending => Colors.deepOrange,
    };

Future<String> calculateGrandTotal(OrderCartModel m) async {
  double price = 0;
  for (var o in m.items) {
    double p = await productPriceById(o.productId);
    price += p * o.quantity;
  }
  return price.toStringAsFixed(2);
}
