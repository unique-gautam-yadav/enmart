import 'package:flutter/material.dart';

import '../../../common/models/order_model.dart';
import '../../orders/data.dart';
import '../../products/models/product_model.dart';

class OrderCard extends StatelessWidget {
  const OrderCard(
      {super.key,
      required this.e,
      this.columnItems,
      this.trailing,
      required this.isTable});

  final OrderModel e;
  final List<Widget>? columnItems;
  final Widget? trailing;
  final bool isTable;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: productById(e.productId),
      // future: null,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              width: double.infinity,
              height: 80,
              color: Colors.grey,
              margin: const EdgeInsets.symmetric(
                vertical: 5,
              ),
            );
          default:
            ProductModel model = snapshot.data!;
            // ProductModel model = ProductModel(
            //     id: 'id',
            //     code: 'code',
            //     material: 'material',
            //     quantity: 200,
            //     price: 200);
            return Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(1),
                6: FlexColumnWidth(1),
              },
              children: [
                TableRow(children: [
                  TableCell(child: Text(model.material)),
                  TableCell(child: Text(model.price.toStringAsFixed(2))),
                  TableCell(child: Text("${e.quantity}")),
                  TableCell(child: Text("${e.dispatched}")),
                  TableCell(
                      child:
                          Text((model.price * e.quantity).toStringAsFixed(2))),
                  TableCell(
                      child: Text(
                          "${((e.dispatched / e.quantity) * 100).toStringAsFixed(2)}%")),
                  TableCell(
                    child: trailing ?? const SizedBox.shrink(),
                  )
                ]),
              ],
            );
        }
      },
    );
  }
}
