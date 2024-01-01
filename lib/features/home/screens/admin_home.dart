import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../routes/routes_const.dart';
import '../../auth/state/state.dart';
import '../widgets/name_n_profile.dart';
import '../widgets/option_chip.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 25),
            NameAndProfile(
              avatarColor: Colors.pink.shade200,
              name: authProvider.authUser?.displayName ?? "__",
              iconData: FontAwesomeIcons.building,
            ),
            const SizedBox(height: 35),
            FractionallySizedBox(
              widthFactor: 1,
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                runSpacing: 35,
                spacing: 15,
                children: [
                  OptionChip(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.black87,
                    icon: FontAwesomeIcons.userGroup,
                    title: "Users",
                    onTap: () {
                      context.push(AdminRoutes.usersRoute.path);
                    },
                  ),
                  OptionChip(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.black87,
                    icon: FontAwesomeIcons.box,
                    title: "Orders",
                    onTap: () {
                      context.push(AdminRoutes.adminOrders.path);
                    },
                  ),
                  OptionChip(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black87,
                    icon: FontAwesomeIcons.boxesPacking,
                    title: "Products",
                    onTap: () {
                      context.push(AppRoutes.productsRoute.path);
                    },
                  ),
                  OptionChip(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black87,
                    icon: CupertinoIcons.news_solid,
                    title: "  NDP  ",
                    onTap: () {
                      context.push(AdminRoutes.ndpRoute.path);
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
    );
  }
}
