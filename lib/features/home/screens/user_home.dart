import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../routes/routes_const.dart';
import '../../auth/state.dart';
import '../../cart/services/cart_provider.dart';
import '../widgets/name_n_profile.dart';
import '../widgets/option_chip.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    var authProvider = context.watch<AuthProvider>();
    var cartProvider = context.watch<CartProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: NameAndProfile(
                  name: authProvider.userModel?.fullName ?? "--",
                  iconData: FontAwesomeIcons.userLarge,
                  avatarColor: Colors.indigo.shade300,
                ),
              ),
              const SizedBox(height: 50),
              FractionallySizedBox(
                widthFactor: 1,
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  runSpacing: 35,
                  spacing: 15,
                  children: [
                    Badge(
                      // label: Text(cartProvider.products.length.toString()),
                      label: const SizedBox(width: 29),
                      isLabelVisible: cartProvider.products.isNotEmpty,
                      largeSize: 36,
                      child: OptionChip(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.black87,
                        icon: CupertinoIcons.cart_fill,
                        title: "  Cart  ",
                        onTap: () {
                          context.push(UserRoutes.cartRoute.path);
                        },
                      ),
                    ),
                    OptionChip(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.black87,
                      icon: FontAwesomeIcons.box,
                      title: "Orders",
                      onTap: () {
                        context.push(UserRoutes.ordersRoute.path);
                      },
                    ),
                    OptionChip(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black87,
                      icon: FontAwesomeIcons.boxesPacking,
                      title: "Products",
                      onTap: () {
                        context.push(UserRoutes.productsRoute.path);
                      },
                    ),
                    OptionChip(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.black87,
                      icon: CupertinoIcons.news_solid,
                      title: "  NDP  ",
                      onTap: () {
                        context.push(UserRoutes.ndpRoute.path);
                      },
                    ),
                    OptionChip(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.black87,
                      icon: Icons.settings,
                      title: "Settings",
                      onTap: () {
                        context.push(AdminRoutes.adminSettings.path);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
