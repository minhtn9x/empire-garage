import 'dart:convert';
import 'dart:developer';

import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:http/http.dart' as http;

import '../../common/api_part.dart';
import '../../models/request/payment_request_model.dart';

class PaymentServices {
  Future<http.Response?> createNewPaymentForBooking(
      PaymentRequestModel model) async {
    String apiUrl = '${APIPath.path}/payment';
    final response = await makeHttpRequest(apiUrl,
        method: 'POST',
        body: jsonEncode({
          'orderType': model.orderType,
          'amount': model.amount,
          'orderDescription': model.orderDescription,
          'name': model.name
        }),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      log('Payment data sent successfully');
    } else {
      log('Error sending payment data: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response?> createNewPaymentForOrder(
      PaymentRequestModel model) async {
    String apiUrl = '${APIPath.path}/payment';
    final response = await makeHttpRequest(apiUrl,
        method: 'POST',
        body: jsonEncode({
          'orderType': model.orderType,
          'amount': model.amount,
          'orderDescription': model.orderDescription,
          'name': model.name
        }),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      log('Payment data sent successfully');
    } else {
      log('Error sending payment data: ${response.statusCode}');
    }
    return response;
  }
}
