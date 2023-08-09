import 'package:get/get.dart';

import '../application_layer/screens/welcome/welcome_screen.dart';

class RouteClass {
  static String welcomeScreen = "/";

  static getWelcomeScreenRoute() => welcomeScreen;

  static List<GetPage> routes = [
    GetPage(name: welcomeScreen, page: () => const WelcomeScreen()),
  ];
}
