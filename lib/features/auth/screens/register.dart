import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:string_validator/string_validator.dart';

import '../../../common/models/app_response.dart';
import '../../../routes/routes_const.dart';
import '../state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.all(30),
          constraints: const BoxConstraints(
            minWidth: 200,
            maxWidth: 450,
          ),
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Scrollbar(
              thumbVisibility: true,
              interactive: true,
              radius: const Radius.circular(0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(35),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const FittedBox(
                        child: Text(
                          "Welcome to PackEn",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Enter your mail";
                          } else if (!isEmail(value!)) {
                            return "Invalid mail";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.mail_rounded),
                          fillColor: Colors.indigo.shade50,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: fullNameController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Enter your name";
                          } else if (value!.length < 3) {
                            return "Name must have 3 chars.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Full Name",
                          prefixIcon: const Icon(Icons.person_rounded),
                          fillColor: Colors.indigo.shade50,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: addressController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Enter your address.";
                          } else if (value!.length < 6) {
                            return "Must have at least 6 chars";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Address",
                          prefixIcon: const Icon(Icons.location_city),
                          fillColor: Colors.indigo.shade50,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: TextFormField(
                                obscureText: true,
                                controller: passwordController,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return "Create password";
                                  } else if (value!.length < 6) {
                                    return "Password must have 6 chars";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  fillColor: Colors.indigo.shade50,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: TextFormField(
                                obscureText: true,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return "Enter your password again.";
                                  } else if (value != passwordController.text) {
                                    return "Password didn't matched";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Re-Password",
                                  fillColor: Colors.indigo.shade50,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Consumer<AuthProvider>(
                        builder: (context, value, _) {
                          return CupertinoButton(
                            onPressed: value.isLoading
                                ? null
                                : () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    processRegister(value, context);
                                  },
                            child: Container(
                              height: 45,
                              width: 500,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.indigo.shade900,
                                    Colors.indigo.shade700,
                                    Colors.indigo.shade500,
                                    Colors.indigo,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: value.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CupertinoActivityIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const FittedBox(
                                        child: Text(
                                          "Register",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 44,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      CupertinoButton(
                        child: const Text("Already have an account"),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void processRegister(AuthProvider value, BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      AppResponse res = await value.register(
        email: emailController.text,
        fulName: fullNameController.text,
        address: addressController.text,
        password: passwordController.text,
      );
      if (context.mounted) {
        if (res.hasError) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            animType: QuickAlertAnimType.slideInDown,
            title: res.msg,
            showCancelBtn: false,
            confirmBtnText: "Retry",
            confirmBtnColor: Colors.red,
            onConfirmBtnTap: () {
              context.pop();
            },
          );
        } else {
          if (value.isAdmin!) {
            context.go(AdminRoutes.adminHome.path);
          } else {
            context.go(UserRoutes.homeRoute.path);
          }
        }
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
