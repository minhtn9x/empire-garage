import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../models/response/groupservices.dart';
import '../../services/group_services/group_services.dart';
import '../screens/search/filter_group_service.dart';

class HomePageServiceIconButton extends StatefulWidget {
  const HomePageServiceIconButton({Key? key}) : super(key: key);

  @override
  State<HomePageServiceIconButton> createState() =>
      _HomePageServiceIconButtonState();
}

class _HomePageServiceIconButtonState extends State<HomePageServiceIconButton> {
  bool isService = true;

  List<GroupServicesResponseModel>? _listGroupServices;
  GroupServicesResponseModel? _filterGroupServices;

  _getListGroupServices() async {
    _listGroupServices = await GroupServices().fetchGroupServices(isService);
  }

  @override
  void initState() {
    _getListGroupServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView(
        // This next line does the trick.
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: GestureDetector(
                  onTap: () {
                    _filterGroupServices = _listGroupServices
                        ?.where((item) => item.name!.contains('Cứu hộ'))
                        .first;
                    if (_filterGroupServices != null) {
                      Get.to(() => FilterGroupService(
                            filterGroupServices: _filterGroupServices
                                as GroupServicesResponseModel,
                          ));
                    }
                  },
                  child: Image.asset(
                    "assets/image/icon-logo/homeservice-logo-rescue.png",
                    height: 50.h,
                    width: 50.w,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Cứu hộ',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackTextColor,
                    fontFamily: 'Roboto'),
              ),
            ]),
          ),
          SizedBox(
            width: 40.w,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: GestureDetector(
                onTap: () {
                  _filterGroupServices = _listGroupServices
                      ?.where((item) => item.name!.contains('Chăm sóc'))
                      .first;
                  if (_filterGroupServices != null) {
                    Get.to(() => FilterGroupService(
                          filterGroupServices: _filterGroupServices
                              as GroupServicesResponseModel,
                        ));
                  }
                },
                child: InkWell(
                    child: Image.asset(
                  "assets/image/icon-logo/homeservice-logo-care.png",
                  height: 50.h,
                  width: 50.w,
                )),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Chăm sóc',
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                  fontFamily: 'Roboto'),
            ),
          ]),
          SizedBox(
            width: 40.w,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: GestureDetector(
                onTap: () {
                  _filterGroupServices = _listGroupServices
                      ?.where((item) => item.name!.contains('Sửa chữa'))
                      .first;
                  if (_filterGroupServices != null) {
                    Get.to(() => FilterGroupService(
                          filterGroupServices: _filterGroupServices
                              as GroupServicesResponseModel,
                        ));
                  }
                },
                child: InkWell(
                    child: Image.asset(
                  "assets/image/icon-logo/homeservice-logo-fixing.png",
                  height: 50.h,
                  width: 50.w,
                )),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Sửa chữa',
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                  fontFamily: 'Roboto'),
            ),
          ]),
          SizedBox(
            width: 40.w,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: GestureDetector(
                onTap: () {
                  _filterGroupServices = _listGroupServices
                      ?.where((item) => item.name!.contains('Bảo dưỡng'))
                      .first;
                  if (_filterGroupServices != null) {
                    Get.to(() => FilterGroupService(
                          filterGroupServices: _filterGroupServices
                              as GroupServicesResponseModel,
                        ));
                  }
                },
                child: InkWell(
                    child: Image.asset(
                  "assets/image/icon-logo/homeservice-logo-maintanace.png",
                  height: 50.h,
                  width: 50.w,
                )),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Bảo dưỡng',
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                  fontFamily: 'Roboto'),
            ),
          ]),
          SizedBox(
            width: 40.w,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: GestureDetector(
                onTap: () {
                  _filterGroupServices = _listGroupServices
                      ?.where((item) => item.name!.contains('Phụ tùng'))
                      .first;
                  if (_filterGroupServices != null) {
                    Get.to(() => FilterGroupService(
                        filterGroupServices:
                            _filterGroupServices as GroupServicesResponseModel,
                      ));
                  }
                },
                child: InkWell(
                    child: Image.asset(
                  "assets/image/icon-logo/homeservice-logo-accessary.png",
                  height: 50.h,
                  width: 50.w,
                )),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Phụ tùng',
              style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                  fontFamily: 'Roboto'),
            ),
          ]),
        ],
      ),
    );
  }
}
