import 'dart:convert';
import 'dart:developer';

import 'package:empiregarage_mobile/models/request/order_service_detail_request_model.dart';
import 'package:empiregarage_mobile/models/response/check_out_qr_code_response_model.dart';
import 'package:empiregarage_mobile/models/response/workload.dart';

import '../../common/api_part.dart';
import '../../common/jwt_interceptor.dart';
import '../../models/response/orderservices.dart';
import 'package:http/http.dart' as http;

class OrderServices {
  Future<OrderServicesResponseModel?> getOrderServicesById(
      int servicesId) async {
    String apiUrl = "${APIPath.path}/order-services/$servicesId";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        dynamic jsonObject = json.decode(response.body);
        OrderServicesResponseModel order =
            OrderServicesResponseModel.fromJson(jsonObject);
        return order;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<http.Response?> confirmOrder(
      int orderServiceId, int orderServiceStatusId) async {
    http.Response? response;
    try {
      response = await makeHttpRequest(
        '${APIPath.path}/order-service-status-logs',
        method: 'POST',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'orderServiceId': orderServiceId,
          'orderServiceStatusId': orderServiceStatusId
        }),
      );
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<http.Response?> putConfirmOrder(
      int orderServiceId, List<OrderServiceDetails> orderServiceDetails) async {
    http.Response? response;
    try {
      final List<Map<String, dynamic>> jsonList =
          orderServiceDetails.map((order) => order.toJsonLesser()).toList();
      response = await makeHttpRequest(
        '${APIPath.path}/order-services/$orderServiceId/confirm',
        method: 'PUT',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'orderServiceDetails': jsonList,
          'paymentMethod': 2
        }),
      );
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<http.Response?> putConfirmPaidOrder(
      int orderServiceId, List<OrderServiceDetails> orderServiceDetails) async {
    http.Response? response;
    try {
      final List<Map<String, dynamic>> jsonList =
          orderServiceDetails.map((order) => order.toJsonLesser()).toList();
      response = await makeHttpRequest(
        '${APIPath.path}/order-services/$orderServiceId/confirm',
        method: 'PUT',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'orderServiceDetails': jsonList,
          'paymentMethod': 2
        }),
      );
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<http.Response?> insertOrderDetail(int id, int paymentMethodId,
      List<OrderServiceDetailRequestModel> listOrderServiceDetails) async {
    http.Response? response;
    try {
      final jsonBody = jsonEncode(
          listOrderServiceDetails.map((order) => order.toJson()).toList());
      response = await makeHttpRequest(
        '${APIPath.path}/order-services/$id/order-service-details?paymentMethodId=$paymentMethodId',
        method: 'PUT',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );
    } catch (e) {
      log(e.toString());
    }
    return response;
  }

  Future<String?> getQrCode(int id) async {
    String apiUrl = "${APIPath.path}/order-services/$id/checkout-qrcode";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        //Generate QR-Code
        var qrCodeResponse =
            CheckOutQrCodeResponseModel.fromJson(jsonDecode(response.body));
        if (qrCodeResponse.isGenerating == null) {
          String apiPutUrl =
              "${APIPath.path}/order-services/$id/generate-checkout-qrcode";
          var response = await makeHttpRequest(
            apiPutUrl,
            method: 'PUT',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
          if (response.statusCode == 200) {
            var qrCodeResponse =
                CheckOutQrCodeResponseModel.fromJson(jsonDecode(response.body));
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

  Future<Workload?> getWorkload(int expertId) async {
    String apiUrl =
        "${APIPath.path}/workloads?expertId=$expertId&isGetStartTime=true";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        var workload = Workload.fromJson(jsonDecode(response.body));
        return workload;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Workload?> getExpectedWorkload(int expertId, int totalPoints) async {
    String apiUrl =
        "${APIPath.path}/workloads/expected-finish-time?expertId=$expertId&points=$totalPoints";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        var workload = Workload.fromJson(jsonDecode(response.body));
        return workload;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Workload?> getOrderServiceWorkload(
      int expertId, int orderServiceId) async {
    String apiUrl =
        "${APIPath.path}/workloads/by-order-service?expertId=$expertId&orderServiceId=$orderServiceId";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        var workload = Workload.fromJson(jsonDecode(response.body));
        return workload;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Workload?> getStartWorkload(int expertId, int orderServiceId) async {
    String apiUrl =
        "${APIPath.path}/workloads/expected-start-time?expertId=$expertId&orderServiceId=$orderServiceId";
    try {
      var response = await makeHttpRequest(apiUrl);
      if (response.statusCode == 200) {
        var workload = Workload.fromJson(jsonDecode(response.body));
        return workload;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<http.Response?> putConfirmMaintainanceSchedule(
      int? orderServiceId) async {
    String apiUrl =
        '${APIPath.path}/order-services/$orderServiceId/maintenance-schedule/confirm';
    var response = await makeHttpRequest(
      apiUrl,
      method: 'PUT',
    );
    return response;
  }
}
