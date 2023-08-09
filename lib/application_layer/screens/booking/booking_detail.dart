import 'package:empiregarage_mobile/application_layer/screens/activities/qrcode.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/application_layer/widgets/pick_date_booking.dart';
import 'package:empiregarage_mobile/common/app_settings.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/helper/common_helper.dart';
import 'package:empiregarage_mobile/models/response/activity.dart';
import 'package:empiregarage_mobile/models/response/booking.dart';
import 'package:empiregarage_mobile/services/booking_service/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../main_page/main_page.dart';

class BookingDetail extends StatefulWidget {
  final ActivityResponseModel data;
  const BookingDetail({super.key, required this.data});

  @override
  State<BookingDetail> createState() => _BookingDetailState();
}

class _BookingDetailState extends State<BookingDetail> {

  BookingResponseModel? _booking;
  bool _loading = true;

  _fetchData() async {
    var booking = await BookingService().getBookingById(widget.data.id);
    if (!mounted) return;
    setState(() {
      _booking = booking;
      _loading = false;
    });
  }


  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    if (_booking != null) {
      String date = _booking!.date.substring(0, 10);
      DateTime dateTime = DateTime.parse(date);
      formattedDate =
          '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year.toString()}';
    } else {
      // handle the case where _booking or _booking!.date is null
      const Loading();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _loading
          ? const Loading()
          : SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  toolbarHeight: 55.sp,
                  leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.black,
                    ),
                  ),
                  title: Text(
                    "Ngày ${widget.data.date!.day.toString().padLeft(2, '0')} tháng ${widget.data.date!.month.toString().padLeft(2, '0')}, ${widget.data.date!.year}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  centerTitle: true,
                  actions: widget.data.isArrived == true
                      ? null
                      : [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: InkWell(
                                onTap: () {},
                                child: PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_horiz,
                                    color: AppColors.blackTextColor,
                                  ),
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: 'cancel',
                                      child: Text('Hủy',
                                          style: AppStyles.text400(
                                              fontsize: 14.sp,
                                              color: AppColors.errorIcon)),
                                    ),
                                  ],
                                  onSelected: (String selectedItem) {
                                    switch (selectedItem) {
                                      case 'cancel':
                                        Get.bottomSheet(
                                          CancelBooking(widget: widget),
                                          backgroundColor: Colors.transparent,
                                        );
                                        break;
                                      default:
                                    }
                                  },
                                )),
                          )
                        ],
                ),
                body: SingleChildScrollView(
                  child: Container(
                    color: const Color(0xfff9f9f9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.sp,
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Mã đặt lịch",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              Text(
                                "#${widget.data.code.toString()}",
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
                          height: 10.sp,
                        ),
                        InkWell(
                          onTap: () {
                            widget.data.daysLeft == 0
                                ? Get.to(() => QRCodePage(
                                      bookingId: _booking!.id,
                                    ))
                                : null;
                          },
                          child: Container(
                            color: Colors.white,
                            height: 70.sp,
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Image.asset(
                                  "assets/image/icon-logo/calendar-history-icon.png",
                                  height: 30.sp,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Đặt lịch đến ${AppSettings.garaName}",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    _booking!.isArrived
                                        ? 'Đã check-in vào ${formatDate(_booking!.arrivedDateTime.toString(), true)}'
                                        : widget.data.daysLeft == 0
                                            ? "Lấy mã check-in"
                                            : 'Còn ${widget.data.daysLeft} ngày',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 10.sp,
                                      fontWeight: _booking!.isArrived
                                          ? FontWeight.w400
                                          : widget.data.daysLeft == 0
                                              ? FontWeight.w400
                                              : FontWeight.w600,
                                      color: _booking!.isArrived
                                          ? AppColors.lightTextColor
                                          : widget.data.daysLeft == 0
                                              ? AppColors.lightTextColor
                                              : AppColors.blueTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: widget.data.daysLeft == 0 &&
                                      _booking!.isArrived == false
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Icon(Icons.qr_code_scanner,
                                          color: AppColors.blueTextColor,
                                          size: 30.w),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.sp, right: 10.sp, top: 20.sp),
                                child: Text(
                                  "Tóm tắt hóa đơn",
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
                              CustomRow(
                                title: 'Phí đặt lịch',
                                value: formatCurrency(_booking!.total),
                                textStyle: AppStyles.text400(fontsize: 10.sp),
                              ),
                              const CustomSpacer(),
                              CustomRow(
                                title: 'Tổng cộng',
                                value: formatCurrency(_booking!.total),
                                textStyle: AppStyles.header600(fontsize: 10.sp),
                              ),
                              const CustomSpacer(),
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
                              const CustomSpacer(),
                              CustomRow(
                                title: 'Biển số xe',
                                value: _booking!.car.carLisenceNo.toString(),
                                textStyle: AppStyles.text400(fontsize: 10.sp),
                              ),
                              CustomRow(
                                title: 'Dòng xe',
                                value:
                                    '${_booking!.car.carBrand} ${_booking!.car.carModel}',
                                textStyle: AppStyles.text400(fontsize: 10.sp),
                              ),
                              CustomRow(
                                title: 'Tên chủ xe',
                                value: _booking!.user.fullname,
                                textStyle: AppStyles.text400(fontsize: 10.sp),
                              ),
                              CustomRow(
                                title: 'Số điện thoại',
                                value: _booking!.user.phone,
                                textStyle: AppStyles.text400(fontsize: 10.sp),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.sp),
                                    child: Text('Tình trạng xe',
                                        style: AppStyles.header600(
                                            fontsize: 12.sp)),
                                  ),
                                  SizedBox(
                                    height: 5.sp,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.sp),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _booking!.symptoms.length,
                                      itemBuilder: (context, index) {
                                        var item = _booking!.symptoms[index];
                                        return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.sp),
                                            margin: EdgeInsets.only(left: 2.sp),
                                            child: Text(
                                              item.name.toString(),
                                              style: AppStyles.text400(
                                                  fontsize: 10.sp),
                                            ));
                                      },
                                    ),
                                  ),
                                  Visibility(
                                      visible: _booking!
                                          .unresolvedProblems.isNotEmpty,
                                      child: const CustomSpacer()),
                                  Visibility(
                                    visible:
                                        _booking!.unresolvedProblems.isNotEmpty,
                                    child: SizedBox(
                                      height: 5.sp,
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        _booking!.unresolvedProblems.isNotEmpty,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.sp),
                                      child: Text('Vấn đề tái sửa chữa',
                                          style: AppStyles.header600(
                                              fontsize: 12.sp)),
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        _booking!.unresolvedProblems.isNotEmpty,
                                    child: SizedBox(
                                      height: 5.sp,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.sp),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          _booking!.unresolvedProblems.length,
                                      itemBuilder: (context, index) {
                                        var item =
                                            _booking!.unresolvedProblems[index];
                                        return Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.sp),
                                            margin: EdgeInsets.only(left: 2.sp),
                                            child: Text(
                                              item.name.toString(),
                                              style: AppStyles.text400(
                                                  fontsize: 10.sp),
                                            ));
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.sp,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                    child: widget.data.daysLeft == 0
                        ? ElevatedButton(
                            onPressed: () {
                              Get.to(() => QRCodePage(
                                    bookingId: _booking!.id,
                                  ));
                            },
                            style: AppStyles.button16(),
                            child: Text(
                              'Check-in',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : ElevatedButton(
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
              ),
            ),
    );
  }
}

class CancelBooking extends StatelessWidget {
  const CancelBooking({
    super.key,
    required this.widget,
  });

  final BookingDetail widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), //color of shadow
            spreadRadius: 5, //spread radius
            blurRadius: 7, // blur radius
            offset: const Offset(0, 2), // changes position of shadow
            //first paramerter of offset is left-right
            //second parameter is top to down
          ),
          //you can set more BoxShadow() here
        ],
      ),
      height: 300.h,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Icon(Icons.warning_rounded, size: 100.sp, color: AppColors.errorIcon),
        Text(
          'Xác nhận hủy đặt lịch',
          style: AppStyles.header600(),
        ),
        Text(
            'Bạn chắc chắn muốn hủy đặt lịch? Bạn sẽ mất tiền trước đó đã thanh toán.',
            textAlign: TextAlign.center,
            style: AppStyles.text400(
                fontsize: 14.sp, color: AppColors.lightTextColor)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.blue600,
                fixedSize: Size.fromHeight(50.w),
                maximumSize: Size.fromWidth(130.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
              ),
              child: Text(
                'Hủy',
                style: TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white100,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorIcon,
                fixedSize: Size.fromHeight(50.w),
                maximumSize: Size.fromWidth(130.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36),
                ),
              ),
              onPressed: () async {
                var response =
                    await BookingService().cancelBooking(widget.data.id);
                if (response.statusCode == 204) {
                  Get.back();
                  Get.offAll(() => const MainPage());
                } else {
                  Get.back();
                }
              },
              child: Text(
                'Xác nhận',
                style: TextStyle(
                  fontFamily: AppStyles.fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class CustomSpacer extends StatelessWidget {
  const CustomSpacer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15.sp,
      child: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.sp),
        child: const Divider(thickness: 1),
      )),
    );
  }
}

class CustomRow extends StatelessWidget {
  String title;
  String value;
  TextStyle? textStyle;
  CustomRow(
      {super.key, required this.title, required this.value, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textStyle),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}

class CustomRowWithoutPadding extends StatelessWidget {
  String title;
  String value;
  TextStyle? textStyle;
  CustomRowWithoutPadding(
      {super.key, required this.title, required this.value, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: textStyle),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}
