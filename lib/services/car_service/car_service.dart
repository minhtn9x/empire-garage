import 'dart:convert';
import 'dart:developer';

import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/models/request/car_request_model.dart';
import 'package:empiregarage_mobile/models/response/booking.dart';
import 'package:empiregarage_mobile/models/response/brand.dart';
import 'package:empiregarage_mobile/models/response/car.dart';
import 'package:http/http.dart' as http;

import '../../common/api_part.dart';

class CarService {
  Future<http.Response?> addNewCar(
      String carLisenceNo, String carBrand, String carModel) async {
    var userId = await getUserId();
    String apiUrl = '${APIPath.path}/cars';
    final response = await makeHttpRequest(apiUrl,
        method: 'POST',
        body: jsonEncode({
          'userId': userId,
          'carLisenceNo': carLisenceNo,
          'carBrand': carBrand,
          'carModel': carModel
        }),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      log('Car data sent successfully');
    } else {
      log('Error sending car data: ${response.statusCode}');
    }
    return response;
  }

  Future<List<CarResponseModel>?> fetchUserCars(int userId) async {
    String apiUrl = '${APIPath.path}/users/$userId/cars';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      var jsonArray = json.decode(response.body);
      List<CarResponseModel> list = [];
      for (var jsonObject in jsonArray['cars']) {
        list.add(CarResponseModel.fromJson(jsonObject));
      }
      return list;
    } else {
      // If the server returns an error, then throw an exception.
      log("Failed to load item, status code: ${response.statusCode}");
      return null;
    }
  }

  Future<List<BrandResponseModel>> getBrand() async {
    String apiUrl = '${APIPath.path}/cars/sample';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      var jsonArray = json.decode(response.body);
      List<BrandResponseModel> list = [];
      for (var jsonObject in jsonArray) {
        list.add(BrandResponseModel.fromJson(jsonObject));
      }
      return list;
    } else {
      // If the server returns an error, then throw an exception.
      log("Failed to load item, status code: ${response.statusCode}");
      return [];
    }
  }

  Future<CarProfile?> getCarProfle(int carId) async {
    String apiUrl = '${APIPath.path}/cars/$carId/profile';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      var car = CarProfile.fromJson(json.decode(response.body));
      return car;
    } else {
      // If the server returns an error, then throw an exception.
      log("Failed to load car, status code: ${response.statusCode}");
      return null;
    }
  }
  
  Future<http.Response> canBook(int carId) async {
    String apiUrl = '${APIPath.path}/cars/$carId/can-book';
    var response = await makeHttpRequest(
      apiUrl,
      method: 'GET',
    );
    return response;
  }

  Future<CarResponseModel?> getCarById(int carId) async {
    String apiUrl = '${APIPath.path}/cars/$carId';
    final response = await makeHttpRequest(apiUrl);
    if (response.statusCode == 200) {
      var jsonArray = json.decode(response.body);
      var car = CarResponseModel.fromJson(jsonArray);
      return car;
    } else {
      // If the server returns an error, then throw an exception.
      log("Failed to load item, status code: ${response.statusCode}");
      return null;
    }
  }

  Future<http.Response?> updateCar(CarRequestModel model) async {
    http.Response? response;
    String updatedCarJson = jsonEncode(model.toJson());
    String apiUrl = '${APIPath.path}/cars';
    try {
      response = await makeHttpRequest(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        method: 'PUT',
        body: updatedCarJson,
      );
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<http.Response?> deleteCar(int carId, int customerId) async {
    http.Response? response;
    String apiUrl = '${APIPath.path}/cars/$carId';
    try {
      response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': '*/*',
        },
        body: jsonEncode({
          'carId': carId,
          'customerId': customerId,
        }),
      );
    } catch (e) {
      print('Error occurred during API call: $e');
    }
    return response;
  }
}
