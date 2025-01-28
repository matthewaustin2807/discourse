import 'package:discourse/constants/appColor.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Custom App bar for the App
class DiscourseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DiscourseAppBar(
      {super.key,
      required this.parentContext,
      required this.pageName,
      required this.isForm,
      this.type,});
  final BuildContext parentContext;
  final String pageName;
  final bool isForm;
  final String? type;

  /// Show dialog to confirm exiting the page if the page is a form.
  Future<void> _dialogBuilder(BuildContext context, ApplicationState appState) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to exit?'),
          content:
              const Text('Data entered within this form will not be saved and '
                  'you will need to restart once you exit.\n'),
          actions: <Widget>[
            Semantics(
              label: 'Cancel',
              button: true,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Semantics(
              label: 'Exit',
              button: true,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child:
                    Text('Exit', style: TextStyle(color: AppColor().textError)),
                onPressed: () {
                  Navigator.of(context).pop();
                  appState.navigationPop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      leading: pageName == 'Discourse'
          ? null
          : Consumer<ApplicationState>(
              builder: (context, appState, child) {
                return BackButton(
                  onPressed: () {
                    if (!isForm) {
                      appState.navigationPop();
                    } else {
                      _dialogBuilder(context, appState);
                    }
                  },
                );
              },
            ),
      automaticallyImplyLeading: false,
      title: Text(
        pageName,
        style: TextStyle(
            fontFamily: 'Headers', fontSize: pageName == 'Discourse' ? 48 : 32),
      ),
      iconTheme: const IconThemeData(size: 40),
      centerTitle: false,
      actions: <Widget>[
        if (type == "marketplace")
          TextButton(
            onPressed: () {
              appState.changePages('/mylisting');
            },
            child: const Text(
              'My Listings',
              style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        Semantics(
          label: 'Open side menu',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(MediaQuery.of(parentContext).size.height * 0.15);
}
