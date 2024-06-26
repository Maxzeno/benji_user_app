// ignore_for_file: empty_catches

import 'package:benji/app/home/home.dart';
import 'package:benji/frontend/main/home.dart';
import 'package:benji/src/components/snackbar/my_floating_snackbar.dart';
import 'package:benji/src/repo/controller/error_controller.dart';
import 'package:benji/src/repo/controller/user_controller.dart';
import 'package:benji/src/repo/models/user/user_model.dart';
import 'package:benji/src/repo/services/helper.dart';
import 'package:benji/src/repo/utils/helpers.dart';
import 'package:benji/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/onboarding/onboarding_screen.dart';

class AuthController extends GetxController {
  static AuthController get instance {
    return Get.find<AuthController>();
  }

  Future checkAuth() async {
    bool status;
    try {
      status = await isAuthorized();
    } catch (e) {
      ApiProcessorController.errorSnack('Check your internet');
      status = false;
    }

    if (status) {
      Get.offAll(
        () => const Home(),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Home",
        predicate: (route) => false,
        popGesture: false,
        transition: Transition.cupertinoDialog,
      );
    } else {
      if (firstTimer()) {
        return Get.offAll(
          () => const OnboardingScreen(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "OnboardingScreen",
          predicate: (route) => false,
          popGesture: false,
          transition: Transition.cupertinoDialog,
        );
      } else {
        Get.offAll(
          () => const HomePage(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "HomePage",
          predicate: (route) => false,
          popGesture: false,
          transition: Transition.cupertinoDialog,
        );
      }
    }
  }

  Future loginIfNotAuth(context) async {
    User? haveUser = await getUser();
    bool? isAuth = await isAuthorizedOrNull();
    if (isAuth == null) {
      mySnackBar(
        context,
        kAccentColor,
        "No Internet!",
        "Please Connect to the internet",
        const Duration(seconds: 3),
      );
    }
    if (haveUser == null || isAuth == false) {
      mySnackBar(
        context,
        kAccentColor,
        "Login to continue!",
        "Please login to continue",
        const Duration(seconds: 2),
      );
      await UserController.instance.deleteUser();
      if (firstTimer()) {
        return Get.offAll(
          () => const OnboardingScreen(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "OnboardingScreen",
          predicate: (route) => false,
          popGesture: false,
          transition: Transition.cupertinoDialog,
        );
      } else {
        Get.offAll(
          () => const HomePage(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "HomePage",
          predicate: (route) => false,
          popGesture: false,
          transition: Transition.cupertinoDialog,
        );
      }
    }
  }
}
