import 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _db = FirebaseFirestore.instance;

CollectionReference usersCollection = _db.collection('users');
CollectionReference productsCollection = _db.collection('products');
CollectionReference ordersCollection = _db.collection('orders');
CollectionReference cartCollection = _db.collection('cart');
CollectionReference ndpCollection = _db.collection('ndp');
