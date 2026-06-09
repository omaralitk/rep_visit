import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/screens/base_screen/providers/base_provider.dart';
import 'package:rep_visit/screens/doctors_screen/providers/doctors_provider.dart';
import 'package:rep_visit/screens/forget_password_screen/providers/forget_provider.dart';
import 'package:rep_visit/screens/home_screen/providers/day_status_provider.dart';
import 'package:rep_visit/screens/home_screen/providers/home_provider.dart';
import 'package:rep_visit/screens/login_screen/providers/login_provider.dart';
import 'package:rep_visit/screens/notifications/providers/notifications_provider.dart';
import 'package:rep_visit/screens/onboarding/providers/onboarding_provider.dart';
import 'package:rep_visit/screens/profile_screen/provider/profile_provider.dart';
import 'package:rep_visit/screens/reports/provider/reports_provider.dart';
import 'package:rep_visit/screens/schedule_screen/provider/get_schedule_provider.dart';
import 'package:rep_visit/screens/splash_screen/ui/splash_screen.dart';
import 'package:rep_visit/screens/tracking_screen/provider/tracking_provider.dart';

import 'core/navigation_service/navigation_service.dart';
import 'core/services/service_locator.dart';
import 'core/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // Initialize local notifications plugin for background isolate
  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await localNotifications.initialize(initSettings);

  // Create notification channel for Android
  if (Platform.isAndroid) {
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  const androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    enableVibration: true,
    playSound: true,
  );

  const iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const platformDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );

  final title =
      message.notification?.title ?? message.data['title'] ?? 'Notification';
  final body = message.notification?.body ??
      message.data['body'] ??
      message.data['message'] ??
      'New notification';

  await localNotifications.show(
    message.hashCode,
    title,
    body,
    platformDetails,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: Platform.isIOS
        ? const FirebaseOptions(
            apiKey: "AIzaSyDO9FNu2u5D3Dzs0dLUDnQZMWhX_zwiRRM",
            appId: "1:81415529499:ios:398c1268b4291aef3984be",
            messagingSenderId: "81415529499",
            projectId: "repvisit",
          )
        : null,
  );

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize notification service
  await NotificationService().init();

  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  ServiceLocator().setup();

  runApp(EasyLocalization(
      path: "assets/langs",
      supportedLocales: const [Locale("en"), Locale("ar")],
      fallbackLocale: const Locale("en"),
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
        ChangeNotifierProvider(create: (ctx) => DoctorsProvider()),
        ChangeNotifierProvider(create: (ctx) => ScheduleProvider()),
        ChangeNotifierProvider(create: (ctx) => TrackingProvider()),
        ChangeNotifierProvider(create: (ctx) => ProfileProvider()),
        ChangeNotifierProvider(create: (ctx) => NotificationsProvider()),
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
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.whiteColor,
            iconTheme: IconThemeData(color: AppColors.black),
            toolbarHeight: Dimensions.isTablet(context) ? 90 : 80,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
