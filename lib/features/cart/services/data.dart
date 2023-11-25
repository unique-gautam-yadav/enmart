import 'package:retailed_mart/common/constant/app_collections.dart';

import '../../products/models/product_model.dart';

Future<ProductModel> productById(String id) async {
  DocumentSnapshot<Object?> d = await productsCollection.doc(id).get();
  return ProductModel.fromMap(d.data() as Map<String, dynamic>);
}
