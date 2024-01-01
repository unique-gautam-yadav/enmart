import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constant/app_collections.dart';
import '../models/product_model.dart';
import 'custom_spacer.dart';

class NewItemDialog extends StatefulWidget {
  const NewItemDialog({
    super.key,
    this.copyOf,
    this.toUpdate = false,
  });

  final ProductModel? copyOf;
  final bool toUpdate;

  @override
  State<NewItemDialog> createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<NewItemDialog> {
  late TextEditingController codeController;
  late TextEditingController materialController;
  late TextEditingController quantityController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController(text: widget.copyOf?.code ?? "");
    materialController =
        TextEditingController(text: widget.copyOf?.material ?? "");
    quantityController =
        TextEditingController(text: "${widget.copyOf?.quantity ?? ""}");
    priceController =
        TextEditingController(text: "${widget.copyOf?.price ?? ""}");
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("New Product"),
      content: Container(
        margin: const EdgeInsets.only(top: 25),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: .3),
        ),
        child: Column(
          children: [
            CupertinoTextField.borderless(
              placeholder: "FG Code",
              controller: codeController,
            ),
            const CustomSpacer(),
            CupertinoTextField.borderless(
              placeholder: "Material Detail",
              controller: materialController,
            ),
            const CustomSpacer(),
            CupertinoTextField.borderless(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              placeholder: "Quantity",
              controller: quantityController,
            ),
            const CustomSpacer(),
            CupertinoTextField.borderless(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              placeholder: "Price",
              controller: priceController,
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () async {
            if (codeController.text.isEmpty ||
                materialController.text.isEmpty ||
                quantityController.text.isEmpty ||
                priceController.text.isEmpty) {
              Fluttertoast.showToast(
                  msg:
                      'all the above fields are required. Please enter all the credentials then continue.');
              return;
            }
            setState(() {
              isLoading = true;
            });
            String id = widget.toUpdate
                ? widget.copyOf!.id
                : DateTime.now().millisecondsSinceEpoch.toString();

            ProductModel m = ProductModel(
              id: id,
              code: codeController.text,
              material: materialController.text,
              price: double.tryParse(priceController.text) ?? 0,
              quantity: int.tryParse(quantityController.text) ?? 0,
              specialUsers: [],
            );
            if (widget.toUpdate) {
              await productsCollection.doc(widget.copyOf!.id).update(m.toMap());
            } else {
              await productsCollection
                  .doc(widget.toUpdate ? widget.copyOf!.id : id)
                  .set(m.toMap());
            }
            if (widget.toUpdate) {
              setState(() {
                isLoading = false;
              });
              widget.copyOf?.code = codeController.text;
              widget.copyOf?.material = materialController.text;
              widget.copyOf?.price = double.parse(priceController.text);
              widget.copyOf?.quantity = int.parse(quantityController.text);
            }
            if (context.mounted) {
              context.pop();
            }
          },
          child: isLoading
              ? const CupertinoActivityIndicator()
              : Text(widget.toUpdate ? "Update" : "Done"),
        ),
        CupertinoDialogAction(
          onPressed: isLoading
              ? null
              : () {
                  context.pop();
                },
          isDestructiveAction: true,
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
