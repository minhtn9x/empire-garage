import 'package:empiregarage_mobile/application_layer/on_going_service/on_going_service.dart';
import 'package:empiregarage_mobile/application_layer/screens/activities/activities.dart';
import 'package:empiregarage_mobile/application_layer/screens/activities/service_activity_detail.dart';
import 'package:empiregarage_mobile/application_layer/screens/booking/booking_detail_v2.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/services/activity_services/activity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../models/response/activity.dart';

class ActivityHistory extends StatefulWidget {
  const ActivityHistory({Key? key}) : super(key: key);

  @override
  State<ActivityHistory> createState() => _ActivityHistoryState();
}

class _ActivityHistoryState extends State<ActivityHistory> {
  bool _loading = true;
  List<ActivityResponseModel?> _listActivity = [];
  List<ActivityResponseModel?> _listFiltered = [];

  _fetchData() async {
    var userId = await getUserId();
    if (userId == null) {
      return;
    }
    var listActivity = await ActivityService().fetchActivity(userId);
    if (!mounted) return;
    setState(() {
      _listActivity = listActivity
          .where((element) =>
              element != null &&
              (element.isOnGoing == false ||
                  ![0, 1, 2, 3, 4].contains(element.status)))
          .toList();
      _listFiltered =
          _listActivity.where((element) => element!.isBooking == true).toList();
      _loading = false;
    });
  }

  _onSelectedFilter(List<String> selectedFilters) {
    // 'Đặt lịch',
    // 'Dịch vụ',
    // 'Đặt hàng',
    // 'Cứu hộ'
    if (selectedFilters.isEmpty) {
      setState(() {
        _listFiltered = _listActivity;
      });
    } else {
      for (var element in selectedFilters) {
        switch (element) {
          case 'Đặt lịch':
            setState(() {
              _listFiltered = _listActivity
                  .where((element) => element!.isBooking == true)
                  .toList();
            });
            break;
          case 'Dịch vụ':
            setState(() {
              _listFiltered = _listActivity
                  .where((element) =>
                      element!.isBooking == false &&
                      [5, -1].contains(element.status))
                  .toList();
            });
            break;
          default:
        }
      }
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future reload() {
    return _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
              backgroundColor: Colors.white,
              body: RefreshIndicator(
                onRefresh: reload,
                color: AppColors.blue600,
                child: ListView(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.sp),
                          child: Stack(
                              alignment: Alignment.centerLeft,
                              children: <Widget>[
                                Container(
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
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Lịch sử hoạt động",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackTextColor,
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 15.sp,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.sp),
                          child: ListFilter(
                            onSelectedFilter: _onSelectedFilter,
                          ),
                        ),
                        _loading ? const Loading() :Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.sp),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: _listFiltered.length,
                            itemBuilder: (context, index) {
                              var item = _listFiltered[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                      () => item.isBooking
                                          ? BookingDetailv2(
                                              bookingId: item.id,
                                            )
                                          : item.status == 5 || item.status == -1
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
                                      '${item!.car!.carBrand} ${item.car!.carModel} ${item.car!.carLisenceNo}',
                                  date: item.date.toString(),
                                  code: item.code != null
                                      ? item.code.toString()
                                      : "##########",
                                  daysLeft: item.daysLeft,
                                  isBooking: item.isBooking,
                                  item: item,
                                  total: item.total,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        )
                      ],
                    ),
                  ),
                ]),
              ),
            ),
    );
  }
}

class ListFilter extends StatefulWidget {
  final Function(List<String>) onSelectedFilter;
  const ListFilter({super.key, required this.onSelectedFilter});

  @override
  State<ListFilter> createState() => _ListFilterState();
}

class _ListFilterState extends State<ListFilter> {
  final List<String> _filterOptions = [
    'Đặt lịch',
    'Dịch vụ',
  ];

  final List<String> _selectedFilters = ['Đặt lịch'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _filterOptions.map((option) {
        return FilterChip(
          label: Text(
            option,
            style: AppStyles.header600(
                color: _selectedFilters.isNotEmpty &&
                        _selectedFilters.first.compareTo(option) == 0
                    ? Colors.white
                    : AppColors.blueTextColor,
                fontsize: 12.sp),
          ),
          selectedColor: AppColors.blue600,
          showCheckmark: false,
          backgroundColor: AppColors.blue100,
          selected: _selectedFilters.contains(option),
          onSelected: (selected) {
            setState(() {
              _selectedFilters.clear();
              if (selected) {
                _selectedFilters.add(option);
              } else {
                _selectedFilters.remove(option);
              }
            });
            widget.onSelectedFilter(_selectedFilters);
          },
        );
      }).toList(),
    );
  }
}
