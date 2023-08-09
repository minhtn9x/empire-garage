import 'package:empiregarage_mobile/common/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/colors.dart';

class BottomPopup extends StatelessWidget {
  final String image;
  final String title;
  final String body;
  final Function()? action;
  final String buttonTitle;
  final Widget? addition;
  const BottomPopup(
      {Key? key,
      required this.image,
      required this.title,
      required this.body,
      this.action,
      this.addition,
      required this.buttonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 160.h,
                      width: 160.h,
                      child: Image.asset(
                        image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SFProDisplay',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                  Center(
                    child: Text(
                      body,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                        fontFamily: 'SFProDisplay',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackTextColor,
                      ),
                    ),
                  ),
                  if (addition != null) addition!
                ],
              ),
            ),
          ),
          Column(
            children: [
              const Divider(thickness: 1),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: action,
                        style: AppStyles.button16(),
                        child: Text(
                          buttonTitle,
                          style: TextStyle(
                            fontFamily: 'SFProDisplay',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
