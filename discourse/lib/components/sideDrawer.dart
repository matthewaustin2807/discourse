import 'package:discourse/constants/appColor.dart';
import 'package:discourse/state/application_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Side drawer containing link to My Account Page and Sign Out functionality
class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    GoRouter router = GoRouter.of(context);
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Drawer(
        semanticLabel: 'Side Menu',
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColor().tertiary,
              ),
              child: const Text('Menu'),
            ),
            Semantics(
              label: 'Open My Account',
              button: true,
              child: ListTile(
                  title: const Text('My Account'),
                  onTap: () {
                    appState.changePages('/myaccount');
                    Navigator.of(context).pop();
                  }),
            ),
            Semantics(
              label: 'Sign Out',
              button: true,
              child: ListTile(
                  title: const Text('Sign Out'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                      if (user == null) {
                        router.go('/');
                      }
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
