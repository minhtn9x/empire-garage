import 'package:empiregarage_mobile/application_layer/screens/login/login_screen.dart';
import 'package:empiregarage_mobile/common/style.dart';
import 'package:empiregarage_mobile/services/authen_firebase_services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../common/colors.dart';

class OtpConfirmation extends StatefulWidget {
  final String countryCode;
  final String phoneNumber;
  const OtpConfirmation(
      {Key? key, required this.countryCode, required this.phoneNumber})
      : super(key: key);

  @override
  State<OtpConfirmation> createState() => _OtpConfirmationState();
}

class _OtpConfirmationState extends State<OtpConfirmation> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _loading = false;
  String _error = "";

  @override
  Widget build(BuildContext context) {
    var otpCode = "";
    bool resentOTP = false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.loginScreenBackGround,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 88.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nhập mã OTP",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                RichText(
                  text: TextSpan(
                    text:
                        "Vui lòng nhập mã xác minh được gửi đến điện thoại di động của bạn ",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackTextColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            widget.phoneNumber.replaceRange(0, 6, "*** ***"),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Pinput(
                  length: 6,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  // ignore: avoid_print
                  onCompleted: (pin) => print(pin),
                  onChanged: (value) {
                    otpCode = value;
                  },
                ),
                SizedBox(
                  height: 50.h,
                  child: Center(
                    child: Text(
                      _error,
                      overflow: TextOverflow.ellipsis,
                      style:
                          AppStyles.text400(fontsize: 12.sp, color: Colors.red),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: !_loading
                          ? ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _loading = true;
                                  // _error = "";
                                });
                                var message = await AppAuthentication()
                                    .confirmOTP(otpCode, auth, context);
                                if (message != "") {
                                  setState(() {
                                    _error = message;
                                    _loading = false;
                                  });
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
                                'Xác nhận',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                fixedSize: Size.fromHeight(50.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const SpinKitThreeBounce(
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                    ),
                  ],
                ),
              
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.off(() => const LoginScreen());
                      },
                      child: Text(
                        "Thay đổi số điện thoại",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        if (!resentOTP) {
                          await AppAuthentication().sendOTP(
                            context,
                            widget.countryCode,
                            widget.phoneNumber,
                          );
                          setState(() {
                            resentOTP == true;
                          });
                        }
                      },
                      child: Text(
                        "Gửi lại mã",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[500],
                          fontFamily: 'Roboto',
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
