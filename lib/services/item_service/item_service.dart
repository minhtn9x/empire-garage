import 'dart:convert';

import 'package:empiregarage_mobile/common/api_part.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/models/response/item.dart';
import 'package:flutter/foundation.dart';

class ItemService {
  Future<ItemResponseModel?> fetchItems(itemId) async {
    String apiUrl = '${APIPath.path}/items/$itemId';
    final response = await makeHttpRequest('$apiUrl?id=$itemId');
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      var item = ItemResponseModel.fromJson(jsonDecode(response.body));
      return item;
    } else {
      // If the server returns an error, then throw an exception.
      if (kDebugMode) {
        print("Failed to load item, status code: ${response.statusCode}");
      }
      return null;
    }
  }

  Future<List<ItemResponseModel>?> fetchListItem(bool onlyPopular) async {
    String apiUrl = '${APIPath.path}/items?onlyPopular=$onlyPopular';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      List<dynamic> jsonArray = json.decode(response.body);
      List<ItemResponseModel> listItems = [];
      for (var jsonObject in jsonArray) {
        listItems.add(ItemResponseModel.fromJson(jsonObject));
      }
      return listItems;
    } else {
      // If the server returns an error, then throw an exception.
      if (kDebugMode) {
        print("Failed to load item, status code: ${response.statusCode}");
      }
      return null;
    }
  }
}
