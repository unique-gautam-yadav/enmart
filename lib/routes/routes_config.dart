import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common/screens/splash_screen.dart';
import '../features/auth/screens/login.dart';
import '../features/auth/screens/register.dart';
import '../features/auth/state.dart';
import '../features/cart/screens/cart_display.dart';
import '../features/customers/screens/users.dart';
import '../features/home/screens/admin_home.dart';
import '../features/home/screens/user_disabled.dart';
import '../features/home/screens/user_home.dart';
import '../features/ndp/screens/admin.dart';
import '../features/ndp/screens/ndp_user.dart';
import '../features/ndp/screens/user.dart';
import '../features/orders/screens/admin_page.dart';
import '../features/orders/screens/user_page.dart';
import '../features/products/models/product_model.dart';
import '../features/products/screens/edit_product.dart';
import '../features/products/screens/list_products.dart';
import '../features/products/screens/user_product.dart';
import '../settings/screens/admin_settings.dart';
import 'routes_const.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: AppRoutes.splashRoute.path,
      name: AppRoutes.splashRoute.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: SplashScreen());
      },
    ),
    GoRoute(
      path: AppRoutes.loginRoute.path,
      name: AppRoutes.loginRoute.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: LoginPage());
      },
    ),
    GoRoute(
      path: AppRoutes.registerRoute.path,
      name: AppRoutes.registerRoute.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: RegisterPage());
      },
    ),
    GoRoute(
      name: AppRoutes.productsRoute.name,
      path: AppRoutes.productsRoute.path,
      pageBuilder: (context, state) => const CupertinoPage(
        child: ListProducts(),
      ),
    ),

    GoRoute(
      name: AppRoutes.editProduct.name,
      path: AppRoutes.editProduct.path,
      pageBuilder: (context, state) => CupertinoPage(
        child: EditProduct(
          model: state.extra as ProductModel,
        ),
      ),
    ),

    /// Admin Routes listed here

    GoRoute(
      path: AdminRoutes.adminHome.path,
      name: AdminRoutes.adminHome.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: AdminHome());
      },
    ),
    GoRoute(
      path: AdminRoutes.usersRoute.path,
      name: AdminRoutes.usersRoute.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: UsersPage());
      },
    ),
    GoRoute(
      path: AdminRoutes.adminSettings.path,
      name: AdminRoutes.adminSettings.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: AdminSettings());
      },
    ),
    GoRoute(
      path: AdminRoutes.adminOrders.path,
      name: AdminRoutes.adminOrders.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: AdminOrders());
      },
    ),
    GoRoute(
      path: AdminRoutes.ndpRoute.path,
      name: AdminRoutes.ndpRoute.name,
      pageBuilder: (context, state) {
        return const CupertinoPage(child: NDPAdminList());
      },
    ),

    // User Routes :: Start Here
    GoRoute(
      path: UserRoutes.homeRoute.path,
      name: UserRoutes.homeRoute.name,
      pageBuilder: (context, state) {
        if (Provider.of<AuthProvider>(context, listen: false)
                .userModel
                ?.isApproved ??
            false) {
          return const CupertinoPage(child: UserHome());
        } else {
          return const CupertinoPage(
            child: UserBlocked(),
          );
        }
      },
    ),

    GoRoute(
      name: UserRoutes.ordersRoute.name,
      path: UserRoutes.ordersRoute.path,
      pageBuilder: (context, state) => const CupertinoPage(
        child: UserOrders(),
      ),
    ),
    GoRoute(
      name: UserRoutes.productsRoute.name,
      path: UserRoutes.productsRoute.path,
      pageBuilder: (context, state) => CupertinoPage(
        child: UserProducts(
          previous: "${state.extra ?? "Home"}",
        ),
      ),
    ),
    GoRoute(
      name: UserRoutes.cartRoute.name,
      path: UserRoutes.cartRoute.path,
      pageBuilder: (context, state) => const CupertinoPage(
        child: CartPage(),
      ),
    ),

    GoRoute(
      name: UserRoutes.newNDPRoute.name,
      path: UserRoutes.newNDPRoute.path,
      pageBuilder: (context, state) => const CupertinoPage(
        child: UserNDPScreen(),
      ),
    ),
    GoRoute(
      name: UserRoutes.ndpRoute.name,
      path: UserRoutes.ndpRoute.path,
      pageBuilder: (context, state) => const CupertinoPage(
        child: NPDUserList(),
      ),
    )
  ],
  initialLocation: AppRoutes.splashRoute.path,
  redirect: (context, state) async {
    if (state.fullPath == UserRoutes.homeRoute.path) {
      await Provider.of<AuthProvider>(context, listen: false).getUserData();
    }

    if (state.fullPath == "/") {
      return AppRoutes.splashRoute.path;
    }
    if (kIsWeb) {
      SystemChrome.setApplicationSwitcherDescription(
          ApplicationSwitcherDescription(
        label: state.fullPath ?? "Flutter Demo",
      ));
    }
    if (state.fullPath == AppRoutes.loginRoute.path ||
        state.fullPath == AppRoutes.registerRoute.path) {
      await FirebaseAuth.instance.signOut();
    }
    return null;
  },
  // errorBuilder: (context, state) {
  //   return const ErrorPage();
  // },
);
