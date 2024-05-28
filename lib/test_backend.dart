import 'dart:convert';

import 'package:dio/dio.dart' as di;
import 'package:flutter/material.dart';
import 'package:tembeakenya/constants/constants.dart';

class TestBackend {
  Future<void> login(String email, String password) async {
    await getClient();
    String token = await getCsrfToken();
    debugPrint(token);
    final response = await di.Dio().post('${url}api/about',
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
        options: di.Options(headers: {
          'X-XSRF-TOKEN': token,
          'Accept': 'application/json',
        }));
    debugPrint(response.data);
  }
}
