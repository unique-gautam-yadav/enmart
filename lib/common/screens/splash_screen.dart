import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/state/state.dart';
import '../../features/cart/services/cart_provider.dart';
import '../../routes/routes_const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  check() async {
    var p = Provider.of<AuthProvider>(context, listen: false);
    if (context.mounted) {
      if (p.authUser == null) {
        context.go(AppRoutes.loginRoute.path);
      } else {
        await p.getUserData();
        if (context.mounted) {
          if (p.isAdmin!) {
            context.go(AdminRoutes.adminHome.path);
          } else {
            await Provider.of<CartProvider>(context, listen: false)
                .initialize();
            if (context.mounted) {
              context.go(UserRoutes.homeRoute.path);
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.indigo.shade100,
              ),
              child: const Center(
                child: Text(
                  "LOGO HERE",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
