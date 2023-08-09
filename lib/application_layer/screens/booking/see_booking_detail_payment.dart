import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/colors.dart';
import '../../../services/booking_service/booking_service.dart';
import '../../widgets/loading.dart';

class SeeBookingDetailPayment extends StatefulWidget {
  const SeeBookingDetailPayment({super.key});

  @override
  State<SeeBookingDetailPayment> createState() =>
      _SeeBookingDetailPaymentState();
}

class _SeeBookingDetailPaymentState extends State<SeeBookingDetailPayment> {
  double _bookingPrice = 0;
  bool _loading = true;

  _getBookingPrice() async {
    var response = await BookingService().getBookingPrice();
    setState(() {
      _bookingPrice = response;
      _loading = false;
    });
    return _bookingPrice;
  }

  @override
  void initState() {
    _getBookingPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
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
                  color: AppColors.blackTextColor,
                )),
          ),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: const Text('Chi tiết thanh toán',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            )),
      ),
      body: _loading
          ? const Loading()
          : Column(children: <Widget>[
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 24, bottom: 24, top: 24),
                    child: Text("Thanh toán",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.grey600,
                        )),
                  ),
                ],
              ),
              Container(
                width: 375.w,
                height: 98.h,
                color: AppColors.white100,
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 24, bottom: 24),
                        child: Text("Phí đặt chỗ",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.blackTextColor,
                            )),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 24, bottom: 24),
                        child: Text(
                            NumberFormat.currency(
                                    decimalDigits: 0, locale: 'vi_VN')
                                .format(_bookingPrice)
                                .toString(),
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.blackTextColor,
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 24, bottom: 24),
                        child: Text("Tổng tiền",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.blackTextColor,
                            )),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 24, bottom: 24),
                        child: Text(NumberFormat.currency(
                                    decimalDigits: 0, locale: 'vi_VN')
                                .format(_bookingPrice)
                                .toString(),
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.blackTextColor,
                            )),
                      ),
                    ],
                  ),
                ]),
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 24, bottom: 24),
                    child: Text("Phương thức thanh toán",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: AppColors.grey600,
                        )),
                  ),
                ],
              ),
              Container(
                width: 375.w,
                height: 98.h,
                color: AppColors.white100,
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 24),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              color: AppColors.blackTextColor,
                            ),
                            Text("Ví điện tử",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: AppColors.blackTextColor,
                                )),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 24, bottom: 24),
                        child: Text(NumberFormat.currency(
                                    decimalDigits: 0, locale: 'vi_VN')
                                .format(_bookingPrice)
                                .toString(),
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.blackTextColor,
                            )),
                      ),
                    ],
                  ),
                ]),
              ),
            ]),
    );
  }
}
