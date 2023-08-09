import 'dart:convert';

import 'package:empiregarage_mobile/application_layer/screens/booking/booking_detail_v2.dart';
import 'package:empiregarage_mobile/application_layer/screens/main_page/main_page.dart';
import 'package:empiregarage_mobile/application_layer/widgets/bottom_popup.dart';
import 'package:empiregarage_mobile/application_layer/widgets/chose_payment_method.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/application_layer/widgets/tag_editor.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/models/request/booking_request_model.dart';
import 'package:empiregarage_mobile/models/response/booking.dart';
import 'package:empiregarage_mobile/models/response/brand.dart';
import 'package:empiregarage_mobile/models/response/car.dart';
import 'package:empiregarage_mobile/models/response/symptoms.dart';
import 'package:empiregarage_mobile/services/brand_service/brand_service.dart';
import 'package:empiregarage_mobile/services/car_service/car_service.dart';
import 'package:empiregarage_mobile/services/model_services/model_service.dart';
import 'package:empiregarage_mobile/services/symptoms_service/symptoms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../common/colors.dart';
import '../../../helper/common_helper.dart';
import '../../../models/request/payment_request_model.dart';
import '../../../services/booking_service/booking_service.dart';
import '../../../services/payment_services/payment_services.dart';
import '../../widgets/booking_fail.dart';
import '../../widgets/chose_your_car.dart';
import '../../widgets/deposit_bottomsheet.dart';
import '../car/add_new_car.dart';
import 'booking_payment.dart';
import 'booking_problem_history.dart';

class BookingInfo extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final selectedDate;

  const BookingInfo({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<BookingInfo> createState() => _BookingInfoState();
}

class _BookingInfoState extends State<BookingInfo> {
  late BookingRequestModel requestModel;

  int index = 0;

  // ignore: prefer_final_fields
  // TextEditingController _symptonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<SymptonResponseModel> options = [];

  // final List<SymptonResponseModel> _listSuggestService = [];

  double _bookingPrice = 0;
  double _initBookingPrice = 0;

  PaymentRequestModel model = PaymentRequestModel(
      orderType: '', amount: 0, orderDescription: '', name: '');

  bool _emptySymtomp = false;

  _payBookingFee(PaymentRequestModel model) async {
    var response = await PaymentServices().createNewPaymentForBooking(model);
    if (response!.statusCode == 500) {
      throw Exception("Can not pay booking fee");
    }
    return response.body;
  }

  _getBookingPrice() async {
    var response = await BookingService().getBookingPrice();
    setState(() {
      _initBookingPrice = response;
    });
    return _initBookingPrice;
  }

  // List<String> _getSuggestions(String query) {
  //   List<String> matches = [];
  //   matches.addAll(_symptonList
  //       .where((s) =>
  //           s.name.toString().toLowerCase().contains(query.toLowerCase()))
  //       .map((s) => s.name.toString()));
  //   return matches;
  // }

  // void _onSuggestionSelected(String suggestion) {
  //   setState(() {
  //     _symptonController.text = suggestion;
  //   });
  // }

  List<SymptonResponseModel> _listSymptom = [];
  bool _loading = false;
  late int _selectedCar;
  List<CarResponseModel> _listCar = [];
  bool _isCarHasHCR = false;
  bool _loadHCR = false;
  CarProfile? _carProfile;
  List<UnresolvedProblem> _unresolvedProblems = [];
  ModelSlimResponse? _model;
  bool _canBooking = false;

  _loadOptions() async {
    var symptoms = await SymptomsService().fetchListSymptoms();
    if (symptoms != null) {
      setState(() {
        options = symptoms;
      });
    }
  }

  // _checkCanBookOrNot() async {
  //   var workload = await BookingService().getMinWorkload();
  //   DateTime selectedDate = widget.selectedDate;
  //   if(selectedDate.compareTo(workload!.intendedFinishTime) > 0){
  //       setState(() {
  //         _canBooking = true;
  //       });
  //   } else {
  //     setState(() {
  //       _canBooking = false;
  //     });
  //   }
  // }

  _getModel(String modelName, String brandName) async {
    var model = await ModelService().getModel(modelName, brandName);
    setState(() {
      _model = model;
    });
  }

  _onSelectSymtomAndCar(int symptomId) async {
    if (_model == null) return;
    var modelSymptom =
        await ModelService().getExpectedPrice(_model!.id, symptomId);
    if (modelSymptom != null) {
      return modelSymptom.expectedPrice;
    }
  }

  _getUserCar() async {
    var userId = await getUserId();
    var listCar = await CarService().fetchUserCars(userId as int);
    if (!mounted) return;
    if (listCar == null || listCar.isEmpty) {
      setState(() {
        _loading = true;
      });
      return;
    }
    if(listCar.where((element) => element.isInGarage == false && element.haveBooking == false).isNotEmpty){
      setState(() {
        _listCar = listCar;
        _selectedCar = _listCar
            .where((element) =>
        element.isInGarage == false && element.haveBooking == false)
            .first
            .id;
        _loadHCR = false;
        _loading = true;
      });
      var car = _listCar.where((element) => element.id == _selectedCar).first;
      await _getModel(car.carModel, car.carBrand);
      for (var element in options) {
        element.expectedPrice = await _onSelectSymtomAndCar(element.id);
      }
      bool isCarHasHCR = await _checkCarHasHCR(_selectedCar);
      if(mounted) {
        setState(() {
          _isCarHasHCR = isCarHasHCR;
          _loadHCR = true;
        });
      }
    }
    if(listCar.where((element) => element.isInGarage == false && element.haveBooking == false).isEmpty){
      setState(() {
        _loading = true;
      });
    }
  }

  Future<bool> _checkCarHasHCR(int carId) async {
    var car = await CarService().getCarProfle(carId);
    if (car != null && car.healthCarRecords.isNotEmpty) {
      _carProfile = car;
      return true;
    }
    return false;
  }

  _onCarChange(selectedCar) {
    if (_selectedCar != selectedCar) {
      setState(() {
        _listSymptom.clear();
        _unresolvedProblems.clear();
      });
    }
  }

  void _onCarSelected(int selectedCar) async {
    _onCarChange(selectedCar);
    setState(() {
      _selectedCar = selectedCar;
      _loadHCR = false;
    });
    bool isCarHasHCR = await _checkCarHasHCR(_selectedCar);
    setState(() {
      _isCarHasHCR = isCarHasHCR;
      _loadHCR = true;
    });
    var car = _listCar.where((element) => element.id == _selectedCar).first;
    await _getModel(car.carModel, car.carBrand);
    for (var element in options) {
      element.expectedPrice = await _onSelectSymtomAndCar(element.id);
    }
  }

  void _onCallBack(int selectedCar) async {
    setState(() {
      _loading = false;
      _loadHCR = false;
    });
    _dateController.text = widget.selectedDate.toString().substring(0, 10);
    await _loadOptions();
    await _getUserCar();
    _onCarChange(selectedCar);
    setState(() {
      _loading = true;
      _selectedCar = selectedCar;
    });
    bool isCarHasHCR = await _checkCarHasHCR(_selectedCar);
    setState(() {
      _isCarHasHCR = isCarHasHCR;
      _loadHCR = true;
    });
  }

  // int? _selectedIndex;

  @override
  void initState() {
    _dateController.text = widget.selectedDate.toString().substring(0, 10);
    _getBookingPrice();
    _loadOptions();
    _getUserCar();
    //_checkCanBookOrNot();
    super.initState();
  }

  _loadData() async {
    _dateController.text = widget.selectedDate.toString().substring(0, 10);
    await _getUserCar();
    await _loadOptions();
  }

  Future refresh() {
    return _loadData();
  }

  Future _onCallBackFromPayment() async {
    setState(() {
      _loading = false;
    });
    String date = _dateController.text;
    int userId = await getUserId() as int;
    int carId =
        _listCar.where((element) => element.id == _selectedCar).first.id;
    // ignore: use_build_context_synchronously
    var response = await BookingService().createBooking(
        context,
        date,
        carId,
        userId,
        double.parse(_bookingPrice.toString()),
        _listSymptom,
        _unresolvedProblems);
    try {
      var x = response.statusCode;
      setState(() {
        _loading = true;
      });
      Get.back();
      Get.bottomSheet(
        BottomPopup(
          image: 'assets/image/icon-logo/failed-icon.png',
          title: "Đặt lịch thất bại",
          body: jsonDecode(response.body)['message'],
          buttonTitle: "Thử lại",
          action: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
      );
    } catch (RuntimeBinderException) {
      if (response != null) {
        setState(() {
          _loading = true;
        });
        Get.back();
        Get.bottomSheet(
          BottomPopup(
            image: 'assets/image/icon-logo/successfull-icon.png',
            title: "Đặt lịch thành công",
            body:
                'Mã đặt lịch: #${response.code}\nBạn đã đặt lịch thành công với phương tiện ${response.car.carLisenceNo}',
            buttonTitle: "Xem chi tiết",
            action: () {
              Get.offAll(() => const MainPage());
              Get.to(() => BookingDetailv2(bookingId: response.id));
            },
          ),
          backgroundColor: Colors.transparent,
        );
      } else {
        setState(() {
          _loading = true;
        });
        Get.bottomSheet(const BookingFailed(
          message: 'Đặt lịch thất bại, vui lòng thử lại',
        ));
      }
    }
  }

  Future<String?> getBrandPhoto(String brand) async {
    var photo = await BrandService().getPhoto(brand);
    return photo;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_outlined,
              size: 32,
              color: AppColors.lightTextColor,
            ),
          ),
          title: Center(
            child: SizedBox(
              width: 200.w,
              child: Text(
                "Đặt lịch - ${formatDate(widget.selectedDate.toString(), false)}",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                ),
              ),
            ),
          ),
        ),
        body: !_loading
            ? const Loading()
            : RefreshIndicator(
                onRefresh: refresh,
                color: AppColors.blue600,
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    // Text(
                    //   "Ngày đặt",
                    //   style: TextStyle(
                    //     fontFamily: 'Roboto',
                    //     fontSize: 14.sp,
                    //     fontWeight: FontWeight.w600,
                    //     color: AppColors.blackTextColor,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 5.h,
                    // ),
                    // SizedBox(
                    //   height: 55.h,
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: TextField(
                    //           enabled: false,
                    //           controller: _dateController,
                    //           decoration: InputDecoration(
                    //             fillColor: Colors.white,
                    //             border: OutlineInputBorder(
                    //                 borderSide: BorderSide.none,
                    //                 borderRadius: BorderRadius.circular(12)),
                    //             focusedBorder: OutlineInputBorder(
                    //                 borderSide: const BorderSide(
                    //                     color: AppColors.lightGrey),
                    //                 borderRadius: BorderRadius.circular(12)),
                    //             floatingLabelBehavior:
                    //                 FloatingLabelBehavior.always,
                    //             filled: true,
                    //           ),
                    //           style: TextStyle(
                    //             fontFamily: 'Roboto',
                    //             fontSize: 14.sp,
                    //             fontWeight: FontWeight.w400,
                    //             color: AppColors.lightTextColor,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Phương tiện",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackTextColor,
                            ),
                          ),
                          _listCar.isNotEmpty
                              ? TextButton(
                                  onPressed: () {
                                    Get.bottomSheet(
                                      ChoseYourCar(
                                        selectedCar: _selectedCar,
                                        onSelected: _onCarSelected,
                                        onCallBack: _onCallBack,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                    );
                                  },
                                  child: Text(
                                    "Chọn",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.blueTextColor,
                                    ),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: Text(
                        "Phương tiện được chọn",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightTextColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    _listCar.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  AddNewCar(
                                    // ignore: avoid_types_as_parameter_names
                                    onAddCar: (int) {
                                      _loadData();
                                    },
                                  ),
                                  isScrollControlled: true,
                                  isDismissible: false,
                                );
                              },
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
                                child: SizedBox(
                                  height: 55.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outline,
                                        color: AppColors.blueTextColor,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "Thêm phương tiện",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blueTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Get.bottomSheet(
                                ChoseYourCar(
                                  selectedCar: _selectedCar,
                                  onSelected: _onCarSelected,
                                  onCallBack: _onCallBack,
                                ),
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                              );
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 24, right: 24),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 1),
                                    )
                                  ],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16))),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: FutureBuilder(
                                        future: getBrandPhoto(_listCar
                                            .where((element) =>
                                                element.id == _selectedCar)
                                            .first
                                            .carBrand),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Image.network(
                                              snapshot.data.toString(),
                                              height: 50.h,
                                              width: 50.w,
                                            );
                                          } else if (snapshot.hasError) {
                                            return Image.asset(
                                              "assets/image/icon-logo/bmw-car-icon.png",
                                              height: 50.h,
                                              width: 50.w,
                                            );
                                          } else {
                                            return Image.asset(
                                              "assets/image/icon-logo/bmw-car-icon.png",
                                              height: 50.h,
                                              width: 50.w,
                                            );
                                          }
                                        }),
                                    title: Text(
                                      _listCar
                                          .where((element) =>
                                              element.id == _selectedCar)
                                          .first
                                          .carBrand,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.lightTextColor,
                                      ),
                                    ),
                                    subtitle: Align(
                                      alignment: Alignment.topLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _listCar
                                                .where((element) =>
                                                    element.id == _selectedCar)
                                                .first
                                                .carLisenceNo,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.blackTextColor,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                            _listCar
                                                .where((element) =>
                                                    element.id == _selectedCar)
                                                .first
                                                .carModel,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.lightTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    isThreeLine: true,
                                    trailing: Column(
                                      children: [
                                        SizedBox(height: 15.h),
                                        const Icon(
                                          Icons.radio_button_checked,
                                          color: AppColors.buttonColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  _isCarHasHCR ? const Divider() : Container(),
                                  _loadHCR
                                      ? _isCarHasHCR
                                          ? InkWell(
                                              onTap: () {
                                                Get.to(
                                                    () => BookingProblemHistory(
                                                          car: _carProfile,
                                                          onChooseUnresolvedProblemsCallBack:
                                                              (unresolvedProblems) {
                                                            setState(() {
                                                              _unresolvedProblems =
                                                                  unresolvedProblems;
                                                            });
                                                          },
                                                        ));
                                              },
                                              child: Container(
                                                margin: EdgeInsets.all(8.sp),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Lịch sử sửa chữa',
                                                      style: AppStyles.header600(
                                                          fontsize: 10.sp,
                                                          color: AppColors
                                                              .blueTextColor),
                                                    ),
                                                    const Icon(
                                                      Icons
                                                          .navigate_next_outlined,
                                                      color: AppColors
                                                          .blueTextColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container()
                                      : Container(
                                          height: 20.sp,
                                          width: 20.sp,
                                          margin: EdgeInsets.all(8.sp),
                                          child: const Loading())
                                ],
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: Text(
                        "Tình trạng xe",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    if (_model != null)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: TagEditor(
                            options: options,
                            modelId: _model!.id,
                            onChanged: (tags) async {
                              if (tags.isNotEmpty) {
                                setState(() {
                                  _bookingPrice = _initBookingPrice;
                                });
                              } else {
                                setState(() {
                                  _bookingPrice = 0;
                                });
                              }
                              setState(() {
                                _listSymptom = tags;
                              });
                            },
                            emptySymptom: (emptySymtomp) {
                              setState(() {
                                _emptySymtomp = emptySymtomp;
                              });
                            }),
                      ),

                    _emptySymtomp
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Text(
                              'Vui lòng nhập triệu chứng',
                              style: AppStyles.text400(
                                  fontsize: 12.sp, color: AppColors.errorIcon),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 10.h,
                    ),
                    _unresolvedProblems.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                      "Vấn đề tái sửa chữa",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _unresolvedProblems.length,
                                  itemBuilder: (context, index) {
                                    var item = _unresolvedProblems[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.name,
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.blackTextColor,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                _unresolvedProblems
                                                    .remove(item);
                                              });
                                            },
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 18,
                                              color: AppColors.blackTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: Text(
                        "Thanh toán",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: Row(
                        children: [
                          Text(
                            "Phí kiểm tra",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.lightTextColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            NumberFormat.currency(
                                    decimalDigits: 0,
                                    locale: 'vi_VN',
                                    symbol: "đ")
                                .format(_bookingPrice)
                                .toString(),
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
                    AppStyles.divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Container(
                        margin: const EdgeInsets.only(left: 24, right: 24),
                        child: Row(
                          children: [
                            Text(
                              "Tổng cộng",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackTextColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              NumberFormat.currency(
                                      decimalDigits: 0,
                                      locale: 'vi_VN',
                                      symbol: "đ")
                                  .format(_bookingPrice)
                                  .toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 24, right: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Text(
                              "**Phí đặt chỗ sẽ được khấu trừ vào hóa đơn**",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackTextColor,
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Get.bottomSheet(const DepositBottomSheet());
                              },
                              child: Text(
                                "Tại sao tôi phải trả phí đặt chỗ ?",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackTextColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
        bottomNavigationBar: Container(
          height: 100.h,
          decoration: const BoxDecoration(
              border:
                  Border(top: BorderSide(color: AppColors.grey100, width: 2))),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                          onPressed: () {
                            if (_listSymptom.isEmpty &&
                                _unresolvedProblems.isEmpty) {
                              Get.bottomSheet(
                                BottomPopup(
                                  image:
                                      'assets/image/icon-logo/failed-icon.png',
                                  title: "Đặt lịch thất bại",
                                  body: 'Vui lòng nhập tình trạng xe',
                                  buttonTitle: "Thử lại",
                                  action: () {
                                    Get.back();
                                  },
                                ),
                                backgroundColor: Colors.transparent,
                              );
                            } else {
                              Get.bottomSheet(
                                BottomPopup(
                                  image:
                                      'assets/image/service-picture/confirmed.png',
                                  title: "Xác nhận thanh toán phí đặt lịch",
                                  body:
                                      'Tiền đặt lịch sẽ được khấu trừ vào hóa đơn khi thực hiện dịch vụ ở garage',
                                  buttonTitle: "Tiếp tục",
                                  action: () {
                                    Get.to(() => ChosePaymentMethod(
                                        excute: executeBook));
                                  },
                                ),
                                backgroundColor: Colors.transparent,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            fixedSize: Size.fromHeight(50.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Thanh toán',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  executeBook() async {
    // Check car can booking or not
    var response = await CarService().canBook(_selectedCar);
    if (response.statusCode == 500) {
      Get.bottomSheet(
        BottomPopup(
          image: 'assets/image/icon-logo/failed-icon.png',
          title: "Không thể đặt lịch",
          body: jsonDecode(response.body)['message'],
          buttonTitle: "Thử lại",
          action: () {
            Get.back();
          },
        ),
      );
    } else {
      if (_listSymptom.isEmpty && _unresolvedProblems.isEmpty) {
        setState(() {
          _emptySymtomp = true;
        });
        return;
      } else {
        if (_listSymptom.isEmpty && _unresolvedProblems.isNotEmpty) {
          _onCallBackFromPayment();
        } else {
          PaymentRequestModel paymentRequestModel = PaymentRequestModel(
              amount: _bookingPrice,
              name: 'Booking payment',
              orderDescription: 'Booking payment',
              orderType: 'VNpay');
          var responsePayment = await _payBookingFee(paymentRequestModel);
          Get.to(() => BookingPayment(
                url: responsePayment,
                callback: _onCallBackFromPayment,
              ));
        }
      }
    }
  }
}
