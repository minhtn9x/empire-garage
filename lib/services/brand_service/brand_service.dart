import 'dart:convert';
import 'dart:developer';

import 'package:empiregarage_mobile/common/api_part.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/models/response/brand.dart';

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class BrandService {
  Future<String> getBrandsJson() async {
    String apiUrl = '${APIPath.path}/brands';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If the server returns an error, then throw an exception.
      log("Failed to load brand, status code: ${response.statusCode}");
      return '{}';
    }
  }

  Future<String?> getPhoto(String brand) async {
    final prefs = await SharedPreferences.getInstance();
    var brands = prefs.getString('brands');
    if (brands == null) return null;
    var jsonArray = json.decode(brands);
    List<BrandSlimModel> list = [];
    for (var jsonObject in jsonArray) {
      list.add(BrandSlimModel.fromJson(jsonObject));
    }
    try {
      var photo = list.firstWhere((element) => element.name == brand).photo;
      return photo;
    } catch (exception) {
      return null;
    }
  }
}
