import 'dart:convert';
import 'package:empiregarage_mobile/common/api_part.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/models/response/activity.dart';

class ActivityService {
  Future<List<ActivityResponseModel?>> fetchActivity(int userId) async {
    final url = '${APIPath.path}/activity/$userId';
    final response = await makeHttpRequest(url);
    if (response.statusCode == 200) {
      final jsonArray = json.decode(response.body);
      List<ActivityResponseModel> list = [];
      for (var jsonObject in jsonArray) {
        list.add(ActivityResponseModel.fromJson(jsonObject));
      }
      return list;
    } else {
      throw Exception('Failed to fetch activity');
    }
  }

  Future<List<ActivityResponseModel?>> fetchOnGoingActivity(int userId) async {
    final url = '${APIPath.path}/activity/on-going/$userId';
    final response = await makeHttpRequest(url);
    if (response.statusCode == 200) {
      final jsonArray = json.decode(response.body);
      List<ActivityResponseModel> list = [];
      for (var jsonObject in jsonArray) {
        list.add(ActivityResponseModel.fromJson(jsonObject));
      }
      return list;
    } else {
      throw Exception('Failed to fetch activity');
    }
  }
}
