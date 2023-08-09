import 'package:empiregarage_mobile/application_layer/screens/orders/order_service_detail.dart';
import 'package:empiregarage_mobile/common/colors.dart';
import 'package:empiregarage_mobile/models/response/orderservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderDetail extends StatefulWidget {
  final OrderServicesResponseModel _orderServicesResponseModel;

  @override
  State<OrderDetail> createState() => _OrderDetailState();

  const OrderDetail(this._orderServicesResponseModel, {super.key});
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
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
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(widget._orderServicesResponseModel.car.carLisenceNo,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black,
            )),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.sp),
            Text(
              'Ghi chú và hình ảnh đính kèm từ kỹ thuật viên',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5.sp),
            Text(
              'Bấm vào từng dịch vụ để xem chi tiết',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 10.sp,
                color: AppColors.lightTextColor,
              ),
            ),
            SizedBox(height: 10.sp),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget
                    ._orderServicesResponseModel.orderServiceDetails!.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(() => OrderServiceDetail(
                              index, widget._orderServicesResponseModel));
                        },
                        child: Row(
                          children: [
                            widget._orderServicesResponseModel
                                        .orderServiceDetails![index].done ==
                                    true
                                ? Icon(Icons.verified,
                                    color: AppColors.blueTextColor)
                                : Icon(Icons.schedule,
                                    color: AppColors.grey400),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.sp),
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    widget._orderServicesResponseModel
                                        .orderServiceDetails![index].item!.name
                                        .toString(),
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    widget
                                        ._orderServicesResponseModel
                                        .orderServiceDetails![index]
                                        .item!
                                        .problem!
                                        .name
                                        .toString(),
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp,
                                      color: AppColors.lightTextColor,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.keyboard_arrow_right,
                                    color: AppColors.blackTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
