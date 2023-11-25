import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

import '../../../common/constant/app_collections.dart';
import '../../../common/models/cart_order.dart';
import '../../../common/models/order_model.dart';
import '../../../routes/routes_const.dart';
import '../../orders/widgets/table_cell.dart';
import '../services/cart_provider.dart';
import '../widgets/order_card.dart';
import '../widgets/utils.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cartProvider = context.watch<CartProvider>();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Your Cart"),
        previousPageTitle: "Home",
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: cartProvider.products.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/empty.svg',
                            height: 200,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Here you'll find the cart items",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Go to products and add desired products to cart",
                          ),
                          const SizedBox(height: 50),
                          CupertinoButton(
                            child: const Text('goto products'),
                            onPressed: () {
                              context.push(
                                UserRoutes.productsRoute.path,
                                extra: "Your Cart",
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
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
                              headCell(''),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            ...cartProvider.products.map((e) => OrderCard(
                                  e: e,
                                  isTable: false,
                                ))
                          ],
                        ),
                      ),
                      Container(
                        // height: 80,
                        constraints: const BoxConstraints(
                          maxWidth: 600,
                          minWidth: 300,
                        ),
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        color: Colors.blueGrey.shade100.withOpacity(.5),
                        child: Center(
                          child: FractionallySizedBox(
                            widthFactor: 1,
                            child: CupertinoButton(
                              color: Colors.indigo,
                              child: const Text("Buy"),
                              onPressed: () async {
                                await cartToOrder(context, cartProvider);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> cartToOrder(
      BuildContext context, CartProvider cartProvider) async {
    bool add = false;
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      onConfirmBtnTap: () {
        add = true;
        context.pop();
      },
    );
    if (context.mounted) {
      if (add) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
        );
        DateTime dt = DateTime.now();
        await ordersCollection.doc(dt.millisecondsSinceEpoch.toString()).set(
              OrderCartModel(
                status: OrderStatus.pending,
                uid: FirebaseAuth.instance.currentUser!.uid,
                id: dt.millisecondsSinceEpoch.toString(),
                orderedAt: dt,
                items: cartProvider.products,
                totalQuantity: calculateQuantity(cartProvider.products),
                deliveredQuantity: 0,
              ).toMap(),
            );
        await cartProvider.clearCart();
        if (context.mounted) {
          context.pop();
          QuickAlert.show(context: context, type: QuickAlertType.success);
        }
      }
    }
  }
}
