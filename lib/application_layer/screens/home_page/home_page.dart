import 'package:empiregarage_mobile/application_layer/on_going_service/on_going_service.dart';
import 'package:empiregarage_mobile/application_layer/screens/activities/activities.dart';
import 'package:empiregarage_mobile/application_layer/screens/booking/booking_detail_v2.dart';
import 'package:empiregarage_mobile/application_layer/screens/notification/notification.dart';
import 'package:empiregarage_mobile/application_layer/screens/search/search.dart';
import 'package:empiregarage_mobile/application_layer/screens/services/service_details.dart';
import 'package:empiregarage_mobile/application_layer/widgets/homepage_famous_service.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/helper/notification_helper.dart';
import 'package:empiregarage_mobile/models/response/activity.dart';
import 'package:empiregarage_mobile/services/activity_services/activity_service.dart';
import 'package:empiregarage_mobile/services/item_service/item_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../common/colors.dart';
import '../../../common/style.dart';
import '../../../helper/common_helper.dart';
import '../../../models/response/item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ItemResponseModel>? _listItem;
  List<ItemResponseModel>? _filteredItem;

  late List<ActivityResponseModel?> _listOngoingActivity;
  bool _loadingActivity = false;
  bool _loadingService = false;

  bool isService = true;

  int _notificationCount = 0;

  _fetchData() async {
    //count notification
    await renderNotificationsCount();
    await renderServices();
    await renderOnGoingActivity();
  }

  Future<void> renderNotificationsCount() async {
    _notificationCount = await countNotification();
  }

  Future<void> renderServices() async {
    _listItem = await ItemService().fetchListItem(true);
    _filteredItem = _listItem;
    if (!mounted) return;
    setState(() {
      _loadingService = true;
    });
  }

  Future<void> renderOnGoingActivity() async {
    var userId = await getUserId();
    if (userId == null) throw Exception("NOT_FOUND_USER");
    var listActivity = await ActivityService().fetchOnGoingActivity(userId);
    _listOngoingActivity = listActivity
        .where((element) =>
            element != null &&
            (element.isOnGoing == true ||
                element.isMaintenanceSchedule == true))
        .where((element) => element!.status == null || element.status != 5)
        .toList();
    if (!mounted) return;
    setState(() {
      _loadingActivity = true;
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future refresh() {
    return _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: RefreshIndicator(
        onRefresh: refresh,
        color: AppColors.blue600,
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: 160.h,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(
                          "assets/image/app-logo/homepage-background.png"),
                      fit: BoxFit.cover,
                    ),
                    color: AppColors.welcomeScreenBackGround,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.r),
                      bottomRight: Radius.circular(0.r),
                    )),
                child: Column(
                  children: <Widget>[
                    SafeArea(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 40.h,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 24),
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: <Widget>[
                                Image.asset(
                                  "assets/image/app-logo/homepage-icon.png",
                                  width: 135.w,
                                  height: 50.h,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        shape: BoxShape.rectangle,
                                        boxShadow: const [
                                          BoxShadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 0.5,
                                            color: AppColors.blue600,
                                          )
                                        ]),
                                    child: IconButton(
                                        onPressed: () async {
                                          var userId = await getUserId();
                                          if (userId == null) {
                                            throw Exception("Not found user");
                                          }
                                          Get.to(() => NotificationPage(
                                                userId: userId,
                                              ));
                                        },
                                        icon: Badge(
                                            backgroundColor:
                                                _notificationCount == 0
                                                    ? Colors.transparent
                                                    : AppColors.errorIcon,
                                            label: _notificationCount > 0
                                                ? Text(
                                                    _notificationCount
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : null,
                                            child: const ImageIcon(
                                              AssetImage(
                                                  "assets/image/icon-logo/homepage-notification.png"),
                                              size: 20,
                                              color: AppColors.whiteButtonColor,
                                            ))),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 140.h,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: 335.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 5,
                          color: AppColors.unselectedBtn,
                        )
                      ]),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 311.w,
                      height: 26.h,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            Get.to(() => SearchPage(
                                  searchString: value,
                                ));
                          }
                        },
                        //style: searchTextStyle,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightTextColor,
                          ),
                          hintText: 'Tìm kiếm...',
                          prefixIcon: const Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            size: 20,
                            color: AppColors.grey400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 180.h,
                  ),
                  !_loadingActivity
                      ? Padding(
                          padding: EdgeInsets.only(top: 10.sp),
                          child: const Loading(),
                        )
                      : Visibility(
                          visible: _listOngoingActivity.isNotEmpty,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20.w, top: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      "Đang hoạt động",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackTextColor,
                                          fontFamily: 'Roboto'),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _listOngoingActivity.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    var item = _listOngoingActivity[index];
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16.h),
                                      child: InkWell(
                                        onTap: () async {
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
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1.h,
                                                  blurRadius: 1.2,
                                                  offset: Offset(0, 4.h),
                                                )
                                              ],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(17))),
                                          child: item!.isMaintenanceSchedule ==
                                                  true
                                              ? SizedBox(
                                                  height: 75.h,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        child: Image.asset(
                                                          'assets/image/icon-logo/homeservice-logo-care.png',
                                                          fit: BoxFit.contain,
                                                          height: 40.sp,
                                                          width: 50.sp,
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
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
                                                            style: AppStyles
                                                                .text400(
                                                                    fontsize:
                                                                        12.sp),
                                                          ),
                                                          SizedBox(
                                                            height: 5.h,
                                                          ),
                                                          Text(
                                                            formatDate(
                                                                item.date
                                                                    .toString(),
                                                                false),
                                                            style: AppStyles
                                                                .text400(
                                                                    fontsize:
                                                                        10.sp),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 75.h,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    child: ActivityChip(
                                                      carInfo:
                                                          '${item.car!.carBrand} ${item.car!.carModel} ${item.car!.carLisenceNo}',
                                                      date:
                                                          item.date.toString(),
                                                      daysLeft: item.daysLeft,
                                                      isBooking: item.isBooking,
                                                      item: item,
                                                      code: item.code != null
                                                          ? item.code.toString()
                                                          : "#########",
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                  // Column(
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.only(left: 24.w, top: 24),
                  //       child: Row(
                  //         children: [
                  //           Text(
                  //             "Chờ bảo trì",
                  //             style: TextStyle(
                  //                 fontSize: 14.sp,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: AppColors.blackTextColor,
                  //                 fontFamily: 'Roboto'),
                  //           ),
                  //           ListView.builder(itemBuilder: itemBuilder)
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Dịch vụ phổ biến",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackTextColor,
                              fontFamily: 'Roboto'),
                        ),
                        const Spacer(),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Xem tất cả",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white100,
                                  fontFamily: 'Roboto'),
                            ))
                      ],
                    ),
                  ),
                  !_loadingService
                      ? const Loading()
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                            height: 260.h,
                            child: ListView.builder(
                              reverse: false,
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _filteredItem!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => ServiceDetails(
                                          itemId: _filteredItem![index].id));
                                    },
                                    child: HomepageFamousService(
                                      backgroundImage:
                                          _filteredItem![index].photo,
                                      title: _filteredItem![index].name,
                                      price:
                                          _filteredItem![index].prices!.isNotEmpty
                                              ? NumberFormat.currency(
                                                      decimalDigits: 0,
                                                      locale: 'vi_VN',
                                                      symbol: "đ")
                                                  .format(_filteredItem![index]
                                                      .prices!
                                                      .first
                                                      .price)
                                                  .toString()
                                              : "Liên hệ",
                                      usageCount: '182',
                                      rating: '4.4',
                                      tag: _filteredItem![index].category != null
                                          ? _filteredItem![index].category!.name
                                          : "Dịch vụ",
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
