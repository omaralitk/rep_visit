import 'package:flutter/material.dart' hide Notification;
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/screens/notifications/models/notifications_model.dart';
import 'package:rep_visit/screens/notifications/repo/notifications_repo.dart';

class NotificationsProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Notification> notifications = [];
  int unreadCount = 0;
  String? errorMessage;

  Future<void> getNotifications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final val = await NotificationsRepo().getNotifications();
      isLoading = false;
      if (val.success == 1) {
        notifications = val.data?.notifications ?? [];
        // Calculate unread count from notifications list
        unreadCount = notifications.where((n) => n.readAt == null).length;
        errorMessage = null;
      } else {
        notifications = [];
        unreadCount = 0;
        errorMessage =
            val.msg.isNotEmpty ? val.msg : "Failed to load notifications";
      }
    } catch (e) {
      isLoading = false;
      notifications = [];
      unreadCount = 0;
      errorMessage = "Network error, please try again";
    }

    notifyListeners();
  }

  bool isUnread(Notification notification) {
    return notification.readAt == null;
  }

  void markAsRead(String notificationId) async {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && notifications[index].readAt == null) {
      // Mark as read by setting readAt to current time
      final updatedNotification = Notification(
        id: notifications[index].id,
        type: notifications[index].type,
        title: notifications[index].title,
        message: notifications[index].message,
        doctorName: notifications[index].doctorName,
        doctorId: notifications[index].doctorId,
        visitDate: notifications[index].visitDate,
        visitTime: notifications[index].visitTime,
        visitId: notifications[index].visitId,
        notes: notifications[index].notes,
        createdAt: notifications[index].createdAt,
        createdAtHuman: notifications[index].createdAtHuman,
        status: notifications[index].status,
        reviewerName: notifications[index].reviewerName,
        reviewerType: notifications[index].reviewerType,
        rejectionReason: notifications[index].rejectionReason,
        decisionDate: notifications[index].decisionDate,
        readAt: DateTime.now(), // Mark as read
      );
      notifications[index] = updatedNotification;

      // Recalculate unread count
      unreadCount = notifications.where((n) => n.readAt == null).length;

      notifyListeners();
    }
  }

  Future<void> readNotification(String notificationId) async {
    try {
      final val = await NotificationsRepo().readNotification(notificationId);
      if (val.status == 1) {
        ToastService.showSuccess(val.msg);
        markAsRead(notificationId);
      } else {
        ToastService.showError(val.msg.isNotEmpty
            ? val.msg
            : "Failed to mark notification as read");
      }
    } catch (e) {
      ToastService.showError("Error marking notification as read: $e");
    }
  }
}
