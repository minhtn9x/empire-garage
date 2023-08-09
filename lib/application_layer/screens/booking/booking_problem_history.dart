import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../models/response/car.dart';
import '../../widgets/loading.dart';
import 'booking_history_tab.dart';
import 'booking_problem_tab.dart';

class BookingProblemHistory extends StatefulWidget {
  final CarProfile? car;
  final Function(List<UnresolvedProblem>) onChooseUnresolvedProblemsCallBack;
  const BookingProblemHistory(
      {super.key,
      required this.car,
      required this.onChooseUnresolvedProblemsCallBack});

  @override
  State<BookingProblemHistory> createState() => _BookingProblemHistoryState();
}

class _BookingProblemHistoryState extends State<BookingProblemHistory> {
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
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: AppColors.grey400,
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
              backgroundColor: AppColors.white100,
              centerTitle: true,
              title: Text(_carProfile!.carLicenseNo.toString(),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  )),
            ),
            body: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        toolbarHeight: 20.h,
                        shadowColor: Colors.transparent,
                        bottom: TabBar(
                            labelColor: AppColors.blue600,
                            unselectedLabelColor: AppColors.lightTextColor,
                            indicatorColor: AppColors.blue600,
                            tabs: [
                              Tab(
                                child: Text(
                                  "Vấn đề chưa sửa",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "Lịch sử sửa chữa",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                  body: TabBarView(children: <Widget>[
                    //Tab Bar View 1
                    BookingProblemTab(
                      car: _carProfile,
                      onChooseUnresolvedProblemsCallBack:
                          widget.onChooseUnresolvedProblemsCallBack,
                    ),
                    //Tab View 2
                    BookingHistoryTab(
                      car: _carProfile,
                    ),
                  ]),
                )),
          );
  }
}
