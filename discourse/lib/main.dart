import 'package:discourse/pages/main_page.dart';
import 'package:discourse/pages/authentication/sign_up_page.dart';
import 'package:discourse/state/application_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:discourse/pages/authentication/landing_page.dart'; 
import 'package:discourse/pages/authentication/sign_in_page.dart';

final _router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const LandingPage(),
    routes: [
      GoRoute(
          path: 'sign-up',
          builder: (context, state) {
            return const SignUpPage();
          }),
      GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return const SignInPage();
          }),
      GoRoute(
          path: 'main-page',
          builder: (context, state) {
            return const MainPage();
          }),
    ],
  ),
]);

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApplicationState()),
      ],
      child: const Discourse()
    )
  );
}

class Discourse extends StatelessWidget {
  const Discourse({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Discourse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
