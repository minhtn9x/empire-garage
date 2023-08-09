import 'package:empiregarage_mobile/common/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';

class ChosePaymentMethod extends StatefulWidget {
  final Function excute;
  const ChosePaymentMethod({Key? key, required this.excute}) : super(key: key);

  @override
  State<ChosePaymentMethod> createState() => _ChosePaymentMethodState();
}

class _ChosePaymentMethodState extends State<ChosePaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Thanh toán",
          style: AppStyles.header600(fontsize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    Text(
                      "Phương thức thanh toán",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                    // const Spacer(),
                    // TextButton(
                    //   onPressed: () {},
                    //   child: Text(
                    //     "Thêm mới",
                    //     style: TextStyle(
                    //       fontFamily: 'Roboto',
                    //       fontSize: 12.sp,
                    //       fontWeight: FontWeight.w500,
                    //       color: AppColors.blueTextColor,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 5),
                              blurRadius: 20,
                              color: Colors.grey.shade300,
                              blurStyle: BlurStyle.outer)
                        ],
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          "assets/image/icon-logo/vnpay.png",
                          height: 50.h,
                          width: 50.w,
                        ),
                        title: Text(
                          "VNPay",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.radio_button_checked,
                          color: AppColors.buttonColor,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 5),
                              blurRadius: 20,
                              color: Colors.grey.shade300,
                              blurStyle: BlurStyle.outer)
                        ],
                      ),
                      child: ListTile(
                        leading: Image.asset(
                          "assets/image/icon-logo/paypal-icon.png",
                          height: 50.h,
                          width: 50.w,
                        ),
                        title: Text(
                          "Paypal",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackTextColor,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.radio_button_off,
                          color: AppColors.grey600,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
          Spacer(),
          Divider(thickness: 2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.sp),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.excute();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  fixedSize: Size.fromHeight(50.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
