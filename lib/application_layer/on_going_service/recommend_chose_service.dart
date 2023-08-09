import 'package:empiregarage_mobile/application_layer/screens/booking/booking_detail.dart';
import 'package:empiregarage_mobile/application_layer/widgets/bottom_popup.dart';
import 'package:empiregarage_mobile/application_layer/widgets/loading.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/helper/common_helper.dart';
import 'package:empiregarage_mobile/models/request/order_service_detail_request_model.dart';
import 'package:empiregarage_mobile/models/response/orderservices.dart';
import 'package:empiregarage_mobile/services/order_services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:readmore/readmore.dart';

import '../../common/colors.dart';

class RecommendChoseService extends StatefulWidget {
  final int servicesId;
  final Function(List<OrderServiceDetailRequestModel>)
      onRecommendChoseServicecallBack;
  const RecommendChoseService(
      {super.key,
      required this.onRecommendChoseServicecallBack,
      required this.servicesId});

  @override
  State<RecommendChoseService> createState() => _RecommendChoseServiceState();
}

class _RecommendChoseServiceState extends State<RecommendChoseService> {
  bool isSelected = true;

  final List<OrderServiceDetailRequestModel> _listOrderServiceDetails = [];
  OrderServicesResponseModel? _orderServicesResponseModel;
  double _sum = 0;
  bool _loading = true;
  String? _error;

  List<String> serviceNames = [
    'Thay lốp',
    'Thay nhớt',
    'Sửa chữa động cơ',
    'Kiểm tra định kỳ',
    'Thay bình ắc quy'
  ];
  List<String> servicePrices = [
    "8000000",
    "500000",
    "10000000",
    "150000",
    "200000"
  ];

  _getOrderServices() async {
    var listOrderServiceDetails =
        await OrderServices().getOrderServicesById(widget.servicesId);
    if (listOrderServiceDetails != null) {
      List<OrderServiceDetails>? list =
          listOrderServiceDetails.orderServiceDetails;
      //get item default
      if (listOrderServiceDetails.healthCarRecord != null) {
        var list2 =
            listOrderServiceDetails.healthCarRecord!.healthCarRecordProblems;
        if (list2 != null) {
          for (var item2 in list2) {
            var list2 = item2.problem.items;
            if (list2 != null) {
              for (var element in list2) {
                if (element.isDefault == true) {
                  _confirmService(element, item2.problem.intendedMinutes);
                }
              }
            }
          }
        }
      }
      //end item
      try {
        if (list != null) {
          setState(() {
            _orderServicesResponseModel = listOrderServiceDetails;
            for (var item in list) {
              _sum += double.parse(item.price.toString());
            }
            _loading = false;
          });
        }
      } catch (e) {
        e.toString();
      }
    }
  }

  _confirmService(Item2 item, int? intendedMinutes) {
    setState(() {
      var detail = OrderServiceDetailRequestModel(
          itemId: item.id,
          price: double.parse(item.presentPrice.toString()),
          intendedMinutes: intendedMinutes);
      _listOrderServiceDetails.add(detail);
      _sum += double.parse(item.presentPrice.toString());
    });
  }

  bool _checkService(Item2 item) {
    for (var e in _listOrderServiceDetails) {
      if (e.itemId == item.id) {
        return true;
      }
    }
    return false;
  }

  _onContinue() {
    // if (_listOrderServiceDetails.isEmpty) {
    //   setState(() {
    //     _error = "Cần phải chọn ít nhất 1 dịch vụ";
    //   });
    //   return;
    // }
    var listProblemMissing = _orderServicesResponseModel!
        .healthCarRecord!.healthCarRecordProblems!
        .where((element) => !element.problem.items!.any(
            (item) => _listOrderServiceDetails.any((r) => r.itemId == item.id)))
        .toList();
    listProblemMissing.isNotEmpty
        ? Get.bottomSheet(
            BottomPopup(
              image: 'assets/image/icon-logo/warning-icon.png',
              title: "Bạn đang chưa chọn hết dịch vụ",
              body: 'Xe của bạn có thể sẽ không hoạt động bình thường nếu không thực hiện các vấn đề còn thiếu sau',
              buttonTitle: "Đồng ý",
              action: () {
                Get.back();
                widget
                    .onRecommendChoseServicecallBack(_listOrderServiceDetails);
              },
              addition: ListView.builder(
                padding:
                    EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listProblemMissing.length,
                itemBuilder: (context, index) {
                  return Center(
                      child: Text(
                    listProblemMissing[index].problem.name!,
                    style: AppStyles.header600(fontsize: 12.sp),
                  ));
                },
              ),
            ),
            backgroundColor: Colors.transparent,
          )
        : widget.onRecommendChoseServicecallBack(_listOrderServiceDetails);
  }

  @override
  void initState() {
    super.initState();
    _getOrderServices();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Loading()
        : Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(thickness: 1),
                    SizedBox(height: 10.sp),
                    Text(
                      "Kết quả chẩn đoán",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                    SizedBox(height: 10.sp),
                    ReadMoreText(
                      _orderServicesResponseModel!.healthCarRecord!.symptom
                          .toString(),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackTextColor,
                      ),
                      trimLines: 10,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' Read more',
                      trimExpandedText: ' Show less',
                    ),
                    SizedBox(height: 10.sp),
                    const Divider(thickness: 1),
                    SizedBox(height: 10.sp),
                    Text(
                      "Dịch vụ gợi ý trên kết quả phân tích",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                    SizedBox(height: 5.sp),
                    Text(
                      "Bạn có thể thay đổi theo mong muốn ",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightTextColor,
                      ),
                    ),
                    SizedBox(height: 15.sp),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _orderServicesResponseModel!
                            .healthCarRecord!.healthCarRecordProblems!.length,
                        itemBuilder: (context, index) {
                          var healthCarRecordProblem =
                              _orderServicesResponseModel!.healthCarRecord!
                                  .healthCarRecordProblems![index];
                          var selectedIndex = -1;
                          if (healthCarRecordProblem.problem.items != null) {
                            for (var element
                                in healthCarRecordProblem.problem.items!) {
                              var flag = _checkService(element);
                              if (flag == true) {
                                selectedIndex = healthCarRecordProblem
                                    .problem.items!
                                    .indexOf(element);
                              }
                            }
                          }
                          return ExpansionTile(
                              initiallyExpanded: true,
                              childrenPadding: EdgeInsets.zero,
                              tilePadding: EdgeInsets.zero,
                              shape: Border.all(color: Colors.white),
                              collapsedShape: Border.all(color: Colors.white),
                              iconColor: AppColors.blueTextColor,
                              title: Text(
                                healthCarRecordProblem.problem.name.toString(),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackTextColor,
                                ),
                              ),
                              subtitle: selectedIndex != -1
                                  ? Text(
                                      "Đã chọn: ${healthCarRecordProblem.problem.items![selectedIndex].name}",
                                      style: AppStyles.text400(fontsize: 10.sp))
                                  : null,
                              trailing: selectedIndex != -1
                                  ? Text(
                                      formatCurrency(healthCarRecordProblem
                                          .problem
                                          .items![selectedIndex]
                                          .presentPrice),
                                      style: AppStyles.text400(fontsize: 10.sp))
                                  : null,
                              onExpansionChanged: (value) {
                                if (value == false) {}
                              },
                              children: [
                                SizedBox(height: 5.sp),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: healthCarRecordProblem
                                      .problem.items!.length,
                                  itemBuilder: (context, index) {
                                    var item = healthCarRecordProblem
                                        .problem.items![index];
                                    return InkWell(
                                      onTap: () {
                                        //remove when click at itself
                                        if (_listOrderServiceDetails.any(
                                            (element) =>
                                                element.itemId == item.id)) {
                                          setState(() {
                                            _listOrderServiceDetails
                                                .removeWhere((element) =>
                                                    element.itemId == item.id);
                                            _sum -= item.presentPrice!;
                                          });
                                        } else {
                                          //reload list in a problem
                                          for (var e in healthCarRecordProblem
                                              .problem.items!) {
                                            if (_listOrderServiceDetails.any(
                                                (element) =>
                                                    element.itemId == e.id)) {
                                              _listOrderServiceDetails
                                                  .removeWhere((element) =>
                                                      element.itemId == e.id);
                                              _sum -= double.parse(
                                                  e.presentPrice.toString());
                                            }
                                          }
                                          _confirmService(
                                              item,
                                              healthCarRecordProblem
                                                  .problem.intendedMinutes);
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.sp, vertical: 5.sp),
                                        child: Row(
                                          children: [
                                            Icon(
                                              _checkService(item)
                                                  ? Icons.radio_button_checked
                                                  : Icons
                                                      .radio_button_unchecked,
                                              color: AppColors.buttonColor,
                                            ),
                                            SizedBox(width: 5.sp),
                                            Expanded(
                                              child: Text(
                                                item.name.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      AppColors.blackTextColor,
                                                ),
                                              ),
                                            ),
                                            // SizedBox(width: 120.sp),
                                            //const Spacer(),
                                            Text(
                                              formatCurrency(item.presentPrice),
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
                                    );
                                  },
                                ),
                                SizedBox(height: 5.sp),
                              ]);
                        }),
                    const Divider(
                      thickness: 1,
                    ),
                    CustomRowWithoutPadding(
                        title: "Tổng tạm tính",
                        value: formatCurrency(_sum),
                        textStyle: AppStyles.header600(fontsize: 12.sp)),
                    SizedBox(
                      height: 15.sp,
                    ),
                    if (_error != null)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Text(_error.toString(),
                            style: AppStyles.text400(
                                fontsize: 12.sp, color: Colors.red)),
                      ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              SizedBox(height: 15.sp),
              SizedBox(
                width: 300.w,
                height: 52.sp,
                child: ElevatedButton(
                  onPressed: () async {
                    _onContinue();
                  },
                  style: AppStyles.button16(),
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.sp,
              ),
            ],
          );
  }
}
