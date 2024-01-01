import 'package:retailed_mart/common/constant/app_collections.dart';
import 'package:retailed_mart/features/products/models/product_model.dart';

Future<void> setSpecialPrice(
    {required SpecialPriceModel model, required String productId}) async {
  await productsCollection
      .doc(productId)
      .update({'specialUsers.${model.userId}': model.price});
}
