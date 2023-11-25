import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../common/models/cart_order.dart';
import '../../../common/models/order_model.dart';
import '../../customers/widgets/row_text.dart';
import '../data.dart';

class QuantityUpdate extends StatefulWidget {
  const QuantityUpdate({
    super.key,
    required this.e,
    required this.m,
  });

  final OrderModel e;
  final OrderCartModel m;

  @override
  State<QuantityUpdate> createState() => _QuantityUpdateState();
}

class _QuantityUpdateState extends State<QuantityUpdate> {
  bool isLoading = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int rem = widget.e.quantity - widget.e.dispatched;
    return CupertinoAlertDialog(
      title: const Text(
        "Dispatched quantity",
      ),
      content: Column(
        children: [
          const SizedBox(height: 20),
          RowText(title: "Remaining Quantity", value: "$rem"),
          const SizedBox(height: 10),
          CupertinoTextField(
            placeholder: "Dispatch Quantity",
            controller: controller,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: isLoading
              ? null
              : () async {
                  await updateMethod();
                },
          child:
              isLoading ? const CupertinoActivityIndicator() : const Text("Ok"),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            context.pop();
          },
          child: const Text(
            "Cancel",
          ),
        ),
      ],
    );
  }

  Future<void> updateMethod() async {
    setState(() {
      isLoading = true;
    });
    await updateDispatchAmount(
      order: widget.e,
      dispatched: int.parse(controller.text),
      cartId: widget.m.id,
      totalCartQuantity: widget.m.totalQuantity,
      totalDispatchedCartQuantity: widget.m.deliveredQuantity,
    );
    setState(() {
      isLoading = false;
    });
    if (context.mounted) {
      context.pop();
    }
  }
}
