import 'package:benji/main.dart';
import 'package:benji/src/repo/controller/user_controller.dart';
import 'package:benji/src/repo/models/user/user_model.dart';
import 'package:benji/src/repo/services/api_url.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String userBalance = "userBalance";
const String firstTimeUser = "firstTimeUser";

bool rememberBalance() {
  bool remember = prefs.getBool(userBalance) ?? true;
  return remember;
}

void setRememberBalance(bool show) {
  prefs.setBool(userBalance, show);
}

bool firstTimer() {
  bool remember = prefs.getBool(firstTimeUser) ?? true;
  return remember;
}

Future setFirstTimer() async {
  prefs.setBool(firstTimeUser, false);
}

Future<bool> isAuthorized() async {
  final response = await http.get(
    Uri.parse('$baseURL/auth/'),
    headers: authHeader(),
  );
  return response.statusCode == 200;
}

Map<String, String> authHeader([String? authToken, String? contentType]) {
  if (authToken == null) {
    User user = UserController.instance.user.value;
    authToken = user.token;
  }

  Map<String, String> res = {
    'Authorization': 'Bearer $authToken',
  };
  // 'Content-Type': 'application/json', 'application/x-www-form-urlencoded'

  if (contentType != null) {
    res['Content-Type'] = contentType;
  }
  print(res);
  return res;
}

class UppercaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
