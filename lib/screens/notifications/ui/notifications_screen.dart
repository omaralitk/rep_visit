import 'package:flutter/material.dart' hide Notification;
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/screens/notifications/models/notifications_model.dart';
import 'package:rep_visit/screens/notifications/providers/notifications_provider.dart';
import 'package:rep_visit/screens/notifications/ui/widgets/notifications_shimmer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<NotificationsProvider>(context, listen: false)
          .getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.fullHeight(context) * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextWidget(
                      "Notifications",
                      textSize: 24,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.fontColor,
                    ),
                    const SizedBox(width: 12),
                    Consumer<NotificationsProvider>(
                      builder: (context, provider, _) {
                        if (provider.unreadCount > 0) {
                          return Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: TextWidget(
                                provider.unreadCount.toString(),
                                textSize: 12,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.whiteColor,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Notifications list
          Expanded(
            child: Consumer<NotificationsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const NotificationsShimmer();
                }

                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextWidget(
                          provider.errorMessage!,
                          textSize: 14,
                          textColor: AppColors.red,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.getNotifications(),
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.notifications.isEmpty) {
                  return Center(
                    child: TextWidget(
                      "No notifications",
                      textSize: 14,
                      textColor: AppColors.typography500,
                    ),
                  );
                }

                // Display all notifications (both read and unread)
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: provider.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = provider.notifications[index];
                    final isUnread = provider.isUnread(notification);
                    // Build notification item - handles both read and unread states
                    return _buildNotificationItem(
                        notification, isUnread, provider);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    Notification notification,
    bool isUnread,
    NotificationsProvider provider,
  ) {
    // Get icon and color based on notification type
    IconData iconData;
    Color iconColor;

    switch (notification.type.toLowerCase()) {
      case 'rep_alert':
      case 'alert':
        iconData = Icons.info;
        iconColor = Colors.orange;
        break;
      case 'upcoming_meeting':
      case 'meeting':
        iconData = Icons.access_time;
        iconColor = AppColors.mainColor;
        break;
      case 'visit_completed':
      case 'completed':
        iconData = Icons.check_circle;
        iconColor = AppColors.mainColor;
        break;
      case 'system_update':
      case 'update':
        iconData = Icons.info;
        iconColor = AppColors.success;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppColors.mainColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.info50 : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? AppColors.mainColor.withOpacity(0.1)
              : AppColors.grey200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unread indicator dot
          if (isUnread)
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextWidget(
                        notification.title,
                        textSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.fontColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextWidget(
                      notification.createdAtHuman,
                      textSize: 12,
                      textColor: AppColors.typography500,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                TextWidget(
                  notification.message,
                  textSize: 14,
                  textColor: AppColors.typography700,
                  maxLine: 3,
                ),
                const SizedBox(height: 12),
                // Action buttons
                if (isUnread)
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          provider.readNotification(notification.id);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                        ),
                        child: TextWidget(
                          "Mark as read",
                          textSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.typography500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
