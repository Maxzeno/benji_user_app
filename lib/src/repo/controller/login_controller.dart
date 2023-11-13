// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:benji/app/home/home.dart';
import 'package:benji/src/repo/controller/error_controller.dart';
import 'package:benji/src/repo/controller/login_model.dart';
import 'package:benji/src/repo/controller/user_controller.dart';
import 'package:benji/src/repo/services/api_url.dart';
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

      if (response == null || response.statusCode != 200) {
        ApiProcessorController.errorSnack(
            "Invalid email or password. Try again");
        isLoad.value = false;
        update();
        return;
      }

      var jsonData = jsonDecode(response.body);

      if (jsonData["token"] == false) {
        ApiProcessorController.errorSnack(
            "Invalid email or password. Try again");
        isLoad.value = false;
        update();
      } else {
        http.Response? responseUser =
            await HandleData.getApi(Api.baseUrl + Api.user, jsonData["token"]);
        if (responseUser == null || responseUser.statusCode != 200) {
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
        if (responseUserData == null || responseUserData.statusCode != 200) {
          ApiProcessorController.errorSnack(
              "Invalid email or password. Try again");
          isLoad.value = false;
          update();
          return;
        }

        UserController.instance
            .saveUser(responseUserData.body, jsonData["token"]);

        ApiProcessorController.successSnack("Login Successful");

        Get.offAll(
          () => const Home(),
          fullscreenDialog: true,
          curve: Curves.easeIn,
          routeName: "Home",
          predicate: (route) => false,
          popGesture: true,
          transition: Transition.cupertinoDialog,
        );
        return;
      }

      isLoad.value = false;
      update();
    } catch (e) {
      ApiProcessorController.errorSnack("Invalid email or password. Try again");
      isLoad.value = false;
      update();
    }
  }
}
