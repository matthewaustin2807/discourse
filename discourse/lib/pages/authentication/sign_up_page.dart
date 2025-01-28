import 'package:discourse/constants/appColor.dart';
import 'package:discourse/state/application_state.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Sign Up Page for Users
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  String email = "";
  String password = "";
  String confirmedPassword = "";
  bool _enableSignUp = false;
  bool _emailExist = false;
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
                const Text('Sign Up',
                    semanticsLabel: 'Sign Up',
                    style: TextStyle(fontFamily: 'Headers', fontSize: 64)),
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
                              const ExcludeSemantics(
                                child: Text(
                                  'Email Address',
                                ),
                              ),
                              Semantics(
                                label: 'Enter your email address',
                                textField: true,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                      if (email.isNotEmpty &&
                                          password.isNotEmpty &&
                                          confirmedPassword.isNotEmpty) {
                                        _enableSignUp = true;
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
                              const ExcludeSemantics(
                                child: Text(
                                  'Password',
                                ),
                              ),
                              Semantics(
                                label: 'Enter your password',
                                textField: true,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      password = value;
                                      if (email.isNotEmpty &&
                                          password.isNotEmpty &&
                                          confirmedPassword.isNotEmpty) {
                                        _enableSignUp = true;
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
                                    if (value.length < 6) {
                                      return "Password must be at least 6 characters";
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
                              const ExcludeSemantics(
                                child: Text(
                                  'Confirm Password',
                                ),
                              ),
                              Semantics(
                                label: 'Confirm your password',
                                textField: true,
                                child: TextFormField(
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration: const InputDecoration(
                                      hintText: 'Confirm password',
                                      labelText: 'Confirm Password'),
                                  onChanged: (value) {
                                    confirmedPassword = value;
                                    setState(() {
                                      if (email.isNotEmpty &&
                                          password.isNotEmpty &&
                                          confirmedPassword.isNotEmpty) {
                                        _enableSignUp = true;
                                      }
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please Confirm Your Password";
                                    }
                                    if (value != password) {
                                      return "Password does not match";
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
                    enabled: _enableSignUp,
                    label: 'Sign up',
                    child: ElevatedButton(
                      onPressed: _enableSignUp
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
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
                                  if (e.code == 'email-already-in-use') {
                                    setState(() => _emailExist = true);
                                  }
                                }
                              }
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            _enableSignUp
                                ? AppColor().buttonActive
                                : AppColor().buttonInactive),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                      child: Text(
                        'Sign Up!',
                        style: TextStyle(
                            color: _enableSignUp
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
                    label: 'The account already exists for that email',
                    liveRegion: true,
                    excludeSemantics: true,
                    hidden: !_emailExist,
                    child: Visibility(
                      visible: _emailExist,
                      child: Text('The account already exists for that email.',
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
                        const Text("Already have an account?"),
                        Semantics(
                          label: 'Tap here to sign in',
                          button: true,
                          excludeSemantics: true,
                          child: TextButton(
                            child: const Text("Sign In!"),
                            onPressed: () => router.go('/sign-in'),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ]));
  }
}
