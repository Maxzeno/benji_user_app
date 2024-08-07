// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';

import 'package:benji/app/shopping_location/set_shopping_location.dart';
import 'package:benji/app/splash_screens/login_splash_screen.dart';
import 'package:benji/src/repo/controller/error_controller.dart';
import 'package:benji/src/repo/controller/user_controller.dart';
import 'package:benji/src/repo/models/login_model.dart';
import 'package:benji/src/repo/services/api_url.dart';
import 'package:benji/src/repo/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  static LoginController get instance {
    return Get.find<LoginController>();
  }

  var isLoad = false.obs;

  Future<void> login(SendLogin data) async {
    try {
      UserController.instance;
      isLoad.value = true;
      update();

      Map finalData = {
        "username": data.username,
        "password": data.password,
      };

      http.Response? response =
          await HandleData.postApi(Api.baseUrl + Api.login, null, finalData);

      if (response == null) {
        ApiProcessorController.errorSnack("Please check your internet");
        isLoad.value = false;
        update();
        return;
      }

      var jsonData = jsonDecode(response.body ?? '');
      if ((response.statusCode ?? 400) != 200) {
        ApiProcessorController.errorSnack(
            "Invalid email or password. Try again");
        isLoad.value = false;
        update();
        return;
      }
      http.Response responseUser = await http.get(
          Uri.parse("${Api.baseUrl}/auth/"),
          headers: authHeader(jsonData["token"]));

      if (responseUser.statusCode != 200) {
        throw TimeoutException('Please connect to the internet');
      }

      if (jsonDecode(responseUser.body)['id'] == null) {
        ApiProcessorController.errorSnack(
            "Invalid email or password. Try again");
        isLoad.value = false;
        update();
        return;
      }
      http.Response? responseUserData = await HandleData.getApi(
          Api.baseUrl +
              Api.getClient +
              jsonDecode(responseUser.body)['id'].toString(),
          jsonData["token"]);

      if (responseUserData == null) {
        throw TimeoutException('Please connect to the internet');
      }

      if (responseUserData.statusCode != 200) {
        ApiProcessorController.errorSnack(
            "Invalid email or password. Try again");
        isLoad.value = false;
        update();
        return;
      }

      UserController.instance
          .saveUser(responseUserData.body, jsonData["token"]);

      ApiProcessorController.successSnack("Login Successful");
      isLoad.value = false;
      update();
      Get.offAll(
        () => SetShoppingLocation(
          hideButton: true,
          fromLogin: true,
          navTo: () {
            Get.offAll(
              () => const LoginSplashScreen(),
              fullscreenDialog: true,
              curve: Curves.easeIn,
              routeName: "LoginSplashScreen",
              predicate: (route) => false,
              popGesture: true,
              transition: Transition.cupertinoDialog,
            );
          },
        ),
        routeName: 'SetShoppingLocation',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
    } on TimeoutException {
      ApiProcessorController.errorSnack("Please connect to the internet");
      isLoad.value = true;
      update();
      // await Get.to(
      //   () => const NoNetworkRetry(),
      //   routeName: 'NoNetworkRetry',
      //   duration: const Duration(milliseconds: 300),
      //   fullscreenDialog: true,
      //   curve: Curves.easeIn,
      //   preventDuplicates: true,
      //   popGesture: true,
      //   transition: Transition.rightToLeft,
      // );
    } catch (e) {
      ApiProcessorController.errorSnack("An error occurred.\n ERROR: $e");
      isLoad.value = false;
      update();
    }
  }
}
