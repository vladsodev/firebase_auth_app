//loggedOut
//loggedIn

import 'package:firebase_auth_app/features/home/screens/find_coffee_screen.dart';
import 'package:firebase_auth_app/features/home/screens/home_screen.dart';
import 'package:firebase_auth_app/features/home/screens/order_history_screen.dart';
import 'package:firebase_auth_app/features/home/screens/user_info.dart';
import 'package:firebase_auth_app/screens/auth_screens/register_screen.dart';
import 'package:firebase_auth_app/screens/auth_screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  // '/signin': (_) => const MaterialPage(child: SignInScreen()),
  // '/': (_) => const MaterialPage(child: RegisterForm()),
  //  '/': (_) => const Redirect('/signin'), 
    '/': (_) => const MaterialPage(child: SignInScreen()),
    '/register': (_) => const MaterialPage(child: RegisterForm()),  
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/findcoffee': (_) => const MaterialPage(child: FindCoffee()),
  '/userinfo': (_) => const MaterialPage(child: UserInfo()),
  '/orderhistory': (_) => const MaterialPage(child: OrderHistory()),
});