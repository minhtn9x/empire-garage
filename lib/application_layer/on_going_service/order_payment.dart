import 'dart:convert';
import 'dart:developer';

import 'package:empiregarage_mobile/application_layer/widgets/bottom_popup.dart';
import 'package:empiregarage_mobile/application_layer/widgets/screen_loading.dart';
import 'package:empiregarage_mobile/helper/webview_helper.dart';
import 'package:empiregarage_mobile/models/response/payment_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OrderPayment extends StatefulWidget {
  final Function callback;
  final String url;

  const OrderPayment({Key? key, required this.url, required this.callback})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OrderPaymentState createState() => _OrderPaymentState();
}

class _OrderPaymentState extends State<OrderPayment> {
  late WebViewController _controller;
  final LoadingWebPageBloc loadingWebPageBloc = LoadingWebPageBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) {
                _controller = controller;
              },
              onPageFinished: (String url) async {
                final String json =
                    // ignore: deprecated_member_use
                    await _controller
                        .evaluateJavascript('document.body.innerText');
                if (isJson(json)) {
                  final decoded = jsonDecode(json);
                  log(decoded);
                  // Process the decoded JSON data here
                  try {
                    PaymentResponseModel paymentResponseModel =
                        PaymentResponseModel.fromJson(jsonDecode(decoded));
                    log(paymentResponseModel.transactionId);

                    // ignore: unrelated_type_equality_checks
                    if (paymentResponseModel.vnPayResponseCode == "00" &&
                        paymentResponseModel.success == true) {
                      loadingWebPageBloc.add(LoadingWebPageEvent(false));
                      // ignore: use_build_context_synchronously
                      widget.callback();
                    } else {
                      log("Payment failed");
                      Get.back();
                      Get.bottomSheet(
                        BottomPopup(
                            image: 'assets/image/icon-logo/failed-icon.png',
                            title: "Thanh toán thất bại",
                            body: "Vui lòng thực hiện lại thanh toán",
                            buttonTitle: "Thử lại",
                            action: () => Get.back()),
                        backgroundColor: Colors.transparent,
                      );
                    }
                  } catch (e) {
                    e.toString();
                    return;
                  }
                }
              },
            ),
            StreamBuilder<bool>(
                stream: loadingWebPageBloc.loadingStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return const ScreenLoadingNoOpacity();
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}

bool isJson(String str) {
  try {
    json.decode(str);
    return true;
  } catch (_) {
    return false;
  }
}
