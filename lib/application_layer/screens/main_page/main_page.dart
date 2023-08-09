import 'package:empiregarage_mobile/application_layer/screens/orders/orders.dart';
import 'package:empiregarage_mobile/application_layer/screens/user_profile/health_car_record_management.dart';
import 'package:empiregarage_mobile/application_layer/screens/user_profile/user_profile_setting.dart';
import 'package:empiregarage_mobile/application_layer/widgets/pick_date_booking.dart';
import 'package:empiregarage_mobile/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../activities/activities.dart';
import '../home_page/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    const HomePage(),
    const Activities(),
    const Orders(),
    const UserProfileSettings(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomePage();
  int currentTab = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 50.h,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //left tab bar icon
              Expanded(
                child: MaterialButton(
                  minWidth: 50.w,
                  height: 60.h,
                  onPressed: () {
                    setState(() {
                      currentScreen = const HomePage();
                      currentTab = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ImageIcon(
                      //   const AssetImage(
                      //       "assets/image/icon-logo/mainpage-home.png"),
                      //   size: 20,
                      //   color: currentTab == 1
                      //       ? AppColors.buttonColor
                      //       : AppColors.grey400,
                      // ),
                      FaIcon(
                        FontAwesomeIcons.solidCompass,
                        size: 20,
                        color: currentTab == 1
                            ? AppColors.buttonColor
                            : AppColors.grey400,
                      ),
                      // Visibility(
                      //   visible: currentTab == 1,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 5),
                      //     child: Text(
                      //       "Trang chủ",
                      //       style: TextStyle(
                      //         fontFamily: 'Roboto',
                      //         fontSize: 7,
                      //         fontWeight: currentTab == 1
                      //             ? FontWeight.w600
                      //             : FontWeight.w400,
                      //         color: currentTab == 1
                      //             ? AppColors.buttonColor
                      //             : AppColors.grey400,
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  minWidth: 20.w,
                  onPressed: () {
                    setState(() {
                      currentScreen = const Activities();
                      currentTab = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ImageIcon(
                      //   const AssetImage(
                      //       "assets/image/icon-logo/mainpage-activity.png"),
                      //   size: 20,
                      //   color: currentTab == 2
                      //       ? AppColors.buttonColor
                      //       : AppColors.grey400,
                      // ),
                      FaIcon(
                        FontAwesomeIcons.listUl,
                        size: 20,
                        color: currentTab == 2
                            ? AppColors.buttonColor
                            : AppColors.grey400,
                      ),
                      // Visibility(
                      //   visible: currentTab == 2,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 5),
                      //     child: Text(
                      //       "Hoạt động",
                      //       style: TextStyle(
                      //         fontFamily: 'Roboto',
                      //         fontSize: 7,
                      //         fontWeight: currentTab == 2
                      //             ? FontWeight.w600
                      //             : FontWeight.w400,
                      //         color: currentTab == 2
                      //             ? AppColors.buttonColor
                      //             : AppColors.grey400,
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              MaterialButton(
                minWidth: 20.w,
                padding: const EdgeInsets.all(15),
                shape: const CircleBorder(),
                color: AppColors.buttonColor,
                onPressed: () {
                  Get.bottomSheet(const PickDateBooking());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    ImageIcon(
                        AssetImage(
                            "assets/image/icon-logo/mainpage-booking.png"),
                        size: 20,
                        color: Colors.white),
                  ],
                ),
              ),
              Expanded(
                child: MaterialButton(
                  minWidth: 20.w,
                  onPressed: () {
                    setState(() {
                      currentScreen = HealthCarRecordManagement(
                        onSelected: (int id) {},
                        selectedCar: 1,
                      );
                      currentTab = 3;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.car,
                        size: 20,
                        color: currentTab == 3
                            ? AppColors.buttonColor
                            : AppColors.grey400,
                      ),
                      // ImageIcon(
                      //   const AssetImage(
                      //       "assets/image/icon-logo/mainpage-diagnose.png"),
                      //   size: 20,
                      //   color: currentTab == 3
                      //       ? AppColors.buttonColor
                      //       : AppColors.grey400,
                      // ),
                      // Visibility(
                      //   visible: currentTab == 3,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 5),
                      //     child: Text(
                      //       "Chẩn đoán",
                      //       style: TextStyle(
                      //         fontFamily: 'Roboto',
                      //         fontSize: 10.sp,
                      //         fontWeight: currentTab == 3
                      //             ? FontWeight.w700
                      //             : FontWeight.w400,
                      //         color: currentTab == 3
                      //             ? AppColors.buttonColor
                      //             : AppColors.grey400,
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: MaterialButton(
                  minWidth: 20.w,
                  onPressed: () async {
                    setState(() {
                      currentScreen = const UserProfileSettings();
                      currentTab = 4;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ImageIcon(
                      //   const AssetImage(
                      //       "assets/image/icon-logo/mainpage-profile.png"),
                      //   size: 20,
                      //   color: currentTab == 4
                      //       ? AppColors.buttonColor
                      //       : AppColors.grey400,
                      // ),
                      FaIcon(
                        FontAwesomeIcons.solidUser,
                        size: 20,
                        color: currentTab == 4
                            ? AppColors.buttonColor
                            : AppColors.grey400,
                      ),
                      // Visibility(
                      //   visible: currentTab == 4,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 5),
                      //     child: Text(
                      //       "Tài khoản",
                      //       style: TextStyle(
                      //         fontFamily: 'Roboto',
                      //         fontSize: 10.sp,
                      //         fontWeight: currentTab == 4
                      //             ? FontWeight.w700
                      //             : FontWeight.w400,
                      //         color: currentTab == 4
                      //             ? AppColors.buttonColor
                      //             : AppColors.grey400,
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
