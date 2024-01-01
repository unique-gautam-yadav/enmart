import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:string_validator/string_validator.dart';

import '../../../common/models/app_response.dart';
import '../../../routes/routes_const.dart';
import '../state/state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                          "Login to continue",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
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
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Enter your password";
                          } else if (value!.length < 6) {
                            return "Must have at least 6 chars";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.lock_rounded),
                          fillColor: Colors.indigo.shade50,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 55),
                      Consumer<AuthProvider>(
                        builder: (context, value, _) {
                          return CupertinoButton(
                            onPressed: value.isLoading
                                ? null
                                : () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    processLogin(value, context);
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
                                    ? const CupertinoActivityIndicator(
                                        color: Colors.white,
                                      )
                                    : const FittedBox(
                                        child: Text(
                                          "Login",
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
                        child: const Text("Don't have an account"),
                        onPressed: () {
                          context.push(AppRoutes.registerRoute.path);
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

  Future<void> processLogin(AuthProvider value, BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      AppResponse res = await value.login(
        email: emailController.text,
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
    super.dispose();
  }
}
