//loggedOut
//loggedIn

import 'package:firebase_auth_app/features/home/screens/home_screen.dart';
import 'package:firebase_auth_app/screens/auth_screens/sign_in_screen.dart';
import 'package:firebase_auth_app/screens/auth_screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  // '/': (_) => const TabPage(
  //   child: SignInScreen(),
  //   paths: ['/signup', '/signin']
  // ),
  '/signup': (_) => const MaterialPage(child: RegisterForm()),
  '/': (_) => const MaterialPage(child: SignInScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
});