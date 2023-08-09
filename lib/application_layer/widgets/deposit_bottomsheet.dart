import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/colors.dart';

class DepositBottomSheet extends StatelessWidget {
  const DepositBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575), //background color
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //color of shadow
              spreadRadius: 5, //spread radius
              blurRadius: 7, // blur radius
              offset: const Offset(0, 2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Tại sao phải trả phí đặt chỗ ? ",
                style: TextStyle(
                  
                  fontFamily: 'Roboto',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackTextColor,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Chúng ta vẫn biết rằng, "
                "làm việc với một đoạn văn bản dễ đọc và rõ nghĩa "
                "dễ gây rối trí và cản trở việc tập trung vào yếu tố trình bày văn bản. "
                "Lorem Ipsum có ưu điểm hơn so với đoạn văn bản chỉ gồm nội dung kiểu Nội dung, nội dung, nội dung "
                "là nó khiến văn bản giống thật hơn, bình thường hơn. Nhiều phần mềm thiết kế giao diện web và dàn trang ngày "
                "nay đã sử dụng Lorem Ipsum làm đoạn văn bản giả, và nếu bạn thử tìm các đoạn Lorem ipsum"
                " trên mạng thì sẽ khám phá ra nhiều trang web hiện vẫn đang trong quá trình xây dựng. Có nhiều phiên bản khác nhau"
                " đã xuất hiện, đôi khi do vô tình, nhiều khi do cố ý (xen thêm vào những câu hài hước hay thông tục)",
                textAlign: TextAlign.left,
                style: TextStyle(
                  height: 1.5,
                  fontFamily: 'Roboto',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightTextColor,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.grey100,width: 2)
                  )
                ),
                margin: EdgeInsets.all(10.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left:20,right: 20,top: 10),
                        child: ElevatedButton(
                          onPressed: () => Get.back(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonColor,
                            fixedSize: Size.fromHeight(55.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Tôi đã hiểu',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
