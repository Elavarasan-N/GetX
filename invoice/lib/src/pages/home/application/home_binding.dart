import 'package:get/get.dart';
import 'package:invoice/src/pages/home/application/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
