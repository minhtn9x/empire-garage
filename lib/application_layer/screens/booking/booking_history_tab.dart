import 'package:empiregarage_mobile/application_layer/screens/activities/service_activity_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../models/response/car.dart';
import '../../widgets/loading.dart';

class BookingHistoryTab extends StatefulWidget {
  final CarProfile? car;
  const BookingHistoryTab({super.key, required this.car});

  @override
  State<BookingHistoryTab> createState() => _BookingHistoryTabState();
}

class _BookingHistoryTabState extends State<BookingHistoryTab> {
  bool _loading = true;
  CarProfile? _carProfile;

  _getCarProfile() async {
    var carProfile = widget.car;
    if (carProfile == null) {
      setState(() {
        _loading = true;
      });
    } else {
      setState(() {
        _carProfile = carProfile;
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    _getCarProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading == true
        ? const Loading()
        : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Lịch sử sửa chữa",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "Dưới đây là danh sách hóa đơn của phương tiện",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightTextColor,
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _carProfile!.orderServices.length,
                    itemBuilder: (context, index) {
                      _carProfile!.orderServices.sort((a, b) =>
                          b.order!.updatedAt.compareTo(a.order!.updatedAt));
                      return InkWell(
                        onTap: () {
                          Get.to(() => ServiceActivityDetail(orderServicesId: _carProfile!.orderServices[index].id,));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1.h,
                                    blurRadius: 1.2,
                                    offset: Offset(0, 4.h),
                                  )
                                ],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16))),
                            child: ListTile(
                              title: Text(
                                _carProfile!
                                    .orderServices[index].order!.updatedAt
                                    .substring(0, 16)
                                    .replaceAll('T', " "),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackTextColor,
                                ),
                              ),
                              subtitle: Text(
                                _carProfile!.orderServices[index].order!
                                            .transaction !=
                                        null
                                    ? "${_carProfile!.orderServices[index].order!.transaction!.total}đ"
                                    : "Chưa thanh toán",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.lightTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
  }
}
