import 'package:empiregarage_mobile/application_layer/screens/car/add_new_car.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/models/response/booking.dart';
import 'package:empiregarage_mobile/services/brand_service/brand_service.dart';
import 'package:empiregarage_mobile/services/car_service/car_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';

class ChoseYourCar extends StatefulWidget {
  final Function(int) onCallBack;
  final int selectedCar;
  final Function(int) onSelected;
  const ChoseYourCar(
      {Key? key,
      required this.selectedCar,
      required this.onSelected,
      required this.onCallBack})
      : super(key: key);

  @override
  State<ChoseYourCar> createState() => _ChoseYourCarState();
}

class _ChoseYourCarState extends State<ChoseYourCar> {
  List<CarResponseModel> _listCarWithBooking = [];
  List<CarResponseModel> _listCarWithoutBooking = [];
  List<CarResponseModel> listWithBooking = [];
  List<CarResponseModel> listWithoutBooking = [];
  late int _selectedCar;
  bool _loading = true;

  @override
  void initState() {
    _selectedCar = widget.selectedCar;
    _getUserCar();
    super.initState();
  }

  _getUserCar() async {
    var userId = await getUserId();
    var listCar = await CarService().fetchUserCars(userId as int);
    if (listCar == null) return;
    if (!mounted) return;

    listWithBooking.clear();
    listWithoutBooking.clear();
    for (var car in listCar) {
      if (car.haveBooking == true || car.isInGarage == true) {
        listWithBooking.add(car);
      } else {
        listWithoutBooking.add(car);
      }
    }
    setState(() {
      _listCarWithBooking = listWithBooking;
      _listCarWithoutBooking = listWithoutBooking;
      _loading = false;
    });
  }

  void _onCarSelected(int selectedCar) {
    setState(() {
      _selectedCar = selectedCar;
      widget.onSelected(selectedCar);
    });
    Get.back();
  }

  void _onCarSelectedv2(int selectedCar) {
    setState(() {
      _selectedCar = selectedCar;
      widget.onSelected(selectedCar);
    });
  }

  void _onCallBack(int selectedCar) async {
    await _getUserCar();
    _onCarSelectedv2(selectedCar);
    widget.onCallBack(selectedCar);
  }

  Future refresh() {
    _selectedCar = widget.selectedCar;
    return _getUserCar();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        height: 550.sp,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Column(children: [
                SizedBox(
                  height: 10.sp,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Row(
                    children: [
                      Text(
                        "Phương tiện",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.to(() => AddNewCar(
                                onAddCar: _onCallBack,
                              ));
                        },
                        child: Text(
                          "Thêm mới",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blueTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // height: 300.h,
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    color: AppColors.blue600,
                    child: _loading
                        ? const Loading()
                        : ListView(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _listCarWithoutBooking.length,
                                itemBuilder: (context, index) => Column(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.sp),
                                          child: CarChip(
                                            car: _listCarWithoutBooking[index],
                                            selectedCar: _selectedCar,
                                            onSelected: _onCarSelected,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 16.h,
                                    ),
                                  ],
                                ),
                              ),
                            _listCarWithBooking.isNotEmpty?
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                              child: Text("Xe không thể đặt lịch",
                                style: AppStyles.header600(fontsize: 12),
                              ),
                            ): Container(),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _listCarWithBooking.length,
                              itemBuilder: (context, index) => Column(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.sp),
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: AbsorbPointer(
                                            absorbing: true,
                                            child: CarChip(
                                              car: _listCarWithBooking[index],
                                              selectedCar: _selectedCar,
                                              onSelected: _onCarSelected,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class CarChip extends StatefulWidget {
  final CarResponseModel car;
  final int selectedCar;
  final Function(int) onSelected;
  const CarChip(
      {super.key,
      required this.car,
      required this.selectedCar,
      required this.onSelected});

  @override
  State<CarChip> createState() => _CarChipState();
}

class _CarChipState extends State<CarChip> {
  @override
  void initState() {
    super.initState();
  }

  Future<String?> getBrandPhoto(String brand) async {
    var photo = await BrandService().getPhoto(brand);
    return photo;
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.car.id == widget.selectedCar;
    return InkWell(
      onTap: () {
        widget.onSelected(widget.car.id);
      },
      child: Container(
        height: 70.sp,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  color: AppColors.grey400,
                  blurStyle: BlurStyle.outer)
            ]),
        child: ListTile(
          leading: FutureBuilder(
              future: getBrandPhoto(widget.car.carBrand),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.network(
                    snapshot.data.toString(),
                    height: 40.sp,
                    width: 50.sp,
                  );
                } else if (snapshot.hasError) {
                  return Image.asset(
                    "assets/image/icon-logo/bmw-car-icon.png",
                    height: 40.sp,
                    width: 50.sp,
                  );
                } else {
                  return Image.asset(
                    "assets/image/icon-logo/bmw-car-icon.png",
                    height: 40.sp,
                    width: 50.sp,
                  );
                }
              }),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.car.carBrand,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightTextColor,
                ),
              ),
              SizedBox(
                height: 5.sp,
              ),
              Text(
                widget.car.carLisenceNo,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                ),
              ),
              SizedBox(
                height: 5.sp,
              ),
              Text(
                widget.car.carModel,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightTextColor,
                ),
              ),
            ],
          ),
          trailing: widget.car.isInGarage == false && widget.car.haveBooking == false?Column(
            children: [
              SizedBox(height: 10.sp),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.buttonColor : AppColors.grey400,
              )
            ],
          ): null,
        ),
      ),
    );
  }
}
