import 'package:easy_stepper/easy_stepper.dart';
import 'package:empiregarage_mobile/models/response/orderservices.dart';
import 'package:empiregarage_mobile/models/response/user.dart';
import 'package:empiregarage_mobile/services/user_service/user_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../common/colors.dart';

class OnGoingServiceProgressBar extends StatefulWidget {
  final int activeStep;
  final OrderServicesResponseModel order;
  final Function(int) callBack;

  const OnGoingServiceProgressBar(
      {super.key,
      required this.activeStep,
      required this.order,
      required this.callBack});

  @override
  State<OnGoingServiceProgressBar> createState() =>
      _OnGoingServiceProgressBarState();
}

class _OnGoingServiceProgressBarState extends State<OnGoingServiceProgressBar> {
  int _activeStep = 0;
  UserResponseModel? _expert;
  String _backdrop = "assets/image/service-picture/ongoingservicepic.png";

  @override
  void initState() {
    _getBackdrop();
    _getExpert();
    setState(() {
      _activeStep = widget.activeStep;
    });
    super.initState();
  }

  void _getBackdrop() {
    String backdrop = "assets/image/service-picture/ongoingservicepic.png";
    switch (widget.order.status) {
      case 0:
        backdrop = "assets/image/service-picture/ongoingservicepic.png";
        break;
      case 1:
        backdrop = "assets/image/service-picture/diagnosing.png";
        break;
      case 2:
        backdrop = "assets/image/service-picture/paying.png";
        break;
      case 3:
        backdrop = "assets/image/service-picture/repairing.png";
        break;
      case 4:
        backdrop = "assets/image/service-picture/checking-out.png";
        break;
      default:
    }
    setState(() {
      _backdrop = backdrop;
    });
  }

  _onSelectTab(selectedTab) {
    if (widget.activeStep < selectedTab) return;
    widget.callBack(selectedTab);
  }

  _getExpert() async {
    if (widget.order.expert == null) return;
    var expert = await UserService().getUserById(widget.order.expert!.id);
    if (!mounted) return;
    setState(() {
      _expert = expert;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15.sp),
          child: Container(
            height: 170.sp,
            width: 200.sp,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(_backdrop), fit: BoxFit.fill)),
          ),
        ),
        SizedBox(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${widget.order.car.carLisenceNo} ',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextColor,
                  ),
                ),
                Text(
                  "\u2022 ${widget.order.order.user.fullname}",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 5.sp,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Phụ trách bởi :",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.lightTextColor,
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              _expert == null ? "Chưa có kỹ thuật viên" : _expert!.fullname,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackTextColor,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 21),
          width: 375.w,
          height: 90.h,
          child: EasyStepper(
            activeStep: _activeStep,
            lineType: LineType.normal,
            lineSpace: 0,
            lineLength: 20,
            lineDotRadius: 2,
            lineColor: AppColors.blue100,
            stepShape: StepShape.circle,
            stepRadius: 18.sp,
            finishedStepBorderColor: Colors.transparent,
            finishedStepTextColor: const Color(0xff1cbe8e),
            finishedStepBackgroundColor: const Color(0xff1cbe8e),
            unreachedStepBackgroundColor: AppColors.blue100,
            unreachedStepTextColor: AppColors.blue100,
            unreachedStepIconColor: Colors.white,
            unreachedStepBorderColor: Colors.transparent,
            activeStepIconColor: Colors.transparent,
            activeStepTextColor: AppColors.blueTextColor,
            activeStepBackgroundColor: AppColors.blueTextColor,
            steps: [
              EasyStep(
                finishIcon: Icon(
                  FontAwesomeIcons.check,
                  color: Colors.green.shade500,
                ),
                icon: const Icon(
                  FontAwesomeIcons.one,
                ),
                title: 'Đã Check-in',
              ),
              EasyStep(
                finishIcon: Icon(
                  FontAwesomeIcons.check,
                  color: Colors.green.shade500,
                ),
                icon: const Icon(
                  FontAwesomeIcons.two,
                ),
                title: _activeStep > 1 ? 'Đã phân tích' : 'Đang phân tích',
              ),
              EasyStep(
                finishIcon: Icon(
                  FontAwesomeIcons.check,
                  color: Colors.green.shade500,
                ),
                icon: const Icon(
                  FontAwesomeIcons.three,
                ),
                title: 'Xác nhận & thanh toán',
              ),
              EasyStep(
                finishIcon: Icon(
                  FontAwesomeIcons.check,
                  color: Colors.green.shade500,
                ),
                icon: const Icon(
                  FontAwesomeIcons.four,
                ),
                title: _activeStep > 3 ? 'Đã hoàn tất' : 'Đang thực hiện',
              ),
              EasyStep(
                finishIcon: Icon(
                  FontAwesomeIcons.check,
                  color: Colors.green.shade500,
                ),
                icon: const Icon(
                  FontAwesomeIcons.five,
                ),
                title: _activeStep > 4 ? 'Đã lấy xe' : 'Đợi lấy xe',
              ),
            ],
            // onStepReached: (index) => _onSelectTab(index),
          ),
        ),
      ],
    );
  }
}
