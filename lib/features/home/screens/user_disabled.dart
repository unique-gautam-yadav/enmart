import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/routes_const.dart';
import '../widgets/gradient_button.dart';

class UserBlocked extends StatelessWidget {
  const UserBlocked({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 55),
              const FittedBox(
                child: Text.rich(
                  TextSpan(
                    text: "Not enabled,\n",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Colors.indigo,
                      height: .99,
                    ),
                    children: [
                      TextSpan(
                        text: "You're not enabled till now.",
                        style: TextStyle(
                          height: 1,
                          fontSize: 26,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              FractionallySizedBox(
                  widthFactor: .75,
                  child: SvgPicture.asset('assets/svg/warn.svg')),
              const SizedBox(height: 15),
              GradientButton(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 750)).then(
                    (value) {
                      context.go(AppRoutes.splashRoute.path);
                    },
                  );
                },
                onLongPress: () {
                  context.go(AppRoutes.loginRoute.path);
                },
                title: "Reload",
              ),
              CupertinoButton(
                child: const Text("logout"),
                onPressed: () {
                  context.go(AppRoutes.loginRoute.path);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
