import 'dart:convert';

import 'package:benji/src/repo/services/api_url.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkUtility {
  static Future<String?> fetchUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      if (kIsWeb) {
        print('$kIsWeb kIsWeb');
        print('$baseURL/map/getMap/?url=${uri.toString()}');
        final response = await http.post(
            Uri.parse(
                '$baseURL/map/getMap/?url=${Uri.encodeQueryComponent(uri.toString())}'),
            headers: headers);
        if (response.statusCode == 200) {
          print(response.body);
          return jsonEncode(jsonDecode(response.body)['details']);
        }
        return null;
      }
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
