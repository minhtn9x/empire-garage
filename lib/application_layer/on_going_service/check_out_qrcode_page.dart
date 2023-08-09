import 'package:empiregarage_mobile/application_layer/widgets/countdown_timer.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/common/colors.dart';
import 'package:empiregarage_mobile/models/response/orderservices.dart';
import 'package:empiregarage_mobile/services/order_services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckOutQRCodePage extends StatefulWidget {
  final int id;

  const CheckOutQRCodePage({super.key, required this.id});

  @override
  State<CheckOutQRCodePage> createState() => _CheckOutQRCodePageState();
}

class _CheckOutQRCodePageState extends State<CheckOutQRCodePage> {
  Future<String>? _qrCodeFuture;
  String? _qrCodeData;
  OrderServicesResponseModel? _orderService;
  @override
  void initState() {
    _qrCodeFuture = _getQrCode();
    super.initState();
  }

  Future<String>? _getQrCode() async {
    var response = await OrderServices().getQrCode(widget.id);
    _orderService = await _getData();
    if (!mounted) return '';
    setState(() {
      _qrCodeData = response;
    });
    return response.toString();
  }

  _getData() async {
    var response = await OrderServices().getOrderServicesById(widget.id);
    return response;
  }

  _onCountdownComplete() {
    var qrCode = _getQrCode();
    setState(() {
      _qrCodeFuture = qrCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonColor,
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 30),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(
                color: AppColors.searchBarColor,
                width: 1.0,
              ),
            ),
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_outlined,
                  color: AppColors.searchBarColor,
                )),
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text('Quét mã QR Code',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              )),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: _qrCodeFuture,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                String name = _orderService!.order.user.fullname;
                String date = _orderService!.order.createdAt
                    .substring(0, 16)
                    .replaceAll("T", " ");
                String phone = _orderService!.order.user.phone;
                String car = _orderService!.car.carLisenceNo;
                return _qrCodeData != null
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Đưa mã này cho nhân viên',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColors.lightTextColor,
                                )),
                            const SizedBox(height: 10),
                            QrImage(
                              data: _qrCodeData.toString(),
                              version: QrVersions.auto,
                              size: 250,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Tự động cập nhật sau ',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: AppColors.lightTextColor,
                                    )),
                                CountdownTimer(
                                  onCountdownComplete: _onCountdownComplete,
                                ),
                                const Text(' giây. ',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: AppColors.lightTextColor,
                                    )),
                                InkWell(
                                  onTap: () {
                                    _onCountdownComplete();
                                  },
                                  child: const Text('Cập nhật',
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: AppColors.blueTextColor,
                                      )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 40,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                      color: AppColors.buttonColor,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomRight: Radius.circular(20))),
                                ),
                                Dash(
                                    direction: Axis.horizontal,
                                    length: 250.w,
                                    dashLength: 6,
                                    dashGap: 6,
                                    dashColor: AppColors.searchBarColor,
                                    dashThickness: 3),
                                RotatedBox(
                                  quarterTurns: 2,
                                  child: Container(
                                    height: 40,
                                    width: 20,
                                    decoration: const BoxDecoration(
                                        color: AppColors.buttonColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20))),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 22.h,
                                  child: const ListTile(
                                    title: Text('Chủ xe',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.lightTextColor,
                                        )),
                                    trailing: Text('Giờ vào bãi',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.lightTextColor,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                  child: ListTile(
                                    title: Text(name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: AppColors.blackTextColor,
                                        )),
                                    trailing: Text(date,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: AppColors.blackTextColor,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  height: 22.h,
                                  child: const ListTile(
                                    title: Text('Số điện thoại',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.lightTextColor,
                                        )),
                                    trailing: Text('Phương tiện',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.lightTextColor,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: ListTile(
                                    title: Text(phone,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: AppColors.blackTextColor,
                                        )),
                                    trailing: SizedBox(
                                      width: 150.w,
                                      child: Text(car,
                                          maxLines: 2,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: AppColors.blackTextColor,
                                          )),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    : const Text("QR Code is invalid!");
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Text('No Data');
              }
            } else {
              return const Loading();
            }
          },
        ),
      ),
    );
  }
}
