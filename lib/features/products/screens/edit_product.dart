import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(productModel.code),
        previousPageTitle: "Products",
        trailing: PopupMenuButton(
          elevation: .3,
          shadowColor: Colors.white,
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                  delegate: SliverChildListDelegate([
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
                  child: Column(
                    children: [
                      const Text(
                        "Buyers / Customers",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Wrap(
                          spacing: 25,
                          alignment: WrapAlignment.center,
                          children: [
                            ...List.generate(40, (index) => "Customer $index")
                                .map<Widget>(
                                  (e) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    width: 400,
                                    height: 50,
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
                                    child: Center(
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ])),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> reloadProduct() async {
    return productsCollection.doc(widget.model.id).get().then((value) {
      productModel = ProductModel.fromMap(value.data() as Map<String, dynamic>);
      setState(() {});
    });
  }
}
