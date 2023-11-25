import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constant/app_collections.dart';
import '../../../common/models/order_model.dart';
import '../widgets/orders_page.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({super.key});

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  String selected = "all";
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("Orders"),
          previousPageTitle: "Home",
        ),
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                CupertinoSegmentedControl(
                  groupValue: selected,
                  children: const {
                    'all': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("All"),
                    ),
                    'pending': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Pending"),
                    ),
                    'finished': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("Delivered"),
                    ),
                  },
                  onValueChanged: (val) {
                    switch (val) {
                      case 'all':
                        pageTransition(0);
                        break;
                      case 'pending':
                        pageTransition(1);
                        break;
                      case 'finished':
                        pageTransition(2);
                        break;
                      default:
                    }
                    setState(() {
                      selected = val;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: [
                      AllOrders(
                        query: ordersCollection.where(
                          'uid',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                        ),
                        isUser: true,
                      ),
                      AllOrders(
                        query: ordersCollection
                            .where(
                              'uid',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                            )
                            .where(
                              'status',
                              isEqualTo: OrderStatus.pending.toString(),
                            ),
                        isUser: true,
                      ),
                      AllOrders(
                        query: ordersCollection
                            .where(
                              'uid',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                            )
                            .where(
                              'status',
                              isEqualTo: OrderStatus.delivered.toString(),
                            ),
                        isUser: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void pageTransition(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInToLinear);
  }
}
