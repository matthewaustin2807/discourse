import 'package:discourse/constants/appColor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String _discourseLogoURI = "assets/logos/discourse_logo.png";

/// Landing Page when the App just starts.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Image.asset(_discourseLogoURI),
                const Text(
                  'Discourse',
                  style: TextStyle(fontFamily: 'Headers', fontSize: 48),
                  semanticsLabel: 'Discourse',
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: 210,
            height: 64,
            child: Semantics(
              button: true,
              enabled: true,
              label: 'Sign Up',
              child: ElevatedButton(
                key: const Key('signUpBtn'),
                onPressed: () {
                  context.push('/sign-up');
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(AppColor().buttonActive),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'RegularText'),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 210,
            height: 64,
            child: Semantics(
              button: true,
              enabled: true,
              label: 'Sign Up',
              child: ElevatedButton(
                key: const Key('signInBtn'),
                onPressed: () => context.push('/sign-in'),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all<Color>(AppColor().buttonActive),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'RegularText'),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
