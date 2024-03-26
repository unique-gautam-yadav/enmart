import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excel/excel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:retailed_mart/common/constant/app_collections.dart';
import 'package:retailed_mart/features/products/screens/user_product.dart';

import '../../../routes/routes_const.dart';
import '../../customers/widgets/row_text.dart';
import '../models/product_model.dart';
import '../widgets/utils.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({super.key});

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  bool search = false;
  final ValueNotifier _segment = ValueNotifier(SearchType.code);
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Products"),
        previousPageTitle: "Home",
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CupertinoButton(
              child: const Icon(CupertinoIcons.cloud_download),
              onPressed: () {
                pickExcelAndDecode(context);
              },
            ),
            CupertinoButton(
              child: const Icon(CupertinoIcons.add),
              onPressed: () {
                addNewItem(context);
              },
            ),
          ],
        ),
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
                        onTap: () {
                          context.push(AppRoutes.editProduct.path,
                              extra: model);
                        },
                        leadingSize: 60,
                        backgroundColor: Colors.white,
                        leading: Container(
                          height: 40,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: CupertinoColors.activeBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  model.quantity.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // onTap: () {
                        //   context.push(AppRoutes.editProduct.path, extra: model);
                        // },
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

  @override
  void dispose() {
    controller.dispose();
    _segment.dispose();
    super.dispose();
  }
}

// pickExcelAndDecode(BuildContext context) async {
//   QuickAlert.show(context: context, type: QuickAlertType.loading);
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['xlsx'],
//     allowMultiple: false,
//   );

//   if (result != null) {
//     log(result.files.single.path.toString());

//     var bytes = File(result.files.single.path!).readAsBytesSync();

//     var excel = Excel.decodeBytes(bytes);

//     for (var table in excel.tables.keys) {
//       for (var row in excel.tables[table]?.rows ?? []) {
//         for (var i = 0; i < (excel.tables[table]?.maxCols ?? 0); i++) {
//           try {
//             // TODO: row to data here

//             // productsCollection.doc(DateTime.now().millisecondsSinceEpoch.toString())

//             // productsCollection.doc(DateTime.now().mii)
//           } catch (e) {
//             // TODO: Just skip
//             print(e.toString());
//           }
//           log("${(row as List<Data?>)[i]?.value}");
//         }
//       }
//     }
//   } else {
//     // User canceled the picker
//   }

//   if (context.mounted) {
//     context.pop();
//   }
// }
pickExcelAndDecode(BuildContext context) async {
  QuickAlert.show(context: context, type: QuickAlertType.loading);

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
    allowMultiple: false,
  );

  if (result != null) {
    log(result.files.single.path.toString());

    try {
      var bytes = File(result.files.single.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      CollectionReference productsCollection =
          FirebaseFirestore.instance.collection('products');

      for (var tableName in excel.tables.keys) {
        var table = excel.tables[tableName];

        if (table != null) {
          // Check if header row exists
          if (table.rows.isNotEmpty) {
            // Use first row as headers if available
            var headers = table.rows.first.map((cell) => cell?.value as String).toList();

            for (int i = 1; i < table.rows.length; i++) {
              try {
                var row = table.rows[i];
                var data = Map<String, dynamic>();

                // Extract data using column indices if no headers
                for (int j = 0; j < table.maxCols; j++) {
                  var value = row[j]?.value;

                  // Handle missing values and data types gracefully
                  data['column_${j + 1}'] = value; // Use placeholders for now
                }

                // Create ProductModel (adapt based on your actual structure)
                var product = ProductModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(), code: '', material: '', quantity: 0, price: 0, specialUsers: [],
                  // ... other required fields based on data and model
                );

                await productsCollection.add(product.toMap());
              } catch (e) {
                print("Error processing row: ${e.toString()}");
              }
            }
          } else {
            print("Missing header row in table: $tableName");
            // Handle missing headers as needed (e.g., skip table, prompt user)
          }
        }
      }
    } on UnsupportedError {
      print("Unsupported file format. Please select an Excel file.");
    } catch (e) {
      print("An error occurred: ${e.toString()}");
    }

    context.pop(); // Close loading dialog
  } else {
    // User canceled the picker
  }
}



























// Future<void> pickExcelAndDecode(BuildContext context) async {
//   QuickAlert.show(context: context, type: QuickAlertType.loading);

//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['xlsx'],
//     allowMultiple: false,
//   );

//   if (result != null) {
//     log(result.files.single.path.toString());

//     try {
//       var bytes = File(result.files.single.path!).readAsBytesSync();
//       var excel = Excel.decodeBytes(bytes);

//       var table = excel.tables.values.first;

//       await Firebase.initializeApp(); // Initialize Firebase if not already done

//       CollectionReference productsCollection = FirebaseFirestore.instance.collection('products');

//       for (var row in table.rows) {
//         try {
//           var data = Map<String, dynamic>();

//           for (int i = 0; i < table.maxCols; i++) {
//             var cellValue = row[i]?.value;

//             if (cellValue is Formula) {
//               cellValue = cellValue.formula;
//             }

//             var header = table.rows.first[i]?.value; // Assuming header is in the first row
//             if (header != null) {
//               data[header] = cellValue;
//             } else {
//               print("Missing header for column ${i}");
//             }
//           }

//           await productsCollection.add(data);
//         } catch (e) {
//           print("Error processing row: ${e.toString()}");
//         }
//       }
//     } on UnsupportedError {
//     } catch (e) {
//       print("An error occurred: ${e.toString()}");
//     }
//   } else {
//   }
// }
