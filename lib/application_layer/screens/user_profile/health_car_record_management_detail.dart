import 'package:empiregarage_mobile/application_layer/screens/activities/service_activity_detail.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/application_layer/widgets/pick_date_booking.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/models/response/car.dart';
import 'package:empiregarage_mobile/services/car_service/car_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';

class HealthCarRecordManagementDetail extends StatefulWidget {
  final int carId;
  const HealthCarRecordManagementDetail({super.key, required this.carId});

  @override
  State<HealthCarRecordManagementDetail> createState() =>
      _HealthCarRecordManagementDetailState();
}

class _HealthCarRecordManagementDetailState
    extends State<HealthCarRecordManagementDetail> {
  CarProfile? _car;
  bool _loading = true;

  @override
  void initState() {
    _getCarProfile(widget.carId);
    super.initState();
  }

  _getCarProfile(int carId) async {
    var car = await CarService().getCarProfle(carId);
    if (car != null) {
      car.healthCarRecords.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );
    }
    setState(() {
      _car = car;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _loading ? 0 : _car!.healthCarRecords.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 60.sp,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Container(
              height: 42,
              width: 42,
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
          leadingWidth: 84.sp,
          centerTitle: true,
          title: _loading
              ? const Loading()
              : Text(_car!.carLicenseNo,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Colors.black,
                  )),
          bottom: _loading
              ? null
              : TabBar(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  unselectedLabelColor: AppColors.blueTextColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: true,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: AppColors.blueTextColor),
                  tabs: _car!.healthCarRecords
                      .map((e) => SizedBox(
                            height: 30.sp,
                            width: 50.sp,
                            child: Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                    '${e.createdAt.day}/${e.createdAt.month}'),
                              ),
                            ),
                          ))
                      .toList(),
                ),
        ),
        body: _loading
            ? const Loading()
            : TabBarView(
                children: _car!.healthCarRecords
                    .map(
                      (record) => SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 15.h,
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "Ghi chú từ kỹ thuật viên",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackTextColor,
                                  ),
                                ),
                                SizedBox(height: 10.sp),
                                Text(
                                  record.symptom,
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.blackTextColor,
                                  ),
                                ),
                                SizedBox(height: 10.sp),
                                const Divider(thickness: 1),
                                SizedBox(height: 10.sp),
                                Text(
                                  "Các vấn đề được tìm thấy",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackTextColor,
                                  ),
                                ),
                                SizedBox(height: 5.sp),
                                Text(
                                  "Danh sách sau bao gồm những dịch vụ gợi ý",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.lightTextColor,
                                  ),
                                ),
                                SizedBox(height: 15.sp),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: record.problems.length,
                                    itemBuilder: (context, index) {
                                      var hcrproblem = record.problems[index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              //TODO
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  hcrproblem.problem.name,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors
                                                        .blackTextColor,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color:
                                                      AppColors.blackTextColor,
                                                  size: 12.sp,
                                                )
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                hcrproblem.problem.items.length,
                                            itemBuilder: (context, index) {
                                              var item = hcrproblem
                                                  .problem.items[index];
                                              return Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5.sp),
                                                child: Text(
                                                  item.name.toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.grey500,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(height: 5.sp),
                                        ],
                                      );
                                    }),
                                record.orderServiceId != null
                                    ? Column(
                                        children: [
                                          SizedBox(height: 10.sp),
                                          InkWell(
                                            onTap: () {
                                              Get.to(
                                                  () => ServiceActivityDetail(
                                                        orderServicesId: record
                                                            .orderServiceId!,
                                                      ));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Xem chi tiết hóa đơn",
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.blue600,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color:
                                                      AppColors.blueTextColor,
                                                  size: 12.sp,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                // SizedBox(height: 5.sp),
                                // const Divider(thickness: 1),
                                // SizedBox(height: 10.sp),
                                // Text(
                                //   "Các vấn đề chưa sửa chữa",
                                //   style: TextStyle(
                                //     fontFamily: 'Roboto',
                                //     fontSize: 12.sp,
                                //     fontWeight: FontWeight.w600,
                                //     color: AppColors.blackTextColor,
                                //   ),
                                // ),
                                // SizedBox(height: 5.sp),
                                // Text(
                                //   "Danh sách sau bao gồm các dịch vụ gợi ý",
                                //   style: TextStyle(
                                //     fontFamily: 'Roboto',
                                //     fontSize: 10.sp,
                                //     fontWeight: FontWeight.w400,
                                //     color: AppColors.lightTextColor,
                                //   ),
                                // ),
                                // SizedBox(height: 15.sp),
                                // ListView.builder(
                                //   shrinkWrap: true,
                                //   itemCount: record.problems.where((element) => _car!.unresolvedProblems.any((e) => e.id == element.problem.id)).length,
                                //   itemBuilder: (context, index) {
                                //     var problem = record.problems.where((element) => _car!.unresolvedProblems.any((e) => e.id == element.problem.id)).toList()[index];
                                //     return Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //           Text(
                                //             problem.problem.name,
                                //             style: TextStyle(
                                //               fontFamily: 'Roboto',
                                //               fontSize: 12.sp,
                                //               fontWeight: FontWeight.w600,
                                //               color: AppColors.blackTextColor,
                                //             ),
                                //           ),
                                //           ListView.builder(
                                //             shrinkWrap: true,
                                //             itemCount:
                                //                 problem.problem.items.length,
                                //             itemBuilder: (context, index) {
                                //               var item =
                                //                   problem.problem.items[index];
                                //               return Text(item.name);
                                //             },
                                //           )
                                //         ]);
                                //   },
                                // ),
                                SizedBox(height: 15.sp),
                              ]),
                        ),
                      ),
                    )
                    .toList(),
              ),
        bottomNavigationBar: _loading
            ? null
            : DecoratedBox(
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
                      'Đặt lịch sửa chữa',
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
    );
  }
}
