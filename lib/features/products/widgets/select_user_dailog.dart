import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:retailed_mart/common/constant/app_collections.dart';
import 'package:retailed_mart/common/models/user_model.dart';
import 'package:retailed_mart/features/customers/widgets/utils.dart';

class SelectUserDialog extends StatefulWidget {
  const SelectUserDialog({
    super.key,
    required this.onNext,
  });

  @override
  State<SelectUserDialog> createState() => _SelectUserDialogState();

  final void Function(UserModel model) onNext;
}

class _SelectUserDialogState extends State<SelectUserDialog> {
  UserModel? selectedModel;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Select user"),
      content: SizedBox(
        height: MediaQuery.sizeOf(context).height * .7,
        width: double.infinity,
        child: FirestoreListView(
          query: usersCollection.orderBy('fullName'),
          loadingBuilder: (context) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          },
          emptyBuilder: (context) {
            return const Text("You don't have any user");
          },
          itemBuilder: (context, doc) {
            UserModel model =
                UserModel.fromMap(doc.data() as Map<String, dynamic>);
            return CupertinoListTile(
              backgroundColor: model.uid == selectedModel?.uid
                  ? CupertinoColors.systemGrey3
                  : null,
              onTap: () {
                setState(() {
                  selectedModel = model;
                });
              },
              title: Text(model.fullName),
              additionalInfo: CupertinoButton(
                child: const Icon(CupertinoIcons.info),
                onPressed: () {
                  userInfoDialog(
                    context,
                    model,
                  );
                },
              ),
            );
          },
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: selectedModel == null
              ? null
              : () {
                  widget.onNext(selectedModel!);
                  context.pop();
                },
          child: const Text("next"),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text("cancel"),
          onPressed: () {
            context.pop();
          },
        ),
      ],
    );
  }
}
