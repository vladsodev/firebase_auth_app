import 'package:firebase_auth_app/models/drink.dart';
import 'package:firebase_auth_app/models/log.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/features/auth/repo/auth_repository.dart';
import 'package:firebase_auth_app/models/user.dart';
import 'package:firebase_auth_app/utils/show_snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider), 
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;
},);

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final drinkRotationProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getDrinksFromRotation;
});

final removedRotationProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getDrinksFromRemoved;
});

final menuProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getMenu;
});

final drinkHistoryProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getDrinksFromHistory(uid);
});



final logsProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getLogs;
});



final allOrdersProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getOrders;
});

final newOrdersProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getNewOrders;
});

final ordersInProgressProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getOrdersInProgress;
});

final completedOrdersProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCompletedOrders;
});

final cancelledOrdersProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCancelledOrders;
});


final latestUserDataProvider = StateProvider<UserModel?>((ref) => null);

final userDataProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  final authState = ref.watch(authStateChangeProvider).value;
  if (authState != null) {
    await Future.delayed(const Duration(seconds: 1));
    final userData = await ref.watch(authControllerProvider.notifier).getUserData(authState.uid).first;
    ref.read(latestUserDataProvider.notifier).update((state) => userData);
    return userData;
  }
  return null;
});


// final userDataProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
//   final authState = ref.watch(authStateChangeProvider).value;
//   if (authState != null) {
//     await Future.delayed(const Duration(seconds: 1));
//     return await ref.watch(authControllerProvider.notifier).getUserData(authState.uid).first;
//   }
//   return null;
// });

class AuthController extends StateNotifier<bool>{
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref, 
        super(false); // represents the loading state

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  Stream<List<Drink>> get getDrinksFromRotation => _authRepository.getDrinksFromRotation;

  Stream<List<Drink>> get getDrinksFromRemoved => _authRepository.getRemovedDrinks;

  Stream<List<Drink>> get getMenu => _authRepository.getMenu;

  Stream<List<Log>> get getLogs => _authRepository.logList; 


  Stream<List<VcoffeeOrder>> get getOrders => _authRepository.getOrders;

  Stream<List<VcoffeeOrder>> get getNewOrders => _authRepository.getNewOrders;

  Stream<List<VcoffeeOrder>> get getOrdersInProgress => _authRepository.getOrdersInProgress;

  Stream<List<VcoffeeOrder>> get getCancelledOrders => _authRepository.getCancelledOrders;

  Stream<List<VcoffeeOrder>> get getCompletedOrders => _authRepository.getCompletedOrders;

  Stream<List<Drink>> getDrinksFromHistory(String uid) => _authRepository.getDrinksFromHistory(uid);

  void signUpWithEmail(String email, String password, BuildContext context) async {
    state = true;
    final user = await _authRepository.signUpWithEmail(email, password);
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) => _ref.read(userProvider.notifier).update((state) => userModel));
  }



  void signInWithEmail(String email, String password, BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithEmail(email, password);
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) => _ref.read(userProvider.notifier).update((state) => userModel));
  }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAsGuest();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) => _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void signInAnonymously(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAnonymously();
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void signOut(UserModel user , BuildContext context) async {
    await _authRepository.signOut(user);
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void updateUserData(UserModel user, BuildContext context) {
    _authRepository.updateUserData(user);
    _ref.read(latestUserDataProvider.notifier).update((state) => user);
    showSnackBar(context, 'Succesfully updated!');
  }

  void orderDrink(UserModel user, Drink? drink, BuildContext context) {
    if (user.isAnonymous) {
      showSnackBar(context, 'Sign in to order!');
    } else
    if (drink == null) {
      showSnackBar(context, 'No drink selected!');
    } else {
    _authRepository.orderDrink(user.uid, drink);
    showSnackBar(context, 'Ordered!');
    }
  }

  void removeDrinkFromRotation(Drink drink) {
    _authRepository.removeDrinkFromRotation(drink);
  }

  void addDrinkToRotation(Drink drink) {
    _authRepository.addDrinkToRotationBetter(drink);
  }

  Future<int> getNextId() {
    return _authRepository.getNextId();
  }

  void addNewDrink(String uid, Drink drink) async {
    return _authRepository.addNewDrink(uid, drink);
  }

  void acceptOrder(VcoffeeOrder order) {
    _authRepository.acceptOrder(order);
  }

  void cancelOrder(VcoffeeOrder order) {
    _authRepository.cancelOrder(order);
  }

  void finishOrder(VcoffeeOrder order) {
    _authRepository.finishOrder(order);
  }


}