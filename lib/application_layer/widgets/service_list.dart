import 'package:empiregarage_mobile/application_layer/screens/services/service_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';

class ServiceList extends StatelessWidget {
  const ServiceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          GestureDetector(
            child: Column(
              children: [
                LimitedBox(
                  maxHeight: 132.h,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                "assets/image/service-picture/service-picture1.png",
                                width: 140.w,
                                height: 90.h,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 130.w,
                              height: 80.h,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Fixing Car',
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackTextColor,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '250k',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blueTextColor,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              Get.to(() => const ServiceDetails(
                    itemId: 1,
                  ));
            },
          ),
          GestureDetector(
            child: Column(
              children: [
                LimitedBox(
                  maxHeight: 132.h,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                "assets/image/service-picture/service-picture1.png",
                                width: 140.w,
                                height: 90.h,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 130.w,
                              height: 80.h,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Fixing Car',
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackTextColor,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '250k',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blueTextColor,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              Get.to(() => const ServiceDetails(
                    itemId: 1,
                  ));
            },
          ),
          SizedBox(
            height: 16.h,
          ),
          GestureDetector(
            child: Column(
              children: [
                LimitedBox(
                  maxHeight: 132.h,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                "assets/image/service-picture/service-picture1.png",
                                width: 140.w,
                                height: 90.h,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 130.w,
                              height: 80.h,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Fixing Car',
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackTextColor,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '250k',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blueTextColor,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              Get.to(() => const ServiceDetails(
                    itemId: 1,
                  ));
            },
          ),
          SizedBox(
            height: 16.h,
          ),
          GestureDetector(
            child: Column(
              children: [
                LimitedBox(
                  maxHeight: 132.h,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 20,
                        bottom: 20,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.asset(
                                "assets/image/service-picture/service-picture1.png",
                                width: 140.w,
                                height: 90.h,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              width: 130.w,
                              height: 80.h,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Fixing Car',
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackTextColor,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '250k',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blueTextColor,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {
              Get.to(() => const ServiceDetails(
                    itemId: 1,
                  ));
            },
          ),
        ],
      ),
    );
  }
}
