import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constant/app_collections.dart';
import '../models/product_model.dart';
import 'new_item_dialog.dart';

showConfirmationDelete(BuildContext context, {required String id}) {
  showCupertinoDialog(
    context: context,
    builder: (_) => CupertinoAlertDialog(
      title: const Text("Are you sure?"),
      content: const Text(
          "You will lost all the orders and the data about this product. Do you want to continue?"),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text("Yes"),
          onPressed: () {
            context.pop();
            context.pop();
            productsCollection.doc(id).delete().then(
                (value) => Fluttertoast.showToast(msg: '$id Product Deleted'));
          },
        ),
        CupertinoDialogAction(
          child: const Text("Cancel"),
          onPressed: () {
            context.pop();
          },
        ),
      ],
    ),
  );
}



Future<dynamic> addNewItem(BuildContext context, {ProductModel? copyOf}) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => NewItemDialog(
      copyOf: copyOf,
    ),
  );
}

Future<dynamic> updateItem(BuildContext context,
    {required ProductModel product}) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => NewItemDialog(
      copyOf: product,
      toUpdate: true,
    ),
  );
}


