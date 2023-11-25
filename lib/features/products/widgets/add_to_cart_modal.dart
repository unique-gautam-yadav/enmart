import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../common/models/order_model.dart';
import '../../cart/services/cart_provider.dart';

class AddToCartModal extends StatelessWidget {
  const AddToCartModal({
    super.key,
    required this.productId,
  });

  final String productId;

  @override
  Widget build(BuildContext context) {
    int n0 = 0, n1 = 0, n2 = 0, n3 = 0;

    var cartProvider = context.read<CartProvider>();
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(1),
        child: CupertinoActionSheet(
          title: const Text("Set Quantity"),
          message: SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderCounter(onValueChanged: (p0) => n3 = p0),
                SliderCounter(onValueChanged: (p0) => n2 = p0),
                SliderCounter(onValueChanged: (p0) => n1 = p0),
                SliderCounter(onValueChanged: (p0) => n0 = p0),
              ],
            ),
          ),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              context.pop();
            },
            isDestructiveAction: true,
            child: const Text("Cancel"),
          ),
          actions: [
            CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                if (int.parse('$n3$n2$n1$n0') <= 0) {
                  Fluttertoast.showToast(msg: "Must have at least one item.");
                } else {
                  Fluttertoast.showToast(
                      msg: "${int.parse('$n3$n2$n1$n0')} items added");
                  cartProvider.addToCart(
                    OrderModel(
                      orderId: "${DateTime.now().millisecondsSinceEpoch}",
                      successAt: DateTime.now(),
                      status: OrderStatus.inCart,
                      productId: productId,
                      quantity: int.parse('$n3$n2$n1$n0'),
                      dispatched: 0,
                    ),
                  );
                  context.pop();
                }
              },
              child: const Text("add to cart"),
            )
          ],
        ),
      ),
    );
  }
}

class SliderCounter extends StatefulWidget {
  const SliderCounter({
    super.key,
    this.onValueChanged,
  });

  @override
  State<SliderCounter> createState() => _SliderCounterState();
  final void Function(int)? onValueChanged;
}

class _SliderCounterState extends State<SliderCounter> {
  late FixedExtentScrollController cont;

  @override
  void initState() {
    super.initState();
    cont = FixedExtentScrollController(initialItem: 0);
  }

  int currentItem = 0;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CupertinoButton(
            child: const Icon(FontAwesomeIcons.sortUp),
            onPressed: () => animateToValue(true),
          ),
          SizedBox(
            height: 100,
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: cont,
              onSelectedItemChanged: widget.onValueChanged,
              looping: true,
              children:
                  List.generate(10, (index) => Center(child: Text("$index"))),
            ),
          ),
          CupertinoButton(
            child: const Icon(FontAwesomeIcons.sortDown),
            onPressed: () => animateToValue(false),
          ),
        ],
      ),
    );
  }

  void animateToValue(bool increase) {
    cont.animateToItem(cont.selectedItem + (increase ? 1 : -1),
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  @override
  void dispose() {
    cont.dispose();
    super.dispose();
  }
}
