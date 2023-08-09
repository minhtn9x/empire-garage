import 'dart:convert';

import 'package:empiregarage_mobile/application_layer/screens/activities/service_activity_detail.dart';
import 'package:empiregarage_mobile/application_layer/screens/booking/booking_detail_v2.dart';
import 'package:empiregarage_mobile/application_layer/screens/welcome/welcome_screen.dart';
import 'package:empiregarage_mobile/application_layer/widgets/error_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'application_layer/on_going_service/on_going_service.dart';
import 'application_layer/screens/main_page/main_page.dart';
import 'firebase_options.dart';

// ignore: depend_on_referenced_packages

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
      const GetMaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        print(message);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        var title = message.notification!.title.toString();
        var body = message.notification!.body.toString();
        if (kDebugMode) {
          print(message.notification!.body);
          print(message.notification!.title);
        }
        Get.snackbar(title, body,
            icon: Image.asset(
              'assets/image/app-logo/launcher.png',
              height: 30,
              width: 30,
            ),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.white.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15));
        final routeFromMessage = message.data["route"];
        var jsonRoute = jsonDecode(routeFromMessage);
        Get.offAll(() => const MainPage());
        switch (jsonRoute['route']) {
          case "qr-checkin-success":
            if (jsonRoute['orderServiceId'] != null) {
              Get.to(() => OnGoingService(
                    servicesId: jsonRoute['orderServiceId'] as int,
                  ));
            } else {
              Get.to(() =>
                  BookingDetailv2(bookingId: jsonRoute['bookingId'] as int));
            }
            break;
          case "diagnose-success":
            Get.to(() => OnGoingService(
                  servicesId: jsonRoute['orderServiceId'] as int,
                ));
            break;
          case "repair-success":
            Get.to(() => OnGoingService(
                  servicesId: jsonRoute['orderServiceId'] as int,
                ));
            break;
          case "checkout-success":
            Get.to(() => ServiceActivityDetail(
                orderServicesId: jsonRoute['orderServiceId'] as int));
            break;
          default:
        }
      }
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      final routeFromMessage = message.data["route"];
      print(message);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return CustomError(errorDetails: errorDetails);
        };
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme

          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018
                .apply(fontSizeFactor: 1.sp, bodyColor: Colors.black),
          ),
          home: child,
        );
      },
      child: const WelcomeScreen(),
    );
  }
}
