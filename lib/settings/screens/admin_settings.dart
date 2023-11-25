import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../routes/routes_const.dart';

class AdminSettings extends StatelessWidget {
  const AdminSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Settings")),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CupertinoListSection(
                children: [
                  CupertinoListTile(
                    onTap: () {
                      context.go(AppRoutes.loginRoute.path);
                    },
                    title: const Text("Logout"),
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
