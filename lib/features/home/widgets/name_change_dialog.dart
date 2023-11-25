import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NameChangeDialog extends StatefulWidget {
  const NameChangeDialog({
    super.key,
  });

  @override
  State<NameChangeDialog> createState() => _NameChangeDialogState();
}

class _NameChangeDialogState extends State<NameChangeDialog> {
  bool isLoading = false;

  String newName = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => isLoading,
      child: CupertinoAlertDialog(
        title: const Text("Change display name"),
        content: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CupertinoTextFormFieldRow(
            onChanged: (value) {
              newName = value;
            },
            placeholder: "Display Name",
            decoration: BoxDecoration(
              border: Border.all(color: CupertinoColors.systemGrey4),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          SizedBox(
            width: 555,
            child: CupertinoDialogAction(
              onPressed: isLoading
                  ? null
                  : () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseAuth.instance.currentUser
                          ?.updateDisplayName(newName);

                      await FirebaseAuth.instance.currentUser?.reload();
                      setState(() {
                        isLoading = false;
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Name changed restart application to show changes..."),
                          backgroundColor: Colors.green,
                        ));
                        context.pop();
                      }
                    },
              child: isLoading
                  ? const CupertinoActivityIndicator()
                  : const Text("Ok, change it"),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Cancel"),
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              context.pop();
            },
          )
        ],
      ),
    );
  }
}
 