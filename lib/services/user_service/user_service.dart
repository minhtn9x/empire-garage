import 'dart:convert';
import 'dart:developer';

import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/models/request/update_user_request_model.dart';
import 'package:empiregarage_mobile/models/response/user.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// ignore: depend_on_referenced_packages

import '../../common/api_part.dart';

class UserService {
  Future<UserResponseModel?> getUserById(userId) async {
    String apiUrl = '${APIPath.path}/users/$userId';
    final response = await makeHttpRequest('$apiUrl?id=$userId');
    if (response.statusCode == 200) {
      var user = UserResponseModel.fromJson(jsonDecode(response.body));
      return user;
    } else {
      if (kDebugMode) {
        print("Failed to load item, status code: ${response.statusCode}");
      }
      return null;
    }
  }

  Future<http.Response?> updateUser(UpdateUserRequestModel model) async {
    http.Response? response;
    try {
      response = await makeHttpRequest(
        '${APIPath.path}/users',
        method: 'PATCH',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(model.toJson()),
      );
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<List<UserResponseModel>> getListUser() async {
    String apiUrl = '${APIPath.path}/users';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      final jsonArray = json.decode(response.body);
      List<UserResponseModel> list = [];
      for (var jsonObject in jsonArray) {
        list.add(UserResponseModel.fromJson(jsonObject));
      }
      return list;
    } else {
      if (kDebugMode) {
        print("Failed to load item, status code: ${response.statusCode}");
      }
      return [];
    }
  }

  Future<List<Map<String, dynamic>>?> getTimeSlot() async {
    final response = await makeHttpRequest('${APIPath.path}/system-configurations/get-time-slot');
    var timeSlots;
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      timeSlots = List<Map<String, dynamic>>.from(data);
      return timeSlots;
    } else {
      if (kDebugMode) {
        print("Failed to load item, status code: ${response.statusCode}");
      }
      return null;
    }
  }
}
