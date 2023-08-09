import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/models/response/booking.dart';
import 'package:empiregarage_mobile/models/response/car.dart';
import 'package:empiregarage_mobile/models/response/qrcode.dart';
import 'package:empiregarage_mobile/models/response/symptoms.dart';
import 'package:empiregarage_mobile/models/response/workload.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/api_part.dart';

class BookingService {
  Future<dynamic> createBooking(
      BuildContext context,
      String date,
      int carId,
      int userId,
      double bookingPrice,
      List<SymptonResponseModel> symptoms,
      List<UnresolvedProblem> unresolvedProblems) async {
    http.Response? response;
    try {
      List<int> symptomIds = symptoms.map((s) => s.id).toList();
      Map<String, dynamic> requestBody = {
        "date": date,
        "carId": carId,
        "userId": userId,
        "bookingPrice": bookingPrice,
        "symptoms": symptomIds,
        "unresolvedProblems": unresolvedProblems
      };
      log(jsonEncode(requestBody));

      response = await makeHttpRequest(
        '${APIPath.path}/bookings',
        method: 'POST',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == HttpStatus.created) {
        return BookingResponseModel.fromJson(jsonDecode(response.body));
      } else {
        // ignore: use_build_context_synchronously
        return response;
      }
    } on Exception catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<String?> getQrCode(int bookingId) async {
    String apiUrl = "${APIPath.path}/booking-qrcode/$bookingId";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        //Generate QR-Code
        var data = jsonEncode(<String, dynamic>{
          'bookingId': bookingId,
        });
        var qrCodeResponse =
            QrCodeResponseModel.fromJson(jsonDecode(response.body));
        if (qrCodeResponse.isGenerating == null) {
          String apiPutUrl =
              "${APIPath.path}/booking-qrcode/$bookingId/generate-qrcode";
          var response = await makeHttpRequest(
            apiPutUrl,
            method: 'PUT',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: data,
          );
          if (response.statusCode == 200) {
            var qrCodeResponse =
                QrCodeResponseModel.fromJson(jsonDecode(response.body));
            return qrCodeResponse.qrCode;
          }
        } else if (qrCodeResponse.isGenerating == true) {
          return qrCodeResponse.qrCode;
        } else {
          return null;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<List<BookingResponseModel>> getOnGoingBooking(int userId) async {
    String apiUrl =
        "${APIPath.path}/bookings/on-going-bookings-by-user/$userId";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> jsonArray = json.decode(response.body);
        List<BookingResponseModel> list = [];
        for (var jsonObject in jsonArray) {
          list.add(BookingResponseModel.fromJson(jsonObject));
        }
        return list;
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<List<BookingResponseModel>> getBookingByUser(int userId) async {
    String apiUrl = "${APIPath.path}/bookings/bookings-by-user/$userId";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        List<dynamic> jsonArray = json.decode(response.body);
        List<BookingResponseModel> list = [];
        for (var jsonObject in jsonArray) {
          list.add(BookingResponseModel.fromJson(jsonObject));
        }
        return list;
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<BookingResponseModel?> getBookingById(int bookingId) async {
    String apiUrl = "${APIPath.path}/bookings/$bookingId";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        dynamic jsonObject = json.decode(response.body);
        BookingResponseModel booking =
            BookingResponseModel.fromJson(jsonObject);
        return booking;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<double> getBookingPrice() async {
    String apiUrl = "${APIPath.path}/bookings/booking-price";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        dynamic jsonObject = json.decode(response.body);
        double bookingPrice = double.parse(jsonObject.toString());
        return bookingPrice;
      }
    } catch (e) {
      e.toString();
    }
    return 0;
  }

  Future<http.Response> cancelBooking(int bookingId) async {
    String apiUrl = '${APIPath.path}/bookings/cancel/$bookingId';
    var response = await makeHttpRequest(
      apiUrl,
      method: 'PUT',
    );
    return response;
  }

  Future<double> getTotalWorkload() async {
    String apiUrl = "${APIPath.path}/workloads/total";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        dynamic jsonObject = json.decode(response.body);
        double totalWorkload = double.parse(jsonObject.toString());
        return totalWorkload;
      }
    } catch (e) {
      e.toString();
    }
    return 0;
  }

  Future<Workload?> getMinWorkload() async {
    String apiUrl = "${APIPath.path}/workloads/minWorkload";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        dynamic jsonObject = json.decode(response.body);
        Workload minWorkload = Workload.fromJson(jsonObject);
        return minWorkload;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
