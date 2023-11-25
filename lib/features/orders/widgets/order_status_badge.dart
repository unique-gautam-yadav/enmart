import 'package:flutter/material.dart';

import '../../../common/models/order_model.dart';
import 'utils.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({
    super.key,
    required this.status,
  });
  final OrderStatus status;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 21,
      decoration: BoxDecoration(
        color: orderStatusToColor(status),
        borderRadius: BorderRadius.circular(40),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
      child: Text(
        orderStatusToString(status),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
