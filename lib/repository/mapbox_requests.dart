import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tembeakenya/constants/constants.dart';
import 'package:tembeakenya/model/map_data.dart';

Future<List<MapData>> fetchLandmarks() async {
  try {
    final response = await APICall().client.get('${url}api/landmarks');

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = response.data;
      return jsonResponse
          .map((landmark) => MapData.fromJson(landmark))
          .toList();
    } else {
      throw Exception('Failed to load landmarks');
    }
  } on DioException catch (e) {
    debugPrint('Failed to load landmarks: $e');
    throw Exception('Failed to load landmarks');
  }
}
