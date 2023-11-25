import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../common/constant/app_collections.dart';
import '../../../common/models/cart_order.dart';
import '../../../common/models/user_model.dart';
import '../../cart/widgets/order_card.dart';
import '../../customers/widgets/row_text.dart';
import '../../customers/widgets/utils.dart';
import '../data.dart';
import 'order_status_badge.dart';
import 'quantity_update.dart';
import 'table_cell.dart';
import 'utils.dart';

class AllOrders extends StatelessWidget {
  const AllOrders({super.key, required this.query, this.isUser = false});

  final Query<Object?> query;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      query: query,
      emptyBuilder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/empty.svg',
                height: 200,
              ),
              const Text(
                "No Orders",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "You will see orders here category wise",
              ),
            ],
          ),
        );
      },
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      itemBuilder: (context, doc) {
        OrderCartModel m =
            OrderCartModel.fromMap(doc.data() as Map<String, dynamic>);
        return FractionallySizedBox(
          widthFactor: 1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: FutureBuilder(
              future: isUser ? null : userByUserId(m.uid),
              builder: (context, userSnap) {
                UserModel? u = userSnap.data;
                return CupertinoListSection(
                    header: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OrderStatusBadge(
                          status: m.status,
                        ),
                        isUser
                            ? const SizedBox.shrink()
                            : u == null
                                ? const Text("Loading...")
                                : SizedBox(
                                    height: 35,
                                    child: Row(
                                      children: [
                                        Text(u.fullName),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            userInfoDialog(context, u);
                                          },
                                          child: const Icon(Icons.info_outline),
                                        )
                                      ],
                                    ),
                                  ),
                      ],
                    ),
                    footer: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          RowText(
                            title: "Ordered At",
                            value: DateFormat.yMEd().format(m.orderedAt),
                          ),
                          const Spacer(),
                          FutureBuilder(
                              future: calculateGrandTotal(m),
                              builder: (context, snapshot) {
                                return RowText(
                                  title: 'Grand Total',
                                  value: snapshot.data ?? "Loading...",
                                );
                              })
                        ],
                      ),
                    ),
                    children: [
                      Table(
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
                          TableRow(
                            children: [
                              headCell("Material"),
                              headCell("Price / Product"),
                              headCell("Quantity"),
                              headCell("Dispatched"),
                              headCell("Price"),
                              headCell("%"),
                              headCell("Action"),
                            ],
                          )
                        ],
                      ),
                      ...m.items
                          .map(
                            (e) => OrderCard(
                              e: e,
                              isTable: false,
                              columnItems: [
                                SizedBox(
                                  height: 15,
                                  child: Row(
                                    children: [
                                      RowText(
                                        title: 'Dispatched',
                                        value: e.dispatched.toString(),
                                      ),
                                      const Spacer(),
                                      RowText(
                                        title: "%",
                                        value:
                                            ((e.dispatched / e.quantity) * 100)
                                                .toStringAsFixed(2),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                              trailing: (e.dispatched == e.quantity || isUser)
                                  ? null
                                  : GestureDetector(
                                      onTap: () {
                                        showCupertinoDialog(
                                          context: context,
                                          builder: (_) => QuantityUpdate(
                                            e: e,
                                            m: m,
                                          ),
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Icon(
                                          CupertinoIcons.cloud_upload,
                                        ),
                                      ),
                                    ),
                            ),
                          )
                          .toList(),
                    ]);
              },
            ),
          ),
        );
      },
    );
  }
}
