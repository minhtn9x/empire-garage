import 'dart:convert';

import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/models/response/groupservices.dart';
import 'package:flutter/foundation.dart';

import '../../common/api_part.dart';

class GroupServices {
  Future<List<GroupServicesResponseModel>?> fetchGroupServices(
      bool isService) async {
    String apiUrl = '${APIPath.path}/group-services/item-list?isService=$isService';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      List<dynamic> jsonArray = json.decode(response.body);
      List<GroupServicesResponseModel> groupService = [];
      for (var jsonObject in jsonArray) {
        groupService.add(GroupServicesResponseModel.fromJson(jsonObject));
      }
      return groupService;
    } else {
      if (kDebugMode) {
        print("Failed to load item, status code: ${response.statusCode}");
      }
      return null;
    }
  }
}
