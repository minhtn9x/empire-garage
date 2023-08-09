import 'package:empiregarage_mobile/application_layer/screens/booking/booking_detail.dart';
import 'package:empiregarage_mobile/application_layer/screens/orders/order_detail.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/helper/common_helper.dart';
import 'package:empiregarage_mobile/models/response/orderservices.dart';
import 'package:empiregarage_mobile/models/response/workload.dart';
import 'package:empiregarage_mobile/services/order_services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../common/colors.dart';
import '../../services/booking_service/booking_service.dart';

class OnDoingService extends StatefulWidget {
  final int servicesId;
  const OnDoingService({super.key, required this.servicesId});

  @override
  State<OnDoingService> createState() => _OnDoingServiceState();
}

class _OnDoingServiceState extends State<OnDoingService> {
  int count = 1;
  bool isSelected = true;
  List<String> serviceNames = [
    'Thay lốp',
    'Thay nhớt',
    'Sửa chữa động cơ',
    'Kiểm tra định kỳ',
    'Thay bình ắc quy'
  ];
  List<String> servicePrices = [
    "8000000",
    "500000",
    "10000000",
    "150000",
    "200000"
  ];

  double sum = 0;
  double sumAfter = 0;
  double prepaid = 0;
  List<OrderServiceDetails> _listOrderServiceDetails = [];
  OrderServicesResponseModel? _orderServicesResponseModel;
  bool _loading = true;
  bool _expand = false;
  Workload? _workload;
  Workload? _startWorkload;

  _getExpertWorkload() async {
    if (_orderServicesResponseModel!.expert != null) {
      var workload = await OrderServices().getOrderServiceWorkload(
          _orderServicesResponseModel!.expert!.id,
          _orderServicesResponseModel!.id);
      if (workload != null) {
        var startWorkload = await OrderServices().getStartWorkload(
            _orderServicesResponseModel!.expert!.id,
            _orderServicesResponseModel!.id);
        _startWorkload = startWorkload;
      }
      setState(() {
        _workload = workload;
        _startWorkload;
      });
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
    if (!mounted) return;
    try {
      if (list != null) {
        setState(() {
          _listOrderServiceDetails =
              list.where((element) => element.isConfirmed == true).toList();
          _orderServicesResponseModel = listOrderServiceDetails;
          for (var item in _listOrderServiceDetails) {
            sum += int.parse(item.price.toString());
          }
          sumAfter = sum - prepaid;
          _getExpertWorkload();
          _loading = false;
        });
      }
    } catch (e) {
      e.toString();
    }
  }

  Future _reload() {
    return _getOrderServices();
  }

  @override
  void initState() {
    _getBookingPrice();
    _getOrderServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Loading()
        : RefreshIndicator(
            onRefresh: _reload,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(thickness: 1),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Center(
                    child: Text(
                      "Phương tiện đang được sửa chữa",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.sp, vertical: 10.sp),
                      child: Text(
                        "Bạn sẽ nhận được thông báo sau khi sửa chữa hoàn tất",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => OrderDetail(_orderServicesResponseModel!));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Xem ghi chú và đính kèm hình ảnh từ kỹ thuật viên',
                          style: AppStyles.header600(
                              fontsize: 10.sp, color: AppColors.blueTextColor),
                        ),
                        const Icon(
                          Icons.navigate_next_outlined,
                          color: AppColors.blueTextColor,
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1),
                  (_workload != null && _startWorkload != null)
                      ? Column(
                          children: [
                            SizedBox(
                              height: 10.sp,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.sp),
                              child: Text(
                                "Thời gian sửa chữa dự kiến",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.blackTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.sp),
                              child: Text(
                                "${formatDateIncludeTime(_startWorkload!.intendedFinishTime.toString(), false)} - ${formatDateIncludeTime(_workload!.intendedFinishTime.toString(), false)}",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.sp,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.sp),
                              child: const Divider(thickness: 1),
                            ),
                          ],
                        )
                      : Container(),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        _orderServicesResponseModel!
                                            .orderServiceDetails![index]
                                            .item!
                                            .name
                                            .toString(),
                                        style:
                                            AppStyles.text400(fontsize: 10.sp)),
                                    Visibility(
                                      visible: _expand,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 1.sp),
                                        child: Text(
                                            _orderServicesResponseModel!
                                                .orderServiceDetails![index]
                                                .item!
                                                .problem!
                                                .name
                                                .toString(),
                                            style: AppStyles.text400(
                                                fontsize: 10.sp,
                                                color: Colors.grey.shade500)),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                    formatCurrency(_orderServicesResponseModel!
                                        .orderServiceDetails![index].price),
                                    style: AppStyles.text400(fontsize: 10.sp)),
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
                  // CustomRowWithoutPadding(
                  //   title: 'Tổng tạm tính',
                  //   value: formatCurrency(sum),
                  //   textStyle: AppStyles.header600(fontsize: 10.sp),
                  // ),
                  // CustomRowWithoutPadding(
                  //   title: 'Khấu trừ từ đặt lịch',
                  //   value: "-${formatCurrency(prepaid)}",
                  //   textStyle:
                  //       AppStyles.header600(fontsize: 10.sp, color: Colors.red),
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomRowWithoutPadding(
                          title: 'Tổng cộng',
                          value: formatCurrency(sum + prepaid),
                          textStyle: AppStyles.header600(fontsize: 10.sp),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.verified,
                        size: 18,
                        color: AppColors.blueTextColor,
                      ),
                    ],
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
                  SizedBox(height: 20.sp),
                ],
              ),
            ),
          );
  }
}
