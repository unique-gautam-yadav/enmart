import 'package:retailed_mart/common/constant/app_collections.dart';
import 'package:retailed_mart/common/models/order_model.dart';
import 'package:retailed_mart/common/models/user_model.dart';
import 'package:retailed_mart/features/products/models/product_model.dart';

Future<UserModel> userByUserId(String uId) async {
  DocumentSnapshot<Object?> d = await usersCollection.doc(uId).get();
  return UserModel.fromMap(d.data() as Map<String, dynamic>);
}

Future<ProductModel> productById(String productId) async {
  DocumentSnapshot<Object?> d = await productsCollection.doc(productId).get();

  return ProductModel.fromMap(d.data() as Map<String, dynamic>);
}

Future<double> productPriceById(String productId) async {
  DocumentSnapshot<Object?> d = await productsCollection.doc(productId).get();

  return ProductModel.fromMap(d.data() as Map<String, dynamic>).price;
}

Future<void> updateDispatchAmount({
  required String cartId,
  required OrderModel order,
  required int dispatched,
  required int totalCartQuantity,
  required int totalDispatchedCartQuantity,
}) async {
  await ordersCollection.doc(cartId).update({
    'items': FieldValue.arrayRemove([
      order.toMap(),
    ])
  });

  order.dispatched += dispatched;

  await ordersCollection.doc(cartId).update(
    {
      'items': FieldValue.arrayUnion([order.toMap()]),
      'deliveredQuantity': FieldValue.increment(dispatched),
      'status': totalCartQuantity == (totalDispatchedCartQuantity + dispatched)
          ? OrderStatus.delivered.toString()
          : OrderStatus.pending.toString(),
    },
  );
}
