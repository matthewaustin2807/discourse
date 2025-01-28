import 'package:discourse/components/bottomNavBar.dart';
import 'package:discourse/components/sideDrawer.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Main Page to be Displayed to the User upon Signing In.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
            endDrawer: const SideDrawer(),
            bottomNavigationBar: const BottomNavBar(),
            body:
                Consumer<ApplicationState>(builder: (context, appState, child) {
              return appState.currentShownPage;
            })));
  }
}
