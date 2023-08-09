import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/services/brand_service/brand_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';
import '../../../common/jwt_interceptor.dart';

import '../../../models/response/booking.dart';
import '../../../services/car_service/car_service.dart';
import 'health_car_record_management_detail.dart';

class HealthCarRecordManagement extends StatefulWidget {
  final int selectedCar;
  final Function(int) onSelected;
  const HealthCarRecordManagement(
      {super.key, required this.selectedCar, required this.onSelected});

  @override
  State<HealthCarRecordManagement> createState() =>
      _HealthCarRecordManagementState();
}

class _HealthCarRecordManagementState extends State<HealthCarRecordManagement> {
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
      _listCar = listCar.where((element) => element.isNew == false).toList();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60.sp,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        leadingWidth: 84.sp,
        centerTitle: true,
        title: Text('Kết quả chẩn đoán',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: Colors.black,
            )),
      ),
      body: _loading ? const Loading() : Column(
        children: [
          SizedBox(height: 10.sp),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(left: 20.sp, right: 20.sp),
            width: 335.w,
            height: 45.h,
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.lightGrey500,
                focusedBorder: const OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.blueTextColor, width: 2),
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
                        car: _listCar[index] ,
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

  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.car.id == widget.selectedCar;
    return InkWell(
      onTap: () {
        Get.to(() => HealthCarRecordManagementDetail(carId: widget.car.id));
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
              future: BrandService().getPhoto(widget.car.carBrand),
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
          trailing: IconButton(
              onPressed: () {
                Get.to(() => HealthCarRecordManagementDetail(carId: widget.car.id));
              },
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.black,
              )),
        ),
      ),
    );
  }
}
