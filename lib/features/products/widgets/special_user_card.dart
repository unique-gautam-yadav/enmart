import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:retailed_mart/features/customers/widgets/row_text.dart';
import 'package:retailed_mart/features/customers/widgets/utils.dart';
import 'package:retailed_mart/features/orders/data.dart';
import 'package:retailed_mart/features/products/data/data.dart';
import 'package:retailed_mart/features/products/models/product_model.dart';

class SpecialPriceCard extends StatelessWidget {
  const SpecialPriceCard({
    super.key,
    required this.e,
    required this.productId,
    required this.refreshMethod,
  });

  final SpecialPriceModel e;
  final String productId;
  final VoidCallback refreshMethod;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userByUserId(e.userId),
      builder: (context, snapshot) {
        return Dismissible(
          confirmDismiss: (direction) async {
            bool con = false;
            await QuickAlert.show(
                context: context,
                type: QuickAlertType.confirm,
                onConfirmBtnTap: () {
                  con = true;
                  context.pop();
                });
            return con;
          },
          key: Key(e.userId),
          onDismissed: (direction) async {
            await setSpecialPrice(
                model: SpecialPriceModel(userId: e.userId, price: null),
                productId: productId);
            if (context.mounted) {
              QuickAlert.show(context: context, type: QuickAlertType.success);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: 400,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 0,
                  color: Colors.blueGrey,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RowText(
                      title: "User",
                      value: snapshot.data?.fullName ?? "Loading...",
                      fontSize: 15,
                    ),
                    Row(
                      children: [
                        RowText(
                          title: "Price",
                          value: e.price.toString(),
                          fontSize: 15,
                        ),
                        const SizedBox(width: 10),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: snapshot.data == null
                              ? null
                              : () {
                                  updatePrice(
                                    context,
                                    productId: productId,
                                    refreshMethod: refreshMethod,
                                    userName: snapshot.data!.fullName,
                                    userId: e.userId,
                                  );
                                },
                          child: const Text('edit'),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: snapshot.data == null
                          ? null
                          : () {
                              userInfoDialog(context, snapshot.data!);
                            },
                      child: const Icon(CupertinoIcons.info),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void updatePrice(
  BuildContext context, {
  required VoidCallback refreshMethod,
  required String productId,
  required String userName,
  required String userId,
}) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      String number = "0";
      bool isLoading = false;
      return StatefulBuilder(builder: (context, setS) {
        return CupertinoAlertDialog(
          title: Text("$userName Special Price"),
          content: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CupertinoTextField(
              placeholder: "Price",
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) {
                number = _;
              },
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: isLoading
                  ? null
                  : () async {
                      setS(() {
                        isLoading = true;
                      });
                      await setSpecialPrice(
                          model: SpecialPriceModel(
                              userId: userId, price: int.parse(number)),
                          productId: productId);
                      refreshMethod();
                      if (context.mounted) {
                        setS(() {
                          isLoading = false;
                        });
                        context.pop();
                      }
                    },
              child: isLoading
                  ? const CupertinoActivityIndicator()
                  : const Text("Ok"),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: isLoading
                  ? null
                  : () {
                      context.pop();
                    },
              child: const Text("cancel"),
            ),
          ],
        );
      });
    },
  );
}
