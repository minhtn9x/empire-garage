import 'dart:convert';

import 'package:empiregarage_mobile/common/api_part.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/models/response/brand.dart';
import 'package:empiregarage_mobile/models/response/modelsymptom.dart';
import 'package:flutter/foundation.dart';

class ModelService {
  Future<ModelSlimResponse?> getModel(String modelName, String brandName) async {
    String apiUrl = '${APIPath.path}/models/details?modelName=$modelName&brandName=$brandName';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      return ModelSlimResponse.fromJson(json.decode(response.body));
    } else {
      // If the server returns an error, then throw an exception.
      if (kDebugMode) {
        print("Failed to load model, status code: ${response.statusCode}");
      }
      return null;
    }
  }

  Future<ModelSymptom?> getExpectedPrice(int modelId, int symptomId) async {
    String apiUrl = '${APIPath.path}/modelsymptoms/details?modelId=$modelId&symptomId=$symptomId';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      return ModelSymptom.fromJson(json.decode(response.body));
    } else {
      // If the server returns an error, then throw an exception.
      if (kDebugMode) {
        print("Failed to load getExpectedPrice, status code: ${response.statusCode}");
      }
      return null;
    }
  }
}