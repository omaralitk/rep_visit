import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/screens/base_screen/providers/base_provider.dart';
import 'package:rep_visit/screens/base_screen/ui/base_screen.dart';
import 'package:rep_visit/screens/forget_password_screen/providers/forget_provider.dart';
import 'package:rep_visit/screens/home_screen/providers/day_status_provider.dart';
import 'package:rep_visit/screens/home_screen/providers/home_provider.dart';
import 'package:rep_visit/screens/login_screen/providers/login_provider.dart';
import 'package:rep_visit/screens/login_screen/ui/login_screen.dart';
import 'package:rep_visit/screens/onboarding/providers/onboarding_provider.dart';
import 'package:rep_visit/screens/reports/provider/reports_provider.dart';
import 'package:rep_visit/screens/splash_screen/ui/splash_screen.dart';

import 'core/navigation_service/navigation_service.dart';
import 'core/service_locator/service_locator.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  ServiceLocator().setup();

  runApp(EasyLocalization(
      path: "assets/langs",
      supportedLocales: [Locale("en"), Locale("ar")],
      fallbackLocale: Locale("en"),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => OnboardingProvider()),
        ChangeNotifierProvider(create: (ctx) => LoginProvider()),
        ChangeNotifierProvider(create: (ctx) => ForgetProvider()),
        ChangeNotifierProvider(create: (ctx) => BaseProvider()),
        ChangeNotifierProvider(create: (ctx) => HomeProvider()),
        ChangeNotifierProvider(create: (ctx) => DayStatusProvider()),
        ChangeNotifierProvider(create: (ctx) => ReportsProvider()),
      ],
      child: MaterialApp(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        title: 'RepVisit',
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.whiteColor,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
          useMaterial3: true,
          appBarTheme:  AppBarTheme(
            backgroundColor: AppColors.whiteColor,
            iconTheme: IconThemeData(color: AppColors.black),
           toolbarHeight: Dimensions.isTablet(context)?90:80,
            elevation: 0,
          ),
        ),
        // home: LoginScreen(),
        home: const SplashScreen(),
        // home: const BaseScreen(),
      ),
    );
  }
}
