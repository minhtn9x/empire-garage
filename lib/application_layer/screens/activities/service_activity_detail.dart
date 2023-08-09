import 'package:empiregarage_mobile/application_layer/screens/orders/order_detail.dart';
import 'package:empiregarage_mobile/application_layer/widgets/pick_date_booking.dart';
import 'package:empiregarage_mobile/common/app_settings.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/models/response/orderservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/colors.dart';
import '../../../services/booking_service/booking_service.dart';
import '../../../services/order_services/order_services.dart';
import '../../widgets/loading.dart';

class ServiceActivityDetail extends StatefulWidget {
  final int orderServicesId;
  const ServiceActivityDetail({super.key, required this.orderServicesId});

  @override
  State<ServiceActivityDetail> createState() => _ServiceActivityDetailState();
}

class _ServiceActivityDetailState extends State<ServiceActivityDetail> {
  bool _loading = true;
  OrderServicesResponseModel? _orderServices;
  List<OrderServiceDetails> _listOrderServiceDetails = [];
  double _bookingPrice = 0;
  double sum = 0;
  double sumAfter = 0;
  bool _expand = false;

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

  _getBookingPrice() async {
    var response = await BookingService().getBookingPrice();
    if (!mounted) return;
    setState(() {
      _bookingPrice = response;
    });
    return _bookingPrice;
  }

  _fetchData() async {
    var listOrderServicesDetails =
        await OrderServices().getOrderServicesById(widget.orderServicesId);
    List<OrderServiceDetails>? list =
        listOrderServicesDetails!.orderServiceDetails;
    try {
      if (list != null) {
        setState(() {
          _listOrderServiceDetails =
              list.where((element) => element.isConfirmed == true).toList();
          _orderServices = listOrderServicesDetails;
          for (var item in _listOrderServiceDetails) {
            sum += int.parse(item.price.toString());
          }
          sum += _bookingPrice;
          sumAfter = sum;
          _loading = false;
        });
      }
    } catch (e) {
      e.toString();
    }
  }

  @override
  void initState() {
    _getBookingPrice();
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String arrivedDate = '';
    String checkedOutDate = '';
    String vnTime = '';
    String formattedTimeString = '';
    if (_orderServices != null) {
      String createDate = _orderServices!.order.createdAt.substring(0, 10);
      String checkOut = _orderServices!.order.updatedAt.substring(0, 10);
      String vnTime =
          _orderServices!.order.updatedAt.toString().substring(11, 16);
      DateTime createDateTime = DateTime.parse(createDate);
      DateTime checkOutTime = DateTime.parse(checkOut);
      DateTime originalDateTime = DateTime.utc(1970, 1, 1,
          int.parse(vnTime.substring(0, 2)), int.parse(vnTime.substring(3)));
      DateTime vietnamDateTime =
          originalDateTime.toUtc().add(const Duration(hours: 7));
      formattedTimeString = DateFormat('HH:mm').format(vietnamDateTime);
      arrivedDate =
          '${createDateTime.day.toString().padLeft(2, '0')}/${createDateTime.month.toString().padLeft(2, '0')}/${createDateTime.year.toString()}';
      checkedOutDate =
          '${checkOutTime.day.toString().padLeft(2, '0')}/${checkOutTime.month.toString().padLeft(2, '0')}/${checkOutTime.year.toString()}';
    } else {
      // handle the case where _booking or _booking!.date is null
      const Loading();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 55.sp,
        leading: Padding(
          padding: EdgeInsets.only(top: 10.sp),
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.black,
            ),
          ),
        ),
        title: _loading == true
            ? const Loading()
            : Padding(
                padding: EdgeInsets.only(top: 10.sp),
                child: Text(
                  _orderServices!.car.carLisenceNo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackTextColor,
                  ),
                ),
              ),
        centerTitle: true,
      ),
      body: _loading == true
          ? const Loading()
          : SingleChildScrollView(
              child: Container(
                color: const Color(0xfff9f9f9),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mã đơn hàng",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          Text(
                            "#${_orderServices?.code.toString()}",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      color: Colors.white,
                      height: 70.sp,
                      child: ListTile(
                        leading: Image.asset(
                          "assets/image/icon-logo/service-logo.png",
                          height: 30.sp,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sử dụng dịch vụ tại ${AppSettings.garaName}",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackTextColor,
                              ),
                            ),
                            SizedBox(height: 5.sp),
                            Text(
                              "Ngày đến: $arrivedDate",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            SizedBox(height: 5.sp),
                            Text(
                              'Ngày nhận xe: $checkedOutDate',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            SizedBox(height: 5.sp),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.sp, right: 10.sp, top: 20.sp),
                                child: Text(
                                  "Tóm tắt thanh toán",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackTextColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.sp,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    _orderServices!.orderServiceDetails?.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.sp,
                                        right: 10.sp,
                                        bottom: 10.sp),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _orderServices!
                                                    .orderServiceDetails![index]
                                                    .item!
                                                    .name
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.blackTextColor,
                                                ),
                                              ),
                                              Visibility(
                                                visible: _expand,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.sp),
                                                  child: Text(
                                                      _orderServices!
                                                          .orderServiceDetails![
                                                              index]
                                                          .item!
                                                          .problem!
                                                          .name
                                                          .toString(),
                                                      style: AppStyles.text400(
                                                          fontsize: 10.sp,
                                                          color: Colors
                                                              .grey.shade500)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                                  decimalDigits: 0,
                                                  locale: 'vi_VN',
                                                  symbol: 'đ')
                                              .format(_orderServices!
                                                  .orderServiceDetails![index]
                                                  .price)
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.blackTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.sp, right: 10.sp, bottom: 10.sp),
                                child: Row(
                                  children: [
                                    Text(
                                      "Phí kiểm tra",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackTextColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      NumberFormat.currency(
                                              decimalDigits: 0,
                                              locale: 'vi_VN',
                                              symbol: 'đ')
                                          .format(_bookingPrice)
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _expand = !_expand;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _expand ? 'Thu gọn' : 'Thêm chi tiết',
                                        style: AppStyles.header600(
                                            fontsize: 10.sp,
                                            color: Colors.grey.shade500),
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
                              SizedBox(
                                height: 10.sp,
                                child: Center(
                                    child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.sp),
                                  child: const Divider(
                                    thickness: 1,
                                  ),
                                )),
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.sp),
                                child: Row(
                                  children: [
                                    Text(
                                      "Tổng cộng",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackTextColor,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      NumberFormat.currency(
                                              decimalDigits: 0,
                                              locale: 'vi_VN',
                                              symbol: 'đ')
                                          .format(sumAfter)
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              SizedBox(
                                height: 10.sp,
                                child: Center(
                                    child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.sp),
                                  child: const Divider(thickness: 1),
                                )),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.sp, vertical: 10.sp),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              SizedBox(
                                height: 10.sp,
                                child: Center(
                                    child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.sp,
                                  ),
                                  child: const Divider(thickness: 1),
                                )),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => OrderDetail(_orderServices!));
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.sp, vertical: 10.sp),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Xem hình ảnh và ghi chú',
                                        style: AppStyles.header600(
                                            fontsize: 10.sp,
                                            color: AppColors.blueTextColor),
                                      ),
                                      const Icon(Icons.navigate_next,
                                          color: AppColors.blueTextColor)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.sp,
                              ),
                              CarInfo(
                                title: 'Biển số xe',
                                value:
                                    _orderServices!.car.carLisenceNo.toString(),
                              ),
                              CarInfo(
                                title: 'Dòng xe',
                                value:
                                    '${_orderServices!.car.carBrand} ${_orderServices!.car.carModel}',
                              ),
                              CarInfo(
                                title: 'Tên chủ xe',
                                value: _orderServices!.order.user.fullname,
                              ),
                              CarInfo(
                                title: 'Số điện thoại',
                                value: _orderServices!.order.user.phone,
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.symmetric(
                horizontal: BorderSide.merge(
                    BorderSide(color: Colors.grey.shade200, width: 1),
                    BorderSide.none))),
        child: Container(
          margin: const EdgeInsets.all(20),
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: () {
              Get.bottomSheet(const PickDateBooking());
            },
            style: AppStyles.button16(),
            child: Text(
              'Đặt lịch lại',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarInfo extends StatelessWidget {
  String title;
  String value;
  CarInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppStyles.text400(
              fontsize: 10.sp,
            ),
          ),
          Text(
            value,
            style: AppStyles.text400(
              fontsize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
