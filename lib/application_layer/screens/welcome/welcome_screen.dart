import 'dart:async';
import 'package:empiregarage_mobile/application_layer/screens/login/login_screen.dart';
import 'package:empiregarage_mobile/application_layer/screens/main_page/main_page.dart';
import 'package:empiregarage_mobile/common/jwt_interceptor.dart';
import 'package:empiregarage_mobile/services/brand_service/brand_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/colors.dart';

// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // ignore: prefer_typing_uninitialized_variables
  var _route;
  @override
  void initState() {
    _getBrands();
    _getToken();
    super.initState();
  }

  _getBrands() async {
    var json = await BrandService().getBrandsJson();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('brands', json);
  }

  _getToken() async {
    var token = await getJwtToken();
    if (!mounted) return;
    if (token != null) {
      _route = Get.off(() => const MainPage());
    } else {
      _route = Get.off(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () => _route);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.welcomeScreenBackGround,
        body: Center(
            child: SizedBox(
          width: 290,
          height: 106,
          child: Image.asset('assets/image/app-logo/empirelogo.png'),
        )),
      ),
    );
  }
}
