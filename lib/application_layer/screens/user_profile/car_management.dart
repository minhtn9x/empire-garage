import 'package:empiregarage_mobile/application_layer/screens/car/add_new_car.dart';
import 'package:empiregarage_mobile/application_layer/screens/car/update_car.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/services/brand_service/brand_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/jwt_interceptor.dart';

import '../../../models/response/booking.dart';
import '../../../services/car_service/car_service.dart';

class CarManagement extends StatefulWidget {
  final int selectedCar;
  final Function(int) onSelected;
  const CarManagement(
      {super.key, required this.selectedCar, required this.onSelected});

  @override
  State<CarManagement> createState() => _CarManagementState();
}

class _CarManagementState extends State<CarManagement> {
  List<CarResponseModel> _listCar = [];
  late int _selectedCar;
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  List<CarResponseModel> _initListCar = [];

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
    setState(() {
      _listCar = listCar;
      _initListCar = listCar;
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

  void _runFilter(String searchString){
    if(searchString.isNotEmpty){
      setState(() {
        _listCar = _initListCar
            .where((element) => element.carLisenceNo.toLowerCase()
            .contains(searchString.toLowerCase())).toList();
      });
    }
    if(searchString.isEmpty){
      setState(() {
        _listCar = _initListCar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.sp,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Container(
            height: 42,
            width: 42,
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
        ),
        leadingWidth: 84.sp,
        centerTitle: true,
        title: Text('Phương tiện',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black,
            )),
        actions: [
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Container(
              height: 42,
              width: 42,
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
                    Get.to(
                      () => AddNewCar(
                        onAddCar: (int carId) async {
                          var newCar = await CarService().getCarById(carId);
                          if(newCar != null){
                            setState(() {
                              _listCar.add(newCar);
                            });
                          }
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  )),
            ),
          ),
        ],
      ),
      body: _loading ? const Loading() : Container(
        child: Column(
          children: [
            SizedBox(height: 10.sp),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(left: 24, right: 24),
              width: 335.w,
              height: 45.h,
              child: TextField(
                //focusNode: FocusNode(canRequestFocus: true),
                onChanged: (value) => _runFilter(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGrey500,
                  focusedBorder: const OutlineInputBorder(
                      borderSide:
                      BorderSide(color: AppColors.blueTextColor, width: 3),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  focusColor: AppColors.searchBarColor,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.search,
                      color: AppColors.lightTextColor,
                      size: 20,
                    ),
                  ),
                  hintText: 'Tìm kiếm...',
                  hintStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightTextColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _listCar.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                        child: CarChipManagement(
                          car: _listCar[index],
                          selectedCar: _selectedCar,
                          onSelected: _onCarSelected,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}

class CarChipManagement extends StatefulWidget {
  final CarResponseModel car;
  final int selectedCar;
  final Function(int) onSelected;
  const CarChipManagement(
      {super.key,
      required this.car,
      required this.selectedCar,
      required this.onSelected});

  @override
  State<CarChipManagement> createState() => _CarChipManagementState();
}

class _CarChipManagementState extends State<CarChipManagement> {
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
        //TODO
      },
      child: Container(
        height: 70.sp,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  blurRadius: 20,
                  color: Colors.grey.shade300,
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
          onTap: () {
            Get.to(() => UpdateCar(
              car: widget.car,
              onSelected: (int) {},
            ));
          },
          // trailing: Column(
          //   children: [
          //     SizedBox(height: 10.sp),
          //     Icon(
          //       isSelected
          //           ? Icons.radio_button_checked
          //           : Icons.radio_button_unchecked,
          //       color: isSelected ? AppColors.buttonColor : AppColors.grey400,
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }
}
