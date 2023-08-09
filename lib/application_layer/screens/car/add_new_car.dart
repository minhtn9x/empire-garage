import 'dart:convert';

import 'package:empiregarage_mobile/application_layer/widgets/bottom_popup.dart';
import 'package:empiregarage_mobile/application_layer/widgets/screen_loading.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/models/response/activity.dart';
import 'package:empiregarage_mobile/models/response/brand.dart';
import 'package:empiregarage_mobile/services/car_service/car_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddNewCar extends StatefulWidget {
  final Function(int) onAddCar;
  const AddNewCar({super.key, required this.onAddCar});

  @override
  State<AddNewCar> createState() => _AddNewCarState();
}

class _AddNewCarState extends State<AddNewCar> {
  var carModel = "";
  var carBrand = "";
  var carLisenceNo = "";

  List<BrandResponseModel> _brands = [];
  List<BrandResponseModel> _filteredBrands = [];
  List<ModelResponseModel> _models = [];
  List<ModelResponseModel> _filteredModels = [];

  _getBrands() async {
    var brands = await CarService().getBrand();
    setState(() {
      _brands = brands;
    });
  }

  _getModels(BrandResponseModel brand) {
    setState(() {
      _models = brand.models;
    });
  }

  _clearModel() {
    setState(() {
      _modelController.clear();
      carModel = "";
    });
  }

  @override
  void initState() {
    super.initState();
    _getBrands();
  }

  final _lisenceNoController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = _lisenceNoController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      // return 'Không được bỏ trống';
    } else {
      const pattern = r'[A-Za-z]{1,3}-[0-9]{1,5}';
      final regExp = RegExp(pattern);
      if (!regExp.hasMatch(text)) {
        return 'Biển số xe không hợp lệ';
      }
    }
    // return null if the text is valid
    return null;
  }

  String? get _errorBrandText {
    // at any time, we can get the text from _controller.value.text
    final text = _brandController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.isEmpty) {
      // return 'Không được bỏ trống';
    }
    // return null if the text is valid
    return null;
  }

  _popContext() {
    Get.back();
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
                        "Thêm phương tiện",
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
                          controller: _lisenceNoController,
                          // decoration: InputDecoration(
                          //   border: OutlineInputBorder(
                          //       borderSide: BorderSide.none,
                          //       borderRadius: BorderRadius.circular(26)),
                          //   focusedBorder: OutlineInputBorder(
                          //       borderSide: const BorderSide(
                          //           color: AppColors.loginScreenBackGround),
                          //       borderRadius: BorderRadius.circular(26)),
                          //   floatingLabelBehavior: FloatingLabelBehavior.always,
                          //   filled: true,
                          //   hintText: "Nhập biển số xe của bạn",
                          //   errorText: _errorText,
                          // ),
                          decoration: AppStyles.textbox12(
                              hintText: 'Nhập biển số xe của bạn',
                              errorText: _errorText),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightTextColor,
                          ),
                          onChanged: (value) {
                            setState(() {
                              carLisenceNo = value;
                            });
                          },
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
                        child: TypeAheadFormField<BrandResponseModel>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _brandController,
                            decoration: AppStyles.textbox12(
                              hintText: 'Chọn hãng xe',
                              suffixIcon: const Icon(Icons.keyboard_arrow_down),
                              errorText: _errorBrandText,
                            ),
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.lightTextColor,
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            return _brands
                                .where((element) =>
                                element.name.toLowerCase().contains(pattern.toLowerCase()))
                                .toList();
                          },
                          itemBuilder: (context, BrandResponseModel suggestion) {
                            return ListTile(
                              title: Text(suggestion.name),
                            );
                          },
                          onSuggestionSelected: (BrandResponseModel suggestion) {
                            setState(() {
                              _brandController.text = suggestion.name;
                              carBrand = suggestion.name;
                              _clearModel();
                            });
                            _getModels(suggestion);
                          },
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
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TypeAheadField(
                  //         textFieldConfiguration: TextFieldConfiguration(
                  //           controller: _modelController,
                  //           // decoration: InputDecoration(
                  //           //   border: OutlineInputBorder(
                  //           //       borderSide: BorderSide.none,
                  //           //       borderRadius: BorderRadius.circular(26)),
                  //           //   focusedBorder: OutlineInputBorder(
                  //           //       borderSide: const BorderSide(
                  //           //           color: AppColors.loginScreenBackGround),
                  //           //       borderRadius: BorderRadius.circular(26)),
                  //           //   floatingLabelBehavior:
                  //           //       FloatingLabelBehavior.always,
                  //           //   filled: true,
                  //           //   hintText: "Nhập dòng xe",
                  //           // ),
                  //           decoration: AppStyles.textbox12(
                  //               hintText: 'Chọn dòng xe',
                  //               suffixIcon:
                  //                   const Icon(Icons.keyboard_arrow_down)),
                  //           style: TextStyle(
                  //             fontFamily: 'Roboto',
                  //             fontSize: 12.sp,
                  //             fontWeight: FontWeight.w400,
                  //             color: AppColors.lightTextColor,
                  //           ),
                  //           onChanged: (value) {
                  //             setState(() {
                  //               _filteredModels = _models
                  //                   .where((element) => element.name
                  //                       .toLowerCase()
                  //                       .contains(value.toLowerCase()))
                  //                   .toList();
                  //             });
                  //           },
                  //         ),
                  //         suggestionsCallback: (pattern) async {
                  //           return _filteredModels;
                  //         },
                  //         itemBuilder: (context, suggestion) {
                  //           return ListTile(
                  //             title: Text(suggestion.name),
                  //           );
                  //         },
                  //         onSuggestionSelected: (suggestion) {
                  //           setState(() {
                  //             _modelController.text = suggestion.name;
                  //             carModel = suggestion.name;
                  //           });
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: TypeAheadFormField<ModelResponseModel>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: _modelController,
                            decoration: AppStyles.textbox12(
                              hintText: 'Chọn dòng xe',
                              suffixIcon: const Icon(Icons.keyboard_arrow_down),
                            ),
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.lightTextColor,
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            return _models
                                .where((element) =>
                                element.name.toLowerCase().contains(pattern.toLowerCase()))
                                .toList();
                          },
                          itemBuilder: (context, ModelResponseModel suggestion) {
                            return SingleChildScrollView(
                              child: ListTile(
                                title: Text(suggestion.name),
                              ),
                            );
                          },
                          onSuggestionSelected: (ModelResponseModel suggestion) {
                            setState(() {
                              _modelController.text = suggestion.name;
                              carModel = suggestion.name;
                            });
                          },
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
                      if (_errorText != null || _errorBrandText != null) {
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (context) => const ScreenLoading(),
                      );
                      var response = await CarService()
                          .addNewCar(carLisenceNo, carBrand, carModel);
                      Get.back();
                      // ignore: unnecessary_null_comparison
                      if (response == null || response.statusCode != 201) {
                        Get.bottomSheet(
                          BottomPopup(
                            image: 'assets/image/icon-logo/failed-icon.png',
                            title: "Thêm xe thất bại",
                            body: "Vui lòng điền thông tin vào tất cả ô trống",
                            buttonTitle: "Trở về",
                            action: () => Get.back(),
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      } else {
                        Get.bottomSheet(
                          BottomPopup(
                            image:
                                'assets/image/icon-logo/successfull-icon.png',
                            title: "Thêm xe thành công",
                            body:
                                "Bạn đã thêm $carLisenceNo ($carBrand $carModel) làm phương tiện mới",
                            buttonTitle: "Trở về",
                            action: () {
                              _popContext();
                              _popContext();
                              widget.onAddCar(CarResponseModel.fromJson(
                                      jsonDecode(response.body))
                                  .id as int);
                            },
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      }
                    },
                    style: AppStyles.button16(),
                    child: Text(
                      'Xác nhận',
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
