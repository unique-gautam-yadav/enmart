import '../../../common/models/order_model.dart';

calculateQuantity(List<OrderModel> e) {
  int amt = 0;
  for (var element in e) {
    amt += element.quantity;
  }
  return amt;
}
