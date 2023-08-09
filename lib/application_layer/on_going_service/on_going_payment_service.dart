import 'package:empiregarage_mobile/application_layer/on_going_service/on_going_service.dart';
import 'package:empiregarage_mobile/application_layer/screens/main_page/main_page.dart';
import 'package:empiregarage_mobile/application_layer/widgets/bottom_popup.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/helper/common_helper.dart';
import 'package:empiregarage_mobile/models/request/order_service_detail_request_model.dart';
import 'package:empiregarage_mobile/models/response/workload.dart';
import 'package:empiregarage_mobile/services/payment_services/payment_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:empiregarage_mobile/application_layer/screens/booking/booking_detail.dart';

import '../../common/colors.dart';
import '../../models/request/payment_request_model.dart';
import '../../models/response/orderservices.dart';
import '../../services/booking_service/booking_service.dart';
import '../../services/order_services/order_services.dart';
import 'order_payment.dart';

class OnGoingPaymentService extends StatefulWidget {
  final int servicesId;
  final Function onGoingPaymentCallBack;
  final List<OrderServiceDetailRequestModel> listOrderServiceDetail;
  const OnGoingPaymentService({
    super.key,
    required this.onGoingPaymentCallBack,
    required this.servicesId,
    required this.listOrderServiceDetail,
  });

  @override
  State<OnGoingPaymentService> createState() => _OnGoingPaymentServiceState();
}

class _OnGoingPaymentServiceState extends State<OnGoingPaymentService> {
  int count = 1;
  double sum = 0;
  double sumAfter = 0;
  double prepaid = 0;
  List<OrderServiceDetailRequestModel> _listOrderServiceDetails = [];
  OrderServicesResponseModel? _orderServicesResponseModel;
  bool _loading = true;
  bool _expand = false;
  int _totalMinutes = 0;
  Workload? _workload;
  Workload? _currentExpertWorkload;

  _getExpectedWorkload() async {
    if (_orderServicesResponseModel != null) {
      var currentExpertWorkload = await OrderServices()
          .getWorkload(_orderServicesResponseModel!.expert!.id);
      if (currentExpertWorkload != null) {
        var totalPoints =
            _totalMinutes / currentExpertWorkload.minutesPerWorkload;
        var workload = await OrderServices().getExpectedWorkload(
            _orderServicesResponseModel!.expert!.id, totalPoints.toInt());
        setState(() {
          _workload = workload;
          _currentExpertWorkload = currentExpertWorkload;
        });
      }
    }
  }

  _getBookingPrice() async {
    var response = await BookingService().getBookingPrice();
    setState(() {
      prepaid = response;
    });
    return prepaid;
  }

  _getOrderServices() async {
    var listOrderServiceDetails =
        await OrderServices().getOrderServicesById(widget.servicesId);
    List<OrderServiceDetails>? list =
        listOrderServiceDetails!.orderServiceDetails;
    try {
      if (list != null) {
        setState(() {
          _listOrderServiceDetails = widget.listOrderServiceDetail;
          _orderServicesResponseModel = listOrderServiceDetails;
          for (var item in _listOrderServiceDetails) {
            sum += item.price;
          }
          sum += prepaid;
          sumAfter = sum - prepaid;
          _calculateTotalIntendedMinutes();
          _getExpectedWorkload();
          _loading = false;
        });
      }
    } catch (e) {
      e.toString();
    }
  }

  _payOrderFee(PaymentRequestModel model) async {
    var response = await PaymentServices().createNewPaymentForOrder(model);
    if (response!.statusCode == 500) {
      throw Exception("Can not pay order fee");
    }
    return response.body;
  }

  _pay() async {
    if (sumAfter == 0) {
      _onCallBack();
    } else {
      PaymentRequestModel paymentRequestModel = PaymentRequestModel(
          amount: sumAfter,
          name: 'OrderService Payment',
          orderDescription:
              'OrderService Payment for #${_orderServicesResponseModel!.code}',
          orderType: 'VNpay');
      var responsePayment = await _payOrderFee(paymentRequestModel);
      Get.to(() => OrderPayment(
            url: responsePayment,
            callback: _onCallBack,
          ));
    }
  }

  _onCallBack() async {
    var result = await OrderServices().insertOrderDetail(
        _orderServicesResponseModel!.id, 2, _listOrderServiceDetails);
    if (result == null || result.statusCode != 204) {
      throw Exception("Insert order detail fail");
    } else {
      Get.offAll(const MainPage());
      Get.to(() => OnGoingService(
            servicesId: _orderServicesResponseModel!.id,
          ));
      Get.bottomSheet(
        BottomPopup(
          image: 'assets/image/icon-logo/successfull-icon.png',
          title: "Thanh toán thành công",
          body:
              'Bạn đã thanh toán thành công, phương tiện của bạn sẽ được tiến hành sửa chữa',
          buttonTitle: "Trở về",
          action: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
      );
    }
  }

  String _getNameOfItem(int itemId) {
    for (var element in _orderServicesResponseModel!
        .healthCarRecord!.healthCarRecordProblems!) {
      for (var e in element.problem.items!) {
        if (e.id == itemId) return e.name;
      }
    }
    return "";
  }

  String _getProblemNameOfItem(int itemId) {
    for (var element in _orderServicesResponseModel!
        .healthCarRecord!.healthCarRecordProblems!) {
      var problemName = element.problem.name;
      for (var e in element.problem.items!) {
        if (e.id == itemId) return problemName.toString();
      }
    }
    return "";
  }

  _calculateTotalIntendedMinutes() {
    for (var element in _listOrderServiceDetails) {
      _totalMinutes += element.intendedMinutes ?? 0;
    }
  }

  @override
  void initState() {
    _getBookingPrice();
    _getOrderServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double hours = _totalMinutes / 60;
    double roundHours = double.parse(hours.toStringAsFixed(1));

    double minutesADay = 24 * 60;
    double days = _totalMinutes / minutesADay;
    double roundDays = double.parse(days.toStringAsFixed(1));

    return _loading
        ? const Loading()
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Divider(thickness: 1),
                    SizedBox(height: 10.sp),
                    Text(
                      "Kết quả chẩn đoán",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    ReadMoreText(
                      _orderServicesResponseModel!.healthCarRecord!.symptom
                          .toString(),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackTextColor,
                      ),
                      trimLines: 10,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' Read more',
                      trimExpandedText: ' Show less',
                    ),
                    SizedBox(height: 10.sp),
                    const Divider(thickness: 1),
                    SizedBox(height: 10.sp),
                    _currentExpertWorkload != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Thời gian bắt đầu dự kiến",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackTextColor,
                                ),
                              ),
                              Text(
                                formatDate(
                                    _currentExpertWorkload!.intendedFinishTime
                                        .toString(),
                                    true),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackTextColor,
                                ),
                              )
                            ],
                          )
                        : Container(),
                    _currentExpertWorkload != null
                        ? SizedBox(height: 5.sp)
                        : Container(),
                    _workload != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Thời gian hoàn tất dự kiến",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackTextColor,
                                ),
                              ),
                              Text(
                                formatDate(
                                    _workload!.intendedFinishTime.toString(),
                                    true),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackTextColor,
                                ),
                              )
                            ],
                          )
                        : Container(),
                    _workload != null ? SizedBox(height: 5.sp) : Container(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ước lượng",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                        Text(
                          "$roundHours Giờ làm việc",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackTextColor,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.sp),
                    const Divider(thickness: 1),
                    SizedBox(height: 10.sp),
                    Text(
                      "Tóm tắt thanh toán",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                    SizedBox(height: 5.sp),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.sp),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          _getNameOfItem(
                                              _listOrderServiceDetails[index]
                                                  .itemId),
                                          style: AppStyles.text400(
                                              fontsize: 10.sp)),
                                      Visibility(
                                        visible: _expand,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.sp),
                                          child: Text(
                                              _getProblemNameOfItem(
                                                  _listOrderServiceDetails[
                                                          index]
                                                      .itemId),
                                              style: AppStyles.text400(
                                                  fontsize: 10.sp,
                                                  color: Colors.grey.shade500)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                      formatCurrency(
                                          _listOrderServiceDetails[index]
                                              .price),
                                      style:
                                          AppStyles.text400(fontsize: 10.sp)),
                                ],
                              ),
                            ))
                          ],
                        );
                      },
                      itemCount: _listOrderServiceDetails.length,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: CustomRowWithoutPadding(
                                title: "Phí kiểm tra",
                                value: formatCurrency(prepaid),
                                textStyle: AppStyles.text400(fontsize: 10.sp))),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _expand = !_expand;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _expand ? 'Thu gọn' : 'Thêm chi tiết',
                              style: AppStyles.header600(
                                  fontsize: 10.sp, color: Colors.grey.shade500),
                            ),
                            Icon(
                                _expand
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey.shade500)
                          ],
                        ),
                      ),
                    ),
                    const Divider(thickness: 1),
                    CustomRowWithoutPadding(
                      title: 'Tổng tạm tính',
                      value: formatCurrency(sum),
                      textStyle: AppStyles.header600(fontsize: 10.sp),
                    ),
                    CustomRowWithoutPadding(
                      title: 'Khấu trừ từ đặt lịch',
                      value: "- ${formatCurrency(prepaid)}",
                      textStyle: AppStyles.header600(
                          fontsize: 10.sp, color: Colors.red),
                    ),
                    CustomRowWithoutPadding(
                      title: 'Số tiền cần thanh toán',
                      value: formatCurrency(sumAfter),
                      textStyle: AppStyles.header600(fontsize: 10.sp),
                    ),
                    const Divider(thickness: 1),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Phương thức thanh toán',
                            style: AppStyles.text400(fontsize: 10.sp),
                          ),
                          Image.asset(
                            'assets/image/icon-logo/vnpay.png',
                            height: 12.sp,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5.sp),
                    // ExpansionTile(
                    //   trailing: const Icon(
                    //     Icons.abc_sharp,
                    //     color: Colors.transparent,
                    //   ),
                    //   title: Center(
                    //     child: SizedBox(
                    //       width: 180.w,
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(left: 50),
                    //         child: Row(
                    //           children: [
                    //             Text(
                    //               "Xem thêm chi tiết ",
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(
                    //                 fontFamily: 'Roboto',
                    //                 fontSize: 12.sp,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: AppColors.blueTextColor,
                    //               ),
                    //             ),
                    //             const Icon(
                    //               Icons.add_circle_outline_sharp,
                    //               size: 16,
                    //               color: AppColors.blueTextColor,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   children: <Widget>[
                    //     ListTile(
                    //       leading: Image.asset(
                    //         "assets/image/service-picture/mechanicPic.png",
                    //         height: 40.sp,
                    //         width: 50.sp,
                    //       ),
                    //       title: Text(
                    //         _orderServicesResponseModel!.expert == null
                    //             ? "Chưa có kỹ thuật viên"
                    //             : _orderServicesResponseModel!.expert!.fullname,
                    //         style: TextStyle(
                    //           fontFamily: 'Roboto',
                    //           fontSize: 12.sp,
                    //           fontWeight: FontWeight.w600,
                    //           color: AppColors.blackTextColor,
                    //         ),
                    //       ),
                    //       subtitle: Text(
                    //         "Kỹ thuật viên",
                    //         style: TextStyle(
                    //           fontFamily: 'Roboto',
                    //           fontSize: 10.sp,
                    //           fontWeight: FontWeight.w400,
                    //           color: AppColors.blackTextColor,
                    //         ),
                    //       ),
                    //     ),
                    //     const Divider(thickness: 1),
                    //     SizedBox(height: 10.sp),
                    //     ListTile(
                    //       leading: FutureBuilder(
                    //           future: BrandService().getPhoto(
                    //               _orderServicesResponseModel!.car.carBrand),
                    //           builder: (context, snapshot) {
                    //             if (snapshot.hasData) {
                    //               return Image.network(
                    //                 snapshot.data.toString(),
                    //                 height: 40.sp,
                    //                 width: 50.sp,
                    //               );
                    //             } else if (snapshot.hasError) {
                    //               return Image.asset(
                    //                 "assets/image/icon-logo/bmw-car-icon.png",
                    //                 height: 40.sp,
                    //                 width: 50.sp,
                    //               );
                    //             } else {
                    //               return Image.asset(
                    //                 "assets/image/icon-logo/bmw-car-icon.png",
                    //                 height: 40.sp,
                    //                 width: 50.sp,
                    //               );
                    //             }
                    //           }),
                    //       title: Text(
                    //         _orderServicesResponseModel!.car.carBrand,
                    //         style: TextStyle(
                    //           fontFamily: 'Roboto',
                    //           fontSize: 10.sp,
                    //           fontWeight: FontWeight.w400,
                    //           color: AppColors.lightTextColor,
                    //         ),
                    //       ),
                    //       subtitle: Align(
                    //         alignment: Alignment.topLeft,
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             SizedBox(
                    //               height: 5.h,
                    //             ),
                    //             Text(
                    //               _orderServicesResponseModel!.car.carLisenceNo,
                    //               style: TextStyle(
                    //                 fontFamily: 'Roboto',
                    //                 fontSize: 12.sp,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: AppColors.blackTextColor,
                    //               ),
                    //             ),
                    //             SizedBox(
                    //               height: 5.h,
                    //             ),
                    //             Text(
                    //               _orderServicesResponseModel!.car.carModel,
                    //               style: TextStyle(
                    //                 fontFamily: 'Roboto',
                    //                 fontSize: 10.sp,
                    //                 fontWeight: FontWeight.w400,
                    //                 color: AppColors.lightTextColor,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(height: 10.sp),
                    //   ],
                    // ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              SizedBox(height: 10.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 150.w,
                    height: 52.sp,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onGoingPaymentCallBack();
                      },
                      style: AppStyles.button16(color: Colors.grey.shade500),
                      child: Text(
                        'Quay lại',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150.w,
                    height: 52.sp,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.bottomSheet(
                          BottomPopup(
                            image: 'assets/image/service-picture/confirmed.png',
                            title: "Bạn có muốn thanh toán ?",
                            body:
                                'Phương tiện của bạn sẽ được tiến hành thực hiện sửa chữa sau khi thanh toán hoàn tất',
                            buttonTitle: "Xác nhận",
                            action: () {
                              Get.to(_pay());
                            },
                            addition: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(children: [
                                _currentExpertWorkload != null
                                    ? RichText(
                                        text: TextSpan(
                                            text: "Thời gian bắt đầu dự kiến: ",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.blackTextColor,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: formatDate(
                                                    _currentExpertWorkload!
                                                        .intendedFinishTime
                                                        .toString(),
                                                    true),
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.blackTextColor,
                                                ),
                                              )
                                            ]),
                                      )
                                    : Container(),
                                _currentExpertWorkload != null
                                    ? SizedBox(height: 5.sp)
                                    : Container(),
                                _workload != null
                                    ? RichText(
                                        text: TextSpan(
                                            text:
                                                "Thời gian hoàn tất dự kiến: ",
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.blackTextColor,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: formatDate(
                                                    _workload!
                                                        .intendedFinishTime
                                                        .toString(),
                                                    true),
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppColors.blackTextColor,
                                                ),
                                              )
                                            ]),
                                      )
                                    : Container(),
                                _workload != null
                                    ? SizedBox(height: 5.sp)
                                    : Container(),
                                RichText(
                                  text: TextSpan(
                                      text: "Ước lượng: ",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackTextColor,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "$roundHours Giờ làm việc",
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackTextColor,
                                          ),
                                        ),
                                      ]),
                                ),
                                SizedBox(height: 10.sp),
                              ]),
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      },
                      style: AppStyles.button16(),
                      child: Text(
                        'Tiếp tục',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.sp,
              ),
            ],
          );
  }
}
