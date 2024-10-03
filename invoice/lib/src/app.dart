import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/config/app_routes.dart';
import 'package:invoice/config/app_screens.dart';
import 'package:invoice/config/app_sizes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    globalStyle = AppStyle(
        screenSize: MediaQuery.of(context).size,
        orientation: MediaQuery.of(context).orientation);
    return GetMaterialApp(
      initialRoute: AppRoutes.home,
      debugShowCheckedModeBanner: false,
      getPages: AppScreens.appPages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      scaffoldMessengerKey: snackbarKey,
    );
  }
}
