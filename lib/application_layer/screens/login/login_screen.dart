import 'package:empiregarage_mobile/services/authen_firebase_services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../common/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  static String countryCode = "+84";
  var phoneNumber = "";
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.loginScreenBackGround,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 88.h,
                    ),
                    Text(
                      "Đăng nhập",
                      style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blackTextColor,
                          fontFamily: 'Roboto'),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "Vui lòng nhập số điện thoại của bạn để tiếp tục",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackTextColor,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    // Text(
                    //   "Số điện thoại",
                    //   style: TextStyle(
                    //     fontFamily: 'Roboto',
                    //     fontSize: 17.sp,
                    //     fontWeight: FontWeight.w400,
                    //     color: AppColors.lightTextColor,
                    //   ),
                    // ),
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Số điện thoại không được để trống !';
                            }
                            if (value.toString().startsWith('0')) {
                              value =
                                  value.toString().substring(1, value.length);
                            }
                            if (value.length > 9 || value.length < 9) {
                              return 'Số điện thoại không hợp lệ !';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.toString().startsWith('0')) {
                              value =
                                  value.toString().substring(1, value.length);
                            }
                            setState(() {
                              phoneNumber = value;
                            });
                          },
                          decoration: InputDecoration(
                            prefixIcon: Container(
                              width: 24,
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                    "assets/image/icon-logo/vietnamflag.png"),
                              ),
                            ),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: AppColors.grey200),
                                borderRadius: BorderRadius.circular(16)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 3, color: AppColors.buttonColor),
                                borderRadius: BorderRadius.circular(16)),
                            hintText: "Nhập số điện thoại của bạn",
                            hintStyle: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.grey400),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: !_loading
                              ? ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      var message = await AppAuthentication()
                                          .sendOTP(context, countryCode,
                                              phoneNumber);
                                      if (message != "") {
                                        setState(() {
                                          _loading = false;
                                        });
                                      }
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
                                    'Nhận mã OTP',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonColor,
                                    fixedSize: Size.fromHeight(50.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20,
                                  )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
