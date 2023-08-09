import 'package:empiregarage_mobile/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  static String fontFamily = 'Roboto';

  static TextStyle text400({double fontsize = 16, Color color = Colors.black}) {
    return TextStyle(
      fontSize: fontsize,
      fontWeight: FontWeight.w400,
      fontFamily: fontFamily,
      color: color,
    );
  }

  static Widget divider(
      {EdgeInsetsGeometry padding =
          const EdgeInsets.symmetric(horizontal: 10)}) {
    return SizedBox(
      height: 10.sp,
      child: Center(
          child: Padding(
        padding: padding,
        child: const Divider(
          thickness: 1,
        ),
      )),
    );
  }

  static TextStyle header600(
      {double fontsize = 16, Color color = Colors.black}) {
    return TextStyle(
      fontSize: fontsize,
      fontWeight: FontWeight.w600,
      fontFamily: fontFamily,
      color: color,
    );
  }

  static InputDecoration textbox12(
      {String hintText = "Nhập",
      hintTextColor = const Color.fromARGB(255, 158, 168, 158),
      Icon? suffixIcon,
      String? errorText}) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: AppStyles.text400(fontsize: 12.sp, color: hintTextColor),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: AppColors.blue600, width: 2)),
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        suffixIcon: suffixIcon,
        errorText: errorText);
  }

  static ButtonStyle button16({color = const Color(0xFF2C53D2)}) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      fixedSize: Size.fromHeight(55.sp),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
