// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:benji/app/shopping_location/set_shopping_location.dart';
import 'package:benji/app/splash_screens/login_splash_screen.dart';
import 'package:benji/src/repo/controller/error_controller.dart';
import 'package:benji/src/repo/controller/user_controller.dart';
import 'package:benji/src/repo/services/api_url.dart';
import 'package:benji/src/repo/services/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../app/no_network/no_network_retry.dart';

class SignupController extends GetxController {
  static SignupController get instance {
    return Get.find<SignupController>();
  }

  var isLoad = false.obs;

  Future<void> signup(String email, String password, String phone,
      String firstName, String lastName, String agentReferralCode) async {
    UserController.instance;
    isLoad.value = true;
    update();

    try {
      final body = {
        'email': email,
        'password': password,
        'phone': phone,
        'username': email.split('@')[0],
        'first_name': firstName,
        'last_name': lastName,
        'agentReferralCode': agentReferralCode
      };

      final res = await http.post(Uri.parse('$baseURL/clients/createClient'),
          body: body);
      print(res.body);

      print(res.statusCode);

      Map finalData = {
        "username": email,
        "password": password,
      };

      http.Response? response =
          await HandleData.postApi(Api.baseUrl + Api.login, null, finalData);
      var jsonData = jsonDecode(response?.body ?? '');
      print(jsonData);
      if ((response?.statusCode ?? 400) != 200) {
        ApiProcessorController.errorSnack(
            "Invalid email or password. Try again");
        isLoad.value = false;
        update();
        return;
      }
      print('got to this point atleast');
      print(Api.baseUrl + Api.user);
      print(jsonData["token"]);
      http.Response responseUser = await http.get(
          Uri.parse("${Api.baseUrl}/auth/"),
          headers: authHeader(jsonData["token"]));
      print(responseUser.body);

      if (responseUser.statusCode != 200) {
        throw const SocketException('Please connect to the internet');
      }
      print(jsonDecode(responseUser.body));

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
              jsonDecode(responseUser.body ?? '')['id'].toString(),
          jsonData["token"]);

      print(jsonDecode(responseUserData?.body ?? ''));

      if (responseUserData == null) {
        throw const SocketException('Please connect to the internet');
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
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
      await Get.to(
        () => const NoNetworkRetry(),
        routeName: 'NoNetworkRetry',
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );
    } catch (e) {
      ApiProcessorController.errorSnack("An error occurred.\n ERROR: $e");
      isLoad.value = false;
      update();
    }
  }
}
