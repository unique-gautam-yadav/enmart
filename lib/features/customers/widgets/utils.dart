import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../common/models/user_model.dart';
import 'row_text.dart';

Future<dynamic> userInfoDialog(BuildContext context, UserModel model) {
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      // title: Text(model.fullName),
      content: Column(
        children: [
          RowText(title: "Full Name", value: model.fullName),
          RowText(title: "Mail", value: model.email),
          RowText(title: "Address", value: model.address),
          RowText(
            title: "Joined At",
            value: DateFormat.yMd().add_jm().format(model.createdAt),
          ),
        ],
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () {
            context.pop(context);
          },
          child: const Text("Ok"),
        ),
      ],
    ),
  );
}
