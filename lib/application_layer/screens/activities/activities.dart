import 'package:empiregarage_mobile/application_layer/on_going_service/check_out_qrcode_page.dart';
import 'package:empiregarage_mobile/application_layer/on_going_service/on_going_service.dart';
import 'package:empiregarage_mobile/application_layer/screens/activities/qrcode.dart';
import 'package:empiregarage_mobile/application_layer/screens/activities/service_activity_detail.dart';
import 'package:empiregarage_mobile/application_layer/screens/booking/booking_detail_v2.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/helper/common_helper.dart';
import 'package:empiregarage_mobile/models/response/activity.dart';
import 'package:empiregarage_mobile/services/activity_services/activity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import 'activity_history.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  State<Activities> createState() => _HomePageState();
}

class _HomePageState extends State<Activities> {
  bool _loading = true;
  List<ActivityResponseModel?> _listOnGoing = [];
  List<ActivityResponseModel?> _listRecent = [];

  MaterialStateProperty<Color> getColor(Color color, Color colorPressed) {
    getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }

  _fetchData() async {
    var userId = await getUserId();
    if (userId == null) {
      return;
    }
    // var listOnGoingBooking = await BookingService().getOnGoingBooking(userId);
    // var listBookingByUser = await BookingService().getBookingByUser(userId);
    var listActivity = await ActivityService().fetchActivity(userId);
    var listOngoingActivity =
        await ActivityService().fetchOnGoingActivity(userId);
    if (!mounted) return;
    setState(() {
      _listOnGoing = listOngoingActivity
          .where((element) =>
              element!.isOnGoing == true ||
              element.isMaintenanceSchedule == true)
          .where((element) => element!.status == null || element.status != 5)
          .toList();
      // _listOnGoing.sort(((a, b) => a!.daysLeft!.compareTo(b!.daysLeft as num)));
      _listRecent = listActivity
          .where((element) =>
              element!.isOnGoing != true &&
              (element.status == null || element.status == 5))
          .toList();
      _loading = false;
    });
  }

  Future reload() {
    return _fetchData();
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: AppBar(
              titleSpacing: 24.w,
              toolbarHeight: 100.h,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              title: Text('Hoạt động',
                  style: AppStyles.header600(fontsize: 20.sp)),
              actions: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 24.w),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.refresh, size: 18.sp),
                      onPressed: () {
                        Get.to(() => const ActivityHistory());
                      },
                      style: ButtonStyle(
                        shadowColor:
                            getColor(Colors.transparent, Colors.transparent),
                        foregroundColor: getColor(AppColors.blackTextColor,
                            AppColors.whiteButtonColor),
                        backgroundColor:
                            getColor(AppColors.blue100, AppColors.buttonColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        )),
                      ),
                      label: Text(
                        'Lịch sử',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Roboto',
                            color: AppColors.blackTextColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: _loading
            ? const Loading()
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: reload,
                  color: AppColors.blue600,
                  child: ListView(children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    _listOnGoing.isEmpty
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              "Đang hoạt động",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackTextColor,
                                  fontFamily: 'Roboto'),
                            ),
                          ),
                    _listOnGoing.isEmpty
                        ? Container()
                        : SizedBox(
                            height: 10.h,
                          ),
                    _listOnGoing.isEmpty
                        ? Container()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const ScrollPhysics(
                                parent: NeverScrollableScrollPhysics()),
                            scrollDirection: Axis.vertical,
                            itemCount: _listOnGoing.length,
                            itemBuilder: (context, index) {
                              var item = _listOnGoing[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                        () => item.isBooking
                                            ? BookingDetailv2(
                                                bookingId: item.id,
                                              )
                                            : OnGoingService(
                                                servicesId: item.id,
                                              ),
                                        transition: Transition.downToUp);
                                  },
                                  child: item!.isMaintenanceSchedule == true
                                      ? SizedBox(
                                          height: 75.h,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Image.asset(
                                                  'assets/image/icon-logo/homeservice-logo-care.png',
                                                  fit: BoxFit.contain,
                                                  height: 40.sp,
                                                  width: 50.sp,
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Lịch bảo trì",
                                                    style: AppStyles.header600(
                                                        fontsize: 10.sp,
                                                        color: AppColors
                                                            .greenTextColor),
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    '${item.car!.carBrand} ${item.car!.carModel} ${item.car!.carLisenceNo}',
                                                    style: AppStyles.text400(
                                                        fontsize: 12.sp),
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    formatDate(
                                                        item.date.toString(),
                                                        false),
                                                    style: AppStyles.text400(
                                                        fontsize: 10.sp),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : ActivityChip.haveTotal(
                                          carInfo:
                                              '${item.car!.carBrand} ${item.car!.carModel} ${item.car!.carLisenceNo}',
                                          date: item.date.toString(),
                                          code: item.code != null
                                              ? item.code.toString()
                                              : "##########",
                                          daysLeft: item.daysLeft,
                                          isBooking: item.isBooking,
                                          item: item,
                                          total: item.total,
                                        ),
                                ),
                              );
                            },
                          ),
                    _listOnGoing.isEmpty
                        ? Container()
                        : SizedBox(
                            height: 15.h,
                          ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        "Gần đây",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackTextColor,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    _listRecent.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              'Chưa có hoạt động nào',
                              style: AppStyles.text400(fontsize: 12.sp),
                            ),
                          )
                        : ListView.builder(
                            physics: const ScrollPhysics(
                                parent: NeverScrollableScrollPhysics()),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: _listRecent.length,
                            itemBuilder: (context, index) {
                              var item = _listRecent[index];
                              bool isComplete =
                                  item!.isArrived == true || item.status == 5;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                        () => item.isBooking
                                            ? BookingDetailv2(
                                                bookingId: item.id,
                                              )
                                            : isComplete
                                                ? ServiceActivityDetail(
                                                    orderServicesId: item.id,
                                                  )
                                                : OnGoingService(
                                                    servicesId: item.id,
                                                  ),
                                        transition: Transition.downToUp);
                                  },
                                  child: ActivityChip.haveTotal(
                                    carInfo:
                                        '${item.car!.carBrand} ${item.car!.carModel} ${item.car!.carLisenceNo}',
                                    date: item.date.toString(),
                                    code: item.code != null
                                        ? item.code.toString()
                                        : "##########",
                                    daysLeft: item.daysLeft,
                                    isBooking: item.isBooking,
                                    item: item,
                                    total: item.total,
                                  ),
                                ),
                              );
                            },
                          ),
                  ]),
                ),
              ),
      ),
    );
  }
}

class Status {
  final int id;
  final String text;

  Status(this.id, this.text);
}

class ActivityChip extends StatefulWidget {
  final String carInfo;
  final String date;
  final String code;
  final int? daysLeft;
  final bool isBooking;
  final double? total;
  final ActivityResponseModel item;
  const ActivityChip({
    super.key,
    required this.carInfo,
    required this.date,
    required this.daysLeft,
    required this.code,
    required this.isBooking,
    required this.item,
    this.total,
  });

  const ActivityChip.haveTotal({
    super.key,
    required this.carInfo,
    required this.date,
    required this.daysLeft,
    required this.code,
    required this.isBooking,
    required this.item,
    this.total,
  });

  @override
  State<ActivityChip> createState() => _ActivityChipState();
}

class _ActivityChipState extends State<ActivityChip> {
  List<Status> statuses = [
    Status(0, "Đang chờ nhân viên"),
    Status(1, "Đang kiểm tra"),
    Status(2, "Xác nhận & thanh toán"),
    Status(3, "Đang thực hiện"),
    Status(4, "Đợi lấy xe"),
    Status(5, "Hoàn thành"),
    Status(-1, "Đã hủy"),
  ];

  _getStatus(int id) {
    return statuses.where((element) => element.id == id).first.text;
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    bool isComplete = item.isActive == true &&
        ((item.isBooking == true && item.isArrived == true) ||
            (item.isBooking == false && item.status == 5));
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: ListTile(
        leading: Image.asset(
          widget.isBooking
              ? "assets/image/icon-logo/calendar-history-icon.png"
              : "assets/image/icon-logo/service-logo.png",
          fit: BoxFit.contain,
          height: 40.sp,
          width: 50.sp,
        ),
        title: !isComplete
            ? Text(
                isComplete
                    ? "Hoàn Thành"
                    : item.isBooking
                        ? item.isActive == false
                            ? "Đã hủy"
                            : item.daysLeft == 0
                                ? "Hôm nay"
                                : "Còn lại ${widget.daysLeft} ngày"
                        : _getStatus(item.status as int),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: isComplete
                      ? AppColors.greenTextColor
                      : item.isActive == false
                          ? AppColors.errorIcon
                          : AppColors.blueTextColor,
                ),
              )
            : null,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: !isComplete,
              child: SizedBox(
                height: 5.h,
              ),
            ),
            RichText(
              text: TextSpan(
                  text: !widget.isBooking ? "Dịch vụ cho " : "Đặt lịch cho ",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackTextColor,
                  ),
                  children: [
                    TextSpan(
                      text: widget.item.car!.carLisenceNo.toString(),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                  ]),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 5.h,
            ),
            if (widget.isBooking)
              Text(
                formatDate(widget.date, false),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightTextColor,
                ),
                textAlign: TextAlign.start,
              ),
            !widget.isBooking
                ? Text(
                    widget.code,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightTextColor,
                    ),
                  )
                : Container(),
          ],
        ),
        trailing: widget.total != null
            ? Text(
                formatCurrency(widget.total),
                style: AppStyles.text400(fontsize: 12.sp),
              )
            : (widget.isBooking && widget.daysLeft == 0) ||
                    (!widget.isBooking && item.status == 4)
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        (!item.isBooking && item.status == 4)
                            ? Get.to(() => CheckOutQRCodePage(
                                  id: item.id,
                                ))
                            : Get.to(() => QRCodePage(
                                  bookingId: item.id,
                                ));
                      },
                      child: Icon(Icons.qr_code_scanner,
                          color: AppColors.blueTextColor, size: 30.w),
                    ),
                  )
                : null,
      ),
    );
  }
}
