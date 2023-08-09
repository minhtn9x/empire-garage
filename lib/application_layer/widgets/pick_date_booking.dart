import 'package:empiregarage_mobile/application_layer/screens/booking/booking_info.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';
import '../../../services/booking_service/booking_service.dart';

class PickDateBooking extends StatefulWidget {
  const PickDateBooking({Key? key}) : super(key: key);

  @override
  State<PickDateBooking> createState() => _PickDateBookingState();
}

class _PickDateBookingState extends State<PickDateBooking> {
  final DatePickerController _controller = DatePickerController();

  DateTime _dateCanBook = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _list = [];
  bool _loading = false;

  _getDateCanBook() async {
    var workload = await BookingService().getMinWorkload();
    DateTime dateCanBook = workload!.intendedFinishTime;
    if (dateCanBook.month == DateTime.now().month || dateCanBook.year == DateTime.now().year) {
      int inactiveDates = dateCanBook.day - DateTime.now().day;
      List<DateTime> list = [];
      if (inactiveDates > 0) {
        for (int i = 0; i < inactiveDates; i++) {
          list.add(DateTime.now().add(Duration(days: i)));
        }
        setState(() {
          _dateCanBook = dateCanBook;
          _loading = true;
          _list = list;
          _selectedDate = list[list.length - 1].add(const Duration(days: 1));
        });
      }
      if (inactiveDates <= 0) {
        setState(() {
          _selectedDate = dateCanBook;
          _loading = true;
        });
      }
    }
    if (dateCanBook.month > DateTime.now().month || dateCanBook.year > DateTime.now().year) {
      List<DateTime> list = [];
      list.add(DateTime.now());
      setState(() {
        _dateCanBook = dateCanBook;
        _loading = true;
        _list = list;
        _selectedDate = list[list.length - 1].add(const Duration(days: 1));
      });
    }
    return _dateCanBook;
  }

  @override
  void initState() {
    _getDateCanBook();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Đặt lịch mới",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackTextColor,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: Text(
                textAlign: TextAlign.left,
                "Vui lòng chọn lịch có sẵn, chỉ đặt được lịch trong tuần này",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightTextColor,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  textAlign: TextAlign.left,
                  "Chọn ngày",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.blackTextColor,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            _loading
                ? DatePicker(
                    DateTime.now(),
                    inactiveDates: _list,
                    dayTextStyle: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    locale: "vi_VN",
                    width: 60.w,
                    height: 80.h,
                    controller: _controller,
                    initialSelectedDate: _selectedDate,
                    selectionColor: Colors.black,
                    selectedTextColor: Colors.white,
                    daysCount: 7,
                    onDateChange: (date) {
                      // New date selected
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  )
                : const Loading(),
            SizedBox(
              height: 40.h,
            ),
            _loading
                ? Container(
                    height: 100,
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: AppColors.grey100, width: 2))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.off(
                                () => BookingInfo(
                                  selectedDate: _selectedDate,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor,
                              fixedSize: Size.fromHeight(55.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Tiếp tục',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : const Loading(),
          ],
        ),
      ),
    );
  }
}
