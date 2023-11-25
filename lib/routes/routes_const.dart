// ignore_for_file: public_member_api_docs, sort_constructors_first

class AppRoutes {
  static AppRoute splashRoute = AppRoute(name: 'welcome', path: '/welcome');
  static AppRoute loginRoute = AppRoute(name: 'login', path: '/login');
  static AppRoute registerRoute = AppRoute(name: 'register', path: '/register');
  static AppRoute productsRoute = AppRoute(name: 'products', path: '/products');
  static AppRoute newProductRoute =
      AppRoute(name: 'new_product', path: '/products/new');
  static AppRoute editProduct =
      AppRoute(name: 'edit_product', path: '/products/idHere');
}

class UserRoutes {
  static AppRoute homeRoute = AppRoute(name: 'user_home', path: '/user/home');
  static AppRoute profileRoute =
      AppRoute(name: 'user_profile', path: '/user/profile');
  static AppRoute ordersRoute =
      AppRoute(name: 'user_orders', path: '/user/orders');
  static AppRoute productsRoute =
      AppRoute(name: 'user_products', path: '/user/products');
  static AppRoute cartRoute = AppRoute(name: 'cart_route', path: '/user/cart');
  static AppRoute newNDPRoute =
      AppRoute(name: 'new_ndp_route', path: '/user/ndp/new');
  static AppRoute ndpRoute = AppRoute(name: 'ndp_route', path: '/user/ndp');
}

class AdminRoutes {
  static AppRoute adminHome = AppRoute(name: 'admin_home', path: '/admin/home');
  static AppRoute usersRoute =
      AppRoute(name: 'admin_users', path: '/admin/users');
  static AppRoute newUserRoute =
      AppRoute(name: 'create_user', path: '/admin/users/new');
  static AppRoute adminSettings =
      AppRoute(name: 'admin_settings', path: '/admin/settings');

  static AppRoute adminOrders =
      AppRoute(name: 'admin_orders', path: '/admin/orders');
  static AppRoute ndpRoute =
      AppRoute(name: 'admin_ndp_route', path: '/admin/ndp');
}

class AppRoute {
  final String name;
  final String path;
  AppRoute({
    required this.name,
    required this.path,
  });
}
