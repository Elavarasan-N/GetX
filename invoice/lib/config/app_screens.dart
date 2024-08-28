import 'package:get/get.dart';
import 'package:invoice/config/app_routes.dart';
import 'package:invoice/src/pages/home/application/home_binding.dart';
import 'package:invoice/src/pages/home/ui/home_page.dart';

class AppScreens {
  static List<GetPage> appPages = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
