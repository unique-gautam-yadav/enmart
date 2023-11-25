import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../common/constant/app_collections.dart';
import '../../cart/services/cart_provider.dart';
import '../../customers/widgets/row_text.dart';
import '../models/product_model.dart';
import '../widgets/add_to_cart_modal.dart';

class UserProducts extends StatefulWidget {
  const UserProducts({super.key, required this.previous});

  @override
  State<UserProducts> createState() => _UserProductsState();

  final String previous;
}

class _UserProductsState extends State<UserProducts> {
  final ValueNotifier _segment = ValueNotifier(SearchType.code);
  String searchKeyWord = "";
  TextEditingController controller = TextEditingController();
  bool search = false;

  @override
  Widget build(BuildContext context) {
    var cartProvider = context.watch<CartProvider>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Products"),
        previousPageTitle: widget.previous,
      ),
      child: Material(
        color: CupertinoTheme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ProductSearchField(
                          segment: _segment,
                          controller: controller,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CupertinoButton(
                        onPressed: () {
                          if (controller.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Search Field can't be empty");
                          } else {
                            setState(() {
                              search = true;
                            });
                          }
                        },
                        child: const Text("Search"),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          controller.clear();
                          if (search) {
                            setState(() {
                              search = false;
                            });
                          }
                        },
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ProductView(
                  search: search,
                  segment: _segment,
                  controller: controller,
                  itemBuilder: (context, doc) {
                    ProductModel model = ProductModel.fromMap(
                        doc.data() as Map<String, dynamic>);
                    return SizedBox(
                      width: 500,
                      child: CupertinoListTile(
                        backgroundColor: Colors.white,
                        title: Text(model.code),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RowText(
                              title: "Material",
                              value: model.material,
                            ),
                            RowText(
                              title: "Price",
                              value: model.price.toStringAsFixed(2),
                            ),
                          ],
                        ),
                        trailing: cartProvider.products
                                .where(
                                    (element) => element.productId == model.id)
                                .isNotEmpty
                            ? const Icon(Icons.done)
                            : CupertinoButton(
                                child: const Icon(
                                    CupertinoIcons.cart_fill_badge_plus),
                                onPressed: () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => AddToCartModal(
                                      productId: model.id,
                                    ),
                                  );
                                },
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchT() {
    //
  }

  @override
  void dispose() {
    controller.dispose();
    _segment.dispose();
    super.dispose();
  }
}

class ProductView extends StatelessWidget {
  const ProductView({
    super.key,
    required this.search,
    required ValueNotifier segment,
    required this.controller,
    required this.itemBuilder,
  }) : _segment = segment;

  final bool search;
  final ValueNotifier _segment;
  final TextEditingController controller;
  final Widget Function(BuildContext, QueryDocumentSnapshot<Object?>)
      itemBuilder;

  @override
  Widget build(BuildContext context) {
    return FirestoreListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      query: search
          ? productsCollection
              .where(
                _segment.value == SearchType.code ? 'code' : 'material',
                isGreaterThanOrEqualTo: controller.text,
              )
              .where(_segment.value == SearchType.code ? 'code' : 'material',
                  isLessThan: '${controller.text}z')
          : productsCollection.orderBy('code'),
      emptyBuilder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  child: SvgPicture.asset(
                "assets/svg/empty.svg",
                width: 250,
              )),
              const SizedBox(height: 60),
              FittedBox(
                child: Text(
                  search ? "Try changing keywords" : "You'll find items here ",
                  style: const TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              FittedBox(
                  child: Text(search
                      ? "There is no item with such keywords in the products list"
                      : "no items added till now, contact admin."))
            ],
          ),
        ),
      ),
      loadingBuilder: (_) => const SizedBox(
        height: 55,
        width: 55,
        child: CupertinoActivityIndicator(),
      ),
      itemBuilder: itemBuilder,
    );
  }
}

enum SearchType {
  code,
  material,
}

class ProductSearchField extends StatefulWidget {
  const ProductSearchField({
    super.key,
    required this.segment,
    required this.controller,
  });

  @override
  State<ProductSearchField> createState() => _ProductSearchFieldState();
  final ValueNotifier segment;
  final TextEditingController controller;
}

class _ProductSearchFieldState extends State<ProductSearchField> {
  @override
  Widget build(BuildContext context) {
    return CupertinoSearchTextField(
      controller: widget.controller,
      suffixIcon: const Icon(CupertinoIcons.line_horizontal_3_decrease),
      suffixMode: OverlayVisibilityMode.always,
      onSuffixTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: const Text("Select Filter to be added on..."),
              message: ValueListenableBuilder(
                  valueListenable: widget.segment,
                  builder: (context, value, _) {
                    return CupertinoSegmentedControl(
                      groupValue: value,
                      onValueChanged: (_) {
                        widget.segment.value = _;
                      },
                      children: const {
                        SearchType.code: Text("Product Code"),
                        SearchType.material: Text("Material"),
                      },
                    );
                  }),
              actions: const [],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  context.pop();
                },
                child: const Text("Ok"),
              ),
            );
          },
        );
      },
    );
  }
}
