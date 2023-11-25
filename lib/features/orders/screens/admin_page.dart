import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constant/app_collections.dart';
import '../../../common/models/order_model.dart';
import '../widgets/orders_page.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({super.key});

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  // String selected = "all";
  late PageController pageController;

  ValueNotifier selected = ValueNotifier<String>("all");

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
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              ValueListenableBuilder(
                  valueListenable: selected,
                  builder: (context, value, _) {
                    return CupertinoSegmentedControl(
                      groupValue: value,
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
                        selected.value = val as String;
                      },
                    );
                  }),
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    AllOrders(
                      query: ordersCollection,
                    ),
                    AllOrders(
                      query: ordersCollection.where(
                        'status',
                        isEqualTo: OrderStatus.pending.toString(),
                      ),
                    ),
                    AllOrders(
                      query: ordersCollection.where(
                        'status',
                        isEqualTo: OrderStatus.delivered.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pageTransition(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInToLinear);
  }
}
