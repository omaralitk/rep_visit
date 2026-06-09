import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rep_visit/core/cach/cach_manager.dart';
import 'package:rep_visit/core/navigation_service/navigation_service.dart';
import 'package:rep_visit/screens/base_screen/ui/base_screen.dart';
import 'package:rep_visit/screens/notifications/ui/notifications_screen.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      debugPrint("🔔 Initializing NotificationService...");
      await _requestPermissions();
      await _initLocalNotifications();
      await _listenToFCMMessages();

      // Get and print FCM token for debugging
      final token = await getToken();
      debugPrint("🔔 ========================================");
      debugPrint("🔔 FCM TOKEN FOR THIS DEVICE:");
      debugPrint("🔔 $token");
      debugPrint("🔔 ========================================");
    } catch (e) {
      debugPrint("❌ Error initializing NotificationService: $e");
    }
  }

  /// Request permissions (Android 13 + iOS)
  Future<void> _requestPermissions() async {
    try {
      if (Platform.isIOS) {
        final status = await _messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        debugPrint("🔔 iOS Notification Permission: $status");
      } else if (Platform.isAndroid) {
        // Request Android 13+ notification permission using permission_handler
        if (await Permission.notification.isDenied) {
          final status = await Permission.notification.request();
          debugPrint("🔔 Android Notification Permission: $status");
        } else {
          debugPrint("🔔 Android Notification Permission: Already granted");
        }

        // Also request FCM permission
        final fcmStatus = await _messaging.requestPermission();
        debugPrint("🔔 FCM Permission: $fcmStatus");

        // Request local notification permission
        final androidImplementation =
            _localNotif.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        if (androidImplementation != null) {
          final localNotifStatus =
              await androidImplementation.requestNotificationsPermission();
          debugPrint("🔔 Local Notification Permission: $localNotifStatus");
        }
      }
    } catch (e) {
      debugPrint("❌ Error requesting permissions: $e");
    }
  }

  /// Init local notifications
  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotif.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap from local notification
        debugPrint("🔔 Local notification tapped: ${response.payload}");
        _handleNotificationTap(null);
      },
    );

    // Create notification channel for Android 8.0+
    if (Platform.isAndroid) {
      const androidChannel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await _localNotif
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(androidChannel);
    }
  }

  /// Listen to foreground notifications
  Future<void> _listenToFCMMessages() async {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint("🔔 Foreground message received!");
        debugPrint("🔔 Message ID: ${message.messageId}");
        debugPrint("🔔 Title: ${message.notification?.title}");
        debugPrint("🔔 Body: ${message.notification?.body}");
        debugPrint("🔔 Data: ${message.data}");
        _showLocalNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint("🔔 Notification opened app from background!");
        debugPrint("🔔 Message: ${message.messageId}");
        _handleNotificationTap(message);
      });

      // Check if app was opened from a notification (terminated state)
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
            "🔔 App opened from notification (terminated): ${initialMessage.messageId}");
        // Delay to ensure app is fully initialized
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleNotificationTap(initialMessage);
        });
      }

      debugPrint("🔔 FCM listeners set up successfully");
    } catch (e) {
      debugPrint("❌ Error setting up FCM listeners: $e");
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final title = message.notification?.title ??
          message.data['title'] ??
          'Notification';
      final body = message.notification?.body ??
          message.data['body'] ??
          message.data['message'] ??
          'New notification';

      debugPrint("🔔 Showing notification: $title - $body");

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

      await _localNotif.show(
        message.hashCode,
        title,
        body,
        platformDetails,
        payload: message.data.toString(),
      );

      debugPrint("🔔 Notification shown successfully");
    } catch (e) {
      debugPrint("❌ Error showing notification: $e");
    }
  }

  /// Get FCM token for this device
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      debugPrint("🔔 FCM Token retrieved successfully");
      print("🔔 ========================================");
      print("🔔 FCM TOKEN FOR THIS DEVICE:");
      print("🔔 $token");
      print("🔔 ========================================");
      return token;
    } catch (e) {
      debugPrint("❌ Error getting FCM token: $e");
      print("❌ Error getting FCM token: $e");
      return null;
    }
  }

  /// Handle notification tap - navigate to home and show NotificationsScreen
  Future<void> _handleNotificationTap(RemoteMessage? message) async {
    try {
      // Check if user is logged in
      final isLoggedIn = await UserCache.getIsLogin();

      if (!isLoggedIn) {
        debugPrint("🔔 User not logged in, skipping notification handling");
        return;
      }

      debugPrint("🔔 User is logged in, handling notification tap");

      // Mark that we should show the bottom sheet when context is ready
      _shouldShowNotificationSheet = true;

      // Navigate to BaseScreen (which shows HomeScreen by default)
      final context = NavigationService.navigatorKey.currentContext;
      if (context != null) {
        // Navigate to BaseScreen if not already there
        NavigationService.pushAndRemoveUntil(const BaseScreen());

        // Wait a bit for navigation to complete, then show NotificationsScreen as bottom sheet
        Future.delayed(const Duration(milliseconds: 300), () {
          final newContext = NavigationService.navigatorKey.currentContext;
          if (newContext != null && _shouldShowNotificationSheet) {
            _showNotificationsScreen(newContext);
            _shouldShowNotificationSheet = false; // Reset flag
          }
        });
      } else {
        debugPrint("🔔 Context not available, will handle later");
        // Store message for later handling when context is available
        _pendingNotification = message;
      }
    } catch (e) {
      debugPrint("❌ Error handling notification tap: $e");
    }
  }

  RemoteMessage? _pendingNotification;
  bool _shouldShowNotificationSheet = false;

  /// Show NotificationsScreen as bottom sheet
  /// Only called when a notification is actually tapped
  void _showNotificationsScreen(BuildContext context) {
    if (!_shouldShowNotificationSheet) {
      debugPrint(
          "🔔 Not showing notification sheet - no notification was tapped");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const NotificationsScreen();
      },
    );

    // Clear flags
    _pendingNotification = null;
    _shouldShowNotificationSheet = false;
  }

  /// Call this method when app context is ready (e.g., from main.dart after app initialization)
  /// Only handles if there's actually a pending notification
  void handlePendingNotification() {
    if (_pendingNotification != null) {
      final context = NavigationService.navigatorKey.currentContext;
      if (context != null) {
        _handleNotificationTap(_pendingNotification);
        _pendingNotification = null; // Clear after handling
      }
    }
  }
}
