
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../common/constant/app_collections.dart';
import '../../../common/models/user_model.dart';
import '../../customers/widgets/utils.dart';

class NDPAdminList extends StatelessWidget {
  const NDPAdminList({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("NDP orders"),
        previousPageTitle: "Home",
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: FirestoreDataTable(
            query: ndpCollection,
            columnLabels: const {
              'uid': Text("User Name"),
              'imgUrl': Text("Image"),
              'ofc': Text("OFC"),
              'input': Text("Input"),
              'quality': Text("Quality"),
              'packing': Text("Packing"),
              'decoration': Text("Decoration"),
              'coating': Text("Coating"),
              'printing': Text("Printing"),
              'frosting': Text("Frosting"),
              'hfs': Text("HFS"),
              'other': Text("Other"),
              'moq': Text("MOQ"),
              'annualRequirement': Text("Annual\nRequirement"),
              'remarks': Text("Remarks"),
              'dateTime': Text("Added at"),
            },
            cellBuilder: (snapshot, colKey) {
              switch (colKey) {
                case 'uid':
                  return FutureBuilder(
                    future: userNameByUid(snapshot.get('uid')),
                    builder: (context, snapshot) {
                      UserModel? m = snapshot.data;

                      return MaterialButton(
                          onPressed: m == null
                              ? null
                              : () {
                                  userInfoDialog(context, m);
                                },
                          child: Text(m?.fullName ?? "Loading..."));
                    },
                  );
                case 'imgUrl':
                  return SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.network(
                      snapshot.get('imgUrl'),
                    ),
                  );
                case 'dateTime':
                  return Text(
                    DateFormat.yMEd().format(
                      DateTime.fromMillisecondsSinceEpoch(
                        snapshot.get('dateTime'),
                      ),
                    ),
                  );
                default:
                  return Text(snapshot.get(colKey).toString());
              }
            },
            onTapCell: (snapshot, value, propertyName) {
              if (propertyName == "imgUrl") {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Image.network(snapshot.get('imgUrl')),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text("close"),
                      )
                    ],
                  ),
                );
              }
            },
            showCheckboxColumn: false,
            canDeleteItems: false,
            rowsPerPage: 20,
          ),
        ),
      ),
    );
  }
}

Future<UserModel> userNameByUid(String uid) async {
  DocumentSnapshot<Object?> d = await usersCollection.doc(uid).get();
  return UserModel.fromMap(d.data() as Map<String, dynamic>);
}
