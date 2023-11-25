import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:retailed_mart/common/constant/app_collections.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../routes/routes_const.dart';

class NPDUserList extends StatelessWidget {
  const NPDUserList({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Your NDPs"),
        previousPageTitle: "Home",
      ),
      child: Scaffold(
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.push(UserRoutes.newNDPRoute.path);
          },
          icon: const Icon(Icons.add),
          label: const Text("New"),
        ),
        body: SafeArea(
          child: CupertinoScrollbar(
            child: SingleChildScrollView(
              child: FirestoreDataTable(
                query: ndpCollection.where('uid',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid),
                columnLabels: const {
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
                    case 'imgUrl':
                      return SizedBox(
                        width: 35,
                        height: 35,
                        child: GestureDetector(
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                content: Image.network(
                                  snapshot.get('imgUrl'),
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("open in new tab"),
                                    onPressed: () {
                                      launchUrlString(snapshot.get('imgUrl'));
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text("close"),
                                    onPressed: () {
                                      context.pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Image.network(
                            snapshot.get('imgUrl'),
                          ),
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
                  log(propertyName);
                },
                showCheckboxColumn: false,
                canDeleteItems: false,
                rowsPerPage: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
