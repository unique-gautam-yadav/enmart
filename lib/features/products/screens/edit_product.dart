import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retailed_mart/common/models/user_model.dart';
import 'package:retailed_mart/features/products/widgets/select_user_dailog.dart';
import 'package:retailed_mart/features/products/widgets/special_user_card.dart';

import '../../../common/constant/app_collections.dart';
import '../../customers/widgets/row_text.dart';
import '../models/product_model.dart';
import '../widgets/utils.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key, required this.model});

  final ProductModel model;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late ProductModel productModel;
  @override
  void initState() {
    super.initState();
    productModel = widget.model;
  }

  ValueNotifier<bool> reloadNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(productModel.code),
        previousPageTitle: "Products",
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ValueListenableBuilder(
              valueListenable: reloadNotifier,
              builder: (context, value, child) {
                return Center(
                  child: AnimatedScale(
                      scale: value ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const CupertinoActivityIndicator()),
                );
              },
            ),
            PopupMenuButton(
              elevation: .3,
              shadowColor: Colors.white,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: const Text("Duplicate"),
                    onTap: () => addNewItem(context, copyOf: productModel),
                  ),
                  PopupMenuItem(
                    child: const Text("Update"),
                    onTap: () {
                      updateItem(context, product: productModel);
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("Delete"),
                    onTap: () {
                      showConfirmationDelete(context, id: widget.model.id);
                    },
                  ),
                  PopupMenuItem(
                    child: const Text("Refresh"),
                    onTap: () {
                      reloadProduct();
                    },
                  ),
                ];
              },
            ),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  await reloadProduct();
                },
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Wrap(
                        children: [
                          SizedBox(
                            width: 350,
                            child: RowText(
                              fontSize: 22,
                              title: "Price",
                              value: productModel.price.toStringAsFixed(2),
                            ),
                          ),
                          SizedBox(
                            width: 350,
                            child: RowText(
                              fontSize: 22,
                              title: "Quantity",
                              value: productModel.quantity.toString(),
                            ),
                          ),
                          RowText(
                            fontSize: 22,
                            title: "Material",
                            value: productModel.material,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(),
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 30),
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Discount",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Icon(Icons.add),
                              onPressed: () {
                                addNewUser(context, productId: productModel.id);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Wrap(
                        spacing: 25,
                        alignment: WrapAlignment.center,
                        children: [
                          ...productModel.specialUsers
                              .map<Widget>(
                                (e) => SpecialPriceCard(
                                  e: e,
                                  productId: productModel.id,
                                  refreshMethod: reloadProduct,
                                ),
                              )
                              .toList(),
                        ],
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

  Future<void> reloadProduct() async {
    reloadNotifier.value = true;
    await productsCollection.doc(widget.model.id).get().then((value) {
      productModel = ProductModel.fromMap(value.data() as Map<String, dynamic>);
      setState(() {});
    });
    reloadNotifier.value = false;
  }

  void addNewUser(BuildContext context, {required String productId}) async {
    UserModel? selectedModel;
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return SelectUserDialog(
          onNext: (model) {
            selectedModel = model;
          },
        );
      },
    );
    if (selectedModel != null) {
      if (context.mounted) {
        updatePrice(
          context,
          productId: productId,
          refreshMethod: reloadProduct,
          userId: selectedModel!.uid,
          userName: selectedModel!.fullName,
        );
      }
    }
  }

  @override
  void dispose() {
    reloadNotifier.dispose();
    super.dispose();
  }
}
