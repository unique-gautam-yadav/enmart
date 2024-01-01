import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  String id;
  String code;
  String material;
  int quantity;
  num price;
  List<SpecialPriceModel> specialUsers;

  ProductModel({
    required this.id,
    required this.code,
    required this.material,
    required this.quantity,
    required this.price,
    required this.specialUsers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'material': material,
      'quantity': quantity,
      'price': price,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
        id: "${map['id']}",
        code: "${map['code']}",
        material: map['material'] as String,
        quantity: int.parse("${map['quantity'] ?? 0}"),
        price: double.tryParse("${map['price']}") ?? 0,
        specialUsers: generateSpecialPrice(map['specialUsers']));
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SpecialPriceModel {
  String userId;
  int? price;
  SpecialPriceModel({
    required this.userId,
    required this.price,
  });
}

List<SpecialPriceModel> generateSpecialPrice(Map<String, dynamic> map) {
  List<SpecialPriceModel> lst = [];

  for (var e in map.keys) {
    if (map[e] == null) {
      continue;
    }
    lst.add(SpecialPriceModel(userId: e, price: map[e]));
  }

  return lst;
}
