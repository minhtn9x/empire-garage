import 'package:empiregarage_mobile/application_layer/screens/booking/booking_problem_seedetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/style.dart';
import '../../../models/response/car.dart';
import '../../widgets/loading.dart';

class BookingProblemTab extends StatefulWidget {
  final CarProfile? car;
  final Function(List<UnresolvedProblem>) onChooseUnresolvedProblemsCallBack;
  const BookingProblemTab(
      {super.key,
      required this.car,
      required this.onChooseUnresolvedProblemsCallBack});

  @override
  State<BookingProblemTab> createState() => _BookingProblemTabState();
}

class _BookingProblemTabState extends State<BookingProblemTab> {
  bool _loading = true;
  CarProfile? _carProfile;
  final List<UnresolvedProblem> _selectedUnresolvedProblems = [];

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
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "Vấn đề chưa sửa chữa",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
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
                    "Vui lòng chọn vấn đề bạn muốn để đặt lịch sửa chữa",
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
                    itemCount: _carProfile!.unresolvedProblems.length,
                    itemBuilder: (context, index) {
                      var item = _carProfile!.unresolvedProblems[index];
                      return Padding(
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16))),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (_selectedUnresolvedProblems
                                        .contains(item)) {
                                      _selectedUnresolvedProblems.remove(item);
                                    } else {
                                      _selectedUnresolvedProblems.add(item);
                                    }
                                  });
                                },
                                child: ListTile(
                                  title: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.blackTextColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Icon(
                                    _selectedUnresolvedProblems.contains(item)
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked,
                                    color: AppColors.buttonColor,
                                  ),
                                ),
                              ),
                              const Divider(),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => const BookingProblemSeeDetail(),
                                      transition: Transition.downToUp);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10.sp),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Xem chi tiết',
                                        style: AppStyles.header600(
                                            fontsize: 14.sp,
                                            color: AppColors.blue600),
                                      ),
                                      const Icon(
                                        Icons.navigate_next_outlined,
                                        color: AppColors.blue600,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 36.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onChooseUnresolvedProblemsCallBack(
                                _selectedUnresolvedProblems);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            fixedSize: Size.fromHeight(50.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: Text(
                            'Đặt lịch',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
