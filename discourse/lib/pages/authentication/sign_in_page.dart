import 'package:discourse/constants/appColor.dart';
import 'package:discourse/state/application_state.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Sign In Page for Users
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String email = "";
  String password = "";
  bool _enableSignIn = false;
  bool _incorrectCredential = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    GoRouter router = GoRouter.of(context);
    Size screenSize = MediaQuery.of(context).size;
    ApplicationState appState =
        Provider.of<ApplicationState>(context, listen: false);

    return Scaffold(
      body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: screenSize.height * 0.2),
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Sign In',
                      semanticsLabel: 'Sign In',
                      style: TextStyle(fontFamily: 'Headers', fontSize: 64)),
                  SizedBox(height: screenSize.height * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.01,
                                horizontal: screenSize.width * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ExcludeSemantics(
                                  child: const Text('Email Address'),
                                ),
                                Semantics(
                                  label: 'Enter your email',
                                  textField: true,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                        if (email.isNotEmpty &&
                                            password.isNotEmpty) {
                                          _enableSignIn = true;
                                        }
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Enter email',
                                        labelText: 'Input Email'),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Your Email";
                                      }
                                      if (!EmailValidator.validate(value)) {
                                        return "Invalid Email Address";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.01,
                                horizontal: screenSize.width * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const ExcludeSemantics(child: Text('Password')),
                                Semantics(
                                  label: 'Enter your password',
                                  textField: true,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        password = value;
                                        if (email.isNotEmpty &&
                                            password.isNotEmpty) {
                                          _enableSignIn = true;
                                        }
                                      });
                                    },
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: const InputDecoration(
                                        hintText: 'Enter password',
                                        labelText: 'Input password'),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please Enter Your Password";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  SizedBox(
                    width: screenSize.width * 0.6,
                    height: screenSize.height * 0.08,
                    child: Semantics(
                      button: true,
                      enabled: true,
                      label: 'Sign In',
                      child: ElevatedButton(
                        onPressed: _enableSignIn
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                      email: email,
                                      password: password,
                                    );
                                    FirebaseAuth.instance
                                        .authStateChanges()
                                        .listen((User? user) {
                                      if (user != null) {
                                        appState.init();
                                        router.go('/main-page');
                                      }
                                    });
                                  } on FirebaseAuthException catch (e) {                            
                                    if (e.code == 'invalid-credential') {
                                      setState(
                                          () => _incorrectCredential = true);
                                    }
                                  }
                                }
                              }
                            : null,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              _enableSignIn
                                  ? AppColor().buttonActive
                                  : AppColor().buttonInactive),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                        ),
                        child: Text(
                          'Sign In!',
                          style: TextStyle(
                              color: _enableSignIn
                                  ? AppColor().textActivePrimary
                                  : AppColor().textInactive,
                              fontSize: 20,
                              fontFamily: 'RegularText'),
                        ),
                      ),
                    ),
                  ),
                  
                  Container(
                    margin: EdgeInsets.only(top: screenSize.height * 0.01),
                    child: Semantics(
                      label: 'Incorrect username or password',
                      excludeSemantics: true,
                      liveRegion: true,
                      hidden: !_incorrectCredential,
                      child: Visibility(
                        visible: _incorrectCredential,
                        child: Text('Incorrect username/password',
                            style: TextStyle(color: AppColor().textError)),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: screenSize.width * 0.05,
                          top: screenSize.height * 0.03),
                      child: Row(
                        children: <Widget>[
                          const Text("Don't have an account?"),
                          Semantics(
                            label: 'Tap here to sign up',
                            excludeSemantics: true,
                            button: true,
                            child: TextButton(
                              child: const Text("Register!"),
                              onPressed: () => context.go('/sign-up'),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ]),
    );
  }
}
