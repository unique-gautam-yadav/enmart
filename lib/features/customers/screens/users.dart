import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constant/app_collections.dart';
import '../../../common/models/user_model.dart';
import '../widgets/no_user.dart';
import '../widgets/utils.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: "Home",
        middle: Text("Users"),
      ),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: FirestoreListView(
            physics: const BouncingScrollPhysics(),
            query: usersCollection,
            emptyBuilder: (_) => const NoUserColumn(),
            itemBuilder: (context, doc) {
              UserModel model =
                  UserModel.fromMap(doc.data() as Map<String, dynamic>);
              return CupertinoListTile(
                // onTap: () {},
                title: Text(model.fullName),
                leading: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: model.isApproved ? Colors.indigo : Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: FittedBox(
                    child: Text(
                      model.fullName.characters.first,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                      ),
                    ),
                  ),
                ),
                subtitle: Text("${model.email} || ${model.address}"),
                // additionalInfo: Text(model.address),
                leadingToTitle: 10,
                additionalInfo: CupertinoSwitch(
                    value: model.isApproved,
                    onChanged: (_) async {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      await usersCollection
                          .doc(model.uid)
                          .update({'isApproved': !model.isApproved});
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("${model.fullName} status changed")));
                      }
                    }),
                trailing: CupertinoButton(
                  onPressed: () {
                    userInfoDialog(context, model);
                  },
                  child: const Icon(CupertinoIcons.forward),
                ),
                leadingSize: 100,
              );
            },
          ),
        ),
      ),
    );
  }
}
