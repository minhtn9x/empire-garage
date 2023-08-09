import 'package:empiregarage_mobile/application_layer/screens/main_page/main_page.dart';
import 'package:empiregarage_mobile/application_layer/screens/user_profile/profile.dart';
import 'package:empiregarage_mobile/application_layer/screens/welcome/welcome_screen.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/models/response/user.dart';
import 'package:empiregarage_mobile/services/authen_firebase_services/authentication.dart';
import 'package:empiregarage_mobile/services/user_service/user_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import 'car_management.dart';
import 'health_car_record_management.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({super.key});

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  UserResponseModel? _user;

  bool _loading = true;

  @override
  void initState() {
    _getUserById();
    super.initState();
  }

  _getUserById() async {
    var userId = await getUserId();
    _user = await UserService().getUserById(userId);
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
    if (kDebugMode) {
      print(_user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.whiteTextColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: SizedBox(
            height: 40.h,
            width: 108.w,
            child: InkWell(
              onTap: () {
                Get.off(() => const MainPage());
              },
              child: Image.asset(
                "assets/image/app-logo/homepage-icon.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 160.w,
                    height: 160.h,
                    child: Stack(
                      children: <Widget>[
                        SizedBox(
                          width: 160.w,
                          height: 160.h,
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/image/user-pic/user.png"),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 5,
                          child: Container(
                            width: 33.w,
                            height: 33.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.buttonColor,
                              shape: BoxShape.rectangle,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit_rounded,
                                color: AppColors.whiteButtonColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _loading
                  ? const Loading()
                  : Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              _user!.fullname,
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                  color: AppColors.blackTextColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _user!.phone.toString(),
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                  color: AppColors.blackTextColor),
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 20.h,
              ),
              const Divider(color: AppColors.grey400, height: 3),
              SizedBox(
                height: 20.h,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: 180.h,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(() => UserProfile(
                              userId: _user!.id,
                            ));
                      },
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: ImageIcon(
                              AssetImage(
                                  "assets/image/icon-logo/mainpage-profile.png"),
                              size: 24,
                            ),
                          ),
                          Text(
                            "Chỉnh sửa thông tin",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                color: AppColors.blackTextColor),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.navigate_next,
                            size: 20,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        Get.to(() => CarManagement(
                              onSelected: (int) {},
                              selectedCar: 1,
                            ));
                      },
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 24),
                            child: ImageIcon(
                              AssetImage("assets/image/icon-logo/car.png"),
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Quản lý phương tiện",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                color: Colors.black),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.navigate_next,
                            size: 20,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        Get.to(() => HealthCarRecordManagement(
                              onSelected: (int) {},
                              selectedCar: 1,
                            ));
                      },
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 24),
                            child: ImageIcon(
                              AssetImage(
                                  "assets/image/icon-logo/mainpage-diagnose.png"),
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Kết quả chẩn đoán",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                color: Colors.black),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.navigate_next,
                            size: 20,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        var response = await AppAuthentication().logout();
                        if (response) {
                          Get.offAll(() => const WelcomeScreen());
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 24),
                            child: ImageIcon(
                              AssetImage("assets/image/icon-logo/logout.png"),
                              size: 24,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            "Đăng xuất",
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                color: Colors.red),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.navigate_next,
                            size: 20,
                            color: Colors.red,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
