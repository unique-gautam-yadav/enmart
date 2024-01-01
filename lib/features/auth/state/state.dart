import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:retailed_mart/common/constant/app_collections.dart';
import 'package:retailed_mart/common/models/app_response.dart';
import 'package:retailed_mart/common/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool? _isAdmin;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool? get isAdmin => _isAdmin;
  User? get authUser => FirebaseAuth.instance.currentUser;

  Future<AppResponse> register({
    required String email,
    required String fulName,
    required String address,
    required String password,
  }) async {
    late AppResponse? response;
    _isLoading = true;
    notifyListeners();

    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      UserModel m = UserModel(
          email: email,
          uid: value.user!.uid,
          fullName: fulName,
          address: address,
          isApproved: false,
          createdAt: DateTime.now());
      await usersCollection.doc(value.user?.uid).set(m.toMap());
      _userModel = m;
      _isAdmin = false;
      response = AppResponse(msg: 'Success', hasError: false, data: m);
    }).catchError((e) {
      response = AppResponse(msg: e.message ?? e.code, hasError: true);
    });
    _isLoading = false;
    notifyListeners();

    return response ??
        AppResponse(msg: "Something went wrong!!", hasError: true);
  }

  Future<AppResponse> login(
      {required String email, required String password}) async {
    AppResponse res;

    _isLoading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      await getUserData();

      res = AppResponse(msg: "Success", hasError: false);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      res = AppResponse(msg: e.code.toUpperCase(), hasError: true);
    } catch (e) {
      res = AppResponse(msg: "Something went wrong", hasError: true);
    }

    _isLoading = false;
    notifyListeners();

    return res;
  }

  Future<void> getUserData() async {
    DocumentSnapshot<Object?> doc =
        await usersCollection.doc(_auth.currentUser?.uid).get();

    if (doc.exists) {
      _isAdmin = false;
      _userModel = UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      _isAdmin = true;
    }
    notifyListeners();
  }
}