//loggedOut
//loggedIn

import 'package:firebase_auth_app/features/home/screens/admin_screens/admin_menu_screen.dart';
import 'package:firebase_auth_app/features/home/screens/admin_screens/logs_screen.dart';
import 'package:firebase_auth_app/features/home/screens/operator_screens/add_drink_screen.dart';
import 'package:firebase_auth_app/features/home/screens/operator_screens/all_orders_screen.dart';
import 'package:firebase_auth_app/features/home/screens/operator_screens/cancelled_orders.dart';
import 'package:firebase_auth_app/features/home/screens/operator_screens/completed_orders.dart';
import 'package:firebase_auth_app/features/home/screens/operator_screens/edit_rotation_screen.dart';
import 'package:firebase_auth_app/features/home/screens/operator_screens/menu_screen.dart';
import 'package:firebase_auth_app/features/home/screens/operator_screens/new_orders_screen.dart';
import 'package:firebase_auth_app/features/home/screens/operator_screens/operator_menu.dart';
import 'package:firebase_auth_app/features/home/screens/operator_screens/orders_in_progress.dart';
import 'package:firebase_auth_app/features/home/screens/user_screens/find_coffee_screen.dart';
import 'package:firebase_auth_app/features/home/screens/user_screens/home_screen.dart';
import 'package:firebase_auth_app/features/home/screens/user_screens/order_history_screen.dart';
import 'package:firebase_auth_app/features/home/screens/user_screens/user_info.dart';
import 'package:firebase_auth_app/screens/auth_screens/register_screen.dart';
import 'package:firebase_auth_app/screens/auth_screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
    '/': (_) => const MaterialPage(child: SignInScreen()),
    '/register': (_) => const MaterialPage(child: RegisterForm()),  
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/findcoffee': (_) => const MaterialPage(child: FindCoffee()),
  '/userinfo': (_) => const MaterialPage(child: UserInfo()),
  '/orderhistory': (_) => const MaterialPage(child: OrderHistory()),
});

final operatorRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: OperatorMenuScreen()),
  '/editrotation': (_) => const MaterialPage(child: EditRotationScreen()),
  '/alldrinks': (_) => const MaterialPage(child: MenuScreen()),
  '/addnewdrink': (_) => const MaterialPage(child: AddDrinkScreen()),
  '/neworders': (_) => const MaterialPage(child: NewOrdersScreen()),
  '/ordersinprogress': (_) => const MaterialPage(child: OrdersInProgressScreen()),
  '/completedorders': (_) => const MaterialPage(child: CompletedOrdersScreen()),
  '/cancelledorders': (_) => const MaterialPage(child: CancelledOrdersScreen()),
  '/allorderhistory': (_) => const MaterialPage(child: AllOrdersScreen()),
});

final adminRoute = RouteMap(routes: {
    '/': (_) => const MaterialPage(child: AdminMenu()),
    '/viewlogs': (_) => const MaterialPage(child: LogScreen()),
  }
);