import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel96_landlord/routes/routes.dart';
import 'package:hostel96_landlord/splash_screen.dart';
import 'package:hostel96_landlord/utils/connectivity/bindings.dart';
import 'package:hostel96_landlord/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: GetMaterialApp(
            themeMode: ThemeMode.system,
            theme: TAppTheme.lightTheme,
            darkTheme: TAppTheme.darkTheme,
            initialBinding: GeneralBinding(),
            getPages: AppRoutes.pages,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
