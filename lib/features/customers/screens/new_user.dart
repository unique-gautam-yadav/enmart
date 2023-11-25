import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:string_validator/string_validator.dart';

import '../../../common/constant/app_collections.dart';

class NewUserDialog extends StatefulWidget {
  const NewUserDialog({
    super.key,
  });

  @override
  State<NewUserDialog> createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<NewUserDialog> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("New User"),
      content: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            const SizedBox(height: 35),
            CupertinoTextFormFieldRow(
              controller: nameController,
              placeholder: "Full Name",
              prefix: const Text("Name : "),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Enter users name";
                } else if (value!.length < 3) {
                  return "Name must have at least 3 chars";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CupertinoTextFormFieldRow(
              controller: emailController,
              placeholder: "E-Mail",
              prefix: const Text("Mail : "),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Enter user mail";
                } else if (!isEmail(value!)) {
                  return "Invalid mail";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CupertinoTextFormFieldRow(
              controller: passwordController,
              obscureText: true,
              placeholder: "Password",
              prefix: const Text("Password : "),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Enter password";
                } else if (value!.length < 6) {
                  return "Password must have 6 chars";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CupertinoTextFormFieldRow(
              obscureText: true,
              placeholder: "Repeat password",
              prefix: const Text("Re-Password : "),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return "Re enter password";
                } else if (value! != passwordController.text) {
                  return "Password did'nt matched";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: isLoading
              ? null
              : () async {
                  if (formKey.currentState?.validate() ?? false) {
                    setState(() {
                      isLoading = true;
                    });
                    await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text)
                        .then((value) async {
                      await usersCollection.doc(value.user!.uid).set({
                        'name': nameController.text,
                        'uid': value.user!.uid,
                      });
                    });
                    setState(() {
                      isLoading = true;
                    });
                    if (context.mounted) {
                      context.pop();
                    }
                  }
                },
          child: isLoading
              ? const CupertinoActivityIndicator()
              : const Text("Add"),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: isLoading
              ? null
              : () {
                  context.pop();
                },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
