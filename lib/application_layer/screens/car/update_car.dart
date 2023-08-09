import 'dart:convert';
import 'dart:developer';

import 'package:empiregarage_mobile/application_layer/screens/user_profile/car_management.dart';
import 'package:empiregarage_mobile/application_layer/widgets/bottom_popup.dart';
import 'package:empiregarage_mobile/application_layer/widgets/chose_your_car.dart';
import 'package:empiregarage_mobile/application_layer/widgets/screen_loading.dart';
import 'package:empiregarage_mobile/common/colors.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/models/request/car_request_model.dart';
import 'package:empiregarage_mobile/models/response/booking.dart';
import 'package:empiregarage_mobile/services/car_service/car_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UpdateCar extends StatefulWidget {
  CarResponseModel car;
  final Function(int) onSelected;

  UpdateCar({
    required this.car,
    required this.onSelected,
  });

  @override
  State<UpdateCar> createState() => _UpdateCarState();
}

class _UpdateCarState extends State<UpdateCar> {
  final _lisenceNoController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _brandController.text = widget.car.carBrand;
    _lisenceNoController.text = widget.car.carLisenceNo;
    _modelController.text = widget.car.carModel;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.loginScreenBackGround,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 52.h,
                  ),
                  Stack(alignment: Alignment.centerLeft, children: <Widget>[
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
                        "Phương tiện",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "Biển số xe",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            widget.car.carLisenceNo = value;
                          },
                          controller: _lisenceNoController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: AppColors.grey200),
                                borderRadius: BorderRadius.circular(16)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: AppColors.buttonColor),
                                borderRadius: BorderRadius.circular(16)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Nhập biển số xe của bạn",
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.lightTextColor,
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Text(
                    "Hãng xe",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            widget.car.carModel = value;
                          },
                          controller: _modelController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: AppColors.grey200),
                                borderRadius: BorderRadius.circular(16)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: AppColors.buttonColor),
                                borderRadius: BorderRadius.circular(16)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Nhập biển số xe của bạn",
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.lightTextColor,
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Text(
                    "Dòng xe",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 10.sp,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            widget.car.carBrand = value;
                          },
                          controller: _brandController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: AppColors.grey200),
                                borderRadius: BorderRadius.circular(16)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: AppColors.buttonColor),
                                borderRadius: BorderRadius.circular(16)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Nhập biển số xe của bạn",
                            hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.lightTextColor,
                            ),
                          ),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                  horizontal: BorderSide.merge(
                      BorderSide(color: Colors.grey.shade200, width: 1),
                      BorderSide.none))),
          child: Container(
            margin: const EdgeInsets.all(20),
            width: double.infinity,
            height: 52.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      CarRequestModel model = CarRequestModel(
                          carId: widget.car.id,
                          carLisenceNo: _lisenceNoController.text,
                          carBrand: _brandController.text,
                          carModel: _modelController.text);
                      log(jsonEncode(model));
                      var response = await CarService().updateCar(model);
                      if (response != null && response.statusCode == 204) {
                        Get.bottomSheet(
                          BottomPopup(
                            image:
                                'assets/image/icon-logo/successfull-icon.png',
                            title: "",
                            body: 'Cập nhật thông tin xe thành công',
                            buttonTitle: "Xác nhận",
                            action: () {
                              Get.back();
                              Get.back();
                              Get.back();
                              Get.to(() => CarManagement(
                                    selectedCar: widget.car.id,
                                    onSelected: (int) {},
                                  ));
                            },
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      } else {
                        log("error when update car");
                        Get.bottomSheet(
                          BottomPopup(
                            image: 'assets/image/icon-logo/failed-icon.png',
                            title: "",
                            body: '',
                            buttonTitle: "Trở về",
                            action: () {
                              Get.back();
                            },
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      }
                    },
                    style: AppStyles.button16(),
                    child: Text(
                      'Cập nhật',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.sp),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.bottomSheet(
                        BottomPopup(
                          image: 'assets/image/icon-logo/failed-icon.png',
                          title: "",
                          body: 'Bạn chắc chắn muốn xóa xe này ?',
                          buttonTitle: "Xác nhận",
                          action: () async {
                            var customerId = await getUserId();
                            if(customerId == null){
                              return;
                            }
                            var response =
                                await CarService().deleteCar(widget.car.id, customerId);
                            if (response != null && response.statusCode == 204) {
                              Get.back();
                              Get.back();
                              Get.back();
                              Get.to(() => CarManagement(
                                    selectedCar: widget.car.id,
                                    onSelected: (int) {},
                                  ));
                            } else {
                              Get.back();
                              Get.back();
                              Get.back();
                              Get.to(() => CarManagement(
                                selectedCar: widget.car.id,
                                onSelected: (int) {},
                              ));
                            }
                          },
                        ),
                        backgroundColor: Colors.transparent,
                      );
                    },
                    style: AppStyles.button16(color: AppColors.errorIcon),
                    child: Text(
                      'Xóa',
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
          ),
        ),
      ),
    );
  }
}
