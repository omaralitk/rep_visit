import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rep_visit/base/ui/widgets/loading_widget.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/core/cach/cach_manager.dart';
import 'package:rep_visit/screens/login_screen/models/login_model.dart';
import 'package:rep_visit/screens/tracking_screen/models/traking_model.dart';
import 'package:rep_visit/screens/tracking_screen/repo/get_daily_visits_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../base/ui/widgets/custom_toast.dart';
import '../../../core/utilities/main_utilities.dart';

class TrackingProvider extends ChangeNotifier {
  bool isLoading = false;

  List<ScheduleVisits> allVisits = [];
  List<ScheduleVisits> pendingVisits = [];
  List<ScheduleVisits> completedVisits = [];

  int selectedTab = 0;

  /// Visit client-side state
  final Map<int, bool> visitActive = {};
  final Map<int, DateTime?> visitStartTime = {};
  final Map<int, Duration> visitElapsed = {};
  final Map<int, int> visitRating = {};
  final Map<int, String> visitNotes = {};
  final Map<int, TextEditingController> _notesControllers = {};

  Timer? _tickTimer;

  /// Change tab (Pending / Completed)
  void changeTab(int index) {
    selectedTab = index;
    notifyListeners();
  }

  /// Notes Controller
  TextEditingController notesControllerFor(int visitId) {
    if (!_notesControllers.containsKey(visitId)) {
      final ctrl = TextEditingController(text: visitNotes[visitId] ?? '');
      _notesControllers[visitId] = ctrl;
      ctrl.addListener(() {
        visitNotes[visitId] = ctrl.text;
      });
    }
    return _notesControllers[visitId]!;
  }

  /// -------------------- GET VISITS --------------------
  Future<void> getVisits() async {
    isLoading = true;
    notifyListeners();

    try {
      final val = await GetDailyVisitsRepo().getVisits();
      isLoading = false;

      if (val.success == 1) {
        allVisits.clear();
        pendingVisits.clear();
        completedVisits.clear();
        allVisits = val.data;


        pendingVisits = allVisits
            .where((v) => v.status == "Pending" || v.status == "Started" || v.status=="Available")
            .toList();

        completedVisits =
            allVisits.where((v) => v.status == "Completed").toList();

        _initializeVisitStateFromBackend();

        _ensureTimerRunning();
      }

      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      // Error is handled, loading state is reset
    }
  }

  /// Initialize local state based on visits data from backend
  void _initializeVisitStateFromBackend() {
    /// First: clean orphaned visitIds from memory
    final pendingIds = pendingVisits.map((v) => v.id).toList();

    // Store existing state for visits that are already active
    final Map<int, DateTime?> preservedStartTimes = {};
    final Map<int, Duration> preservedElapsed = {};
    
    // Preserve start times and elapsed times for visits that are still pending
    for (var visitId in pendingIds) {
      if (visitActive[visitId] == true && visitStartTime[visitId] != null) {
        preservedStartTimes[visitId??0] = visitStartTime[visitId];
        // Calculate current elapsed time before clearing
        if (visitStartTime[visitId] != null) {
          preservedElapsed[visitId??0] = DateTime.now().difference(visitStartTime[visitId]!);
        }
      }
    }

    visitActive.removeWhere((id, _) => !pendingIds.contains(id));
    visitStartTime.removeWhere((id, _) => !pendingIds.contains(id));
    visitElapsed.removeWhere((id, _) => !pendingIds.contains(id));
    visitRating.removeWhere((id, _) => !pendingIds.contains(id));
    visitNotes.removeWhere((id, _) => !pendingIds.contains(id));

    for (var v in pendingVisits) {
      visitRating.putIfAbsent(v.id??0, () => 0);
      
      // *** IMPORTANT ***
      // Auto-activate visits backend marked as "Started"
      if (v.status == "Started") {
        visitActive[v.id??0] = true;

        // Preserve existing start time if visit was already active
        // Otherwise, set new start time
        if (preservedStartTimes.containsKey(v.id) && preservedStartTimes[v.id] != null) {
          // Restore preserved start time to continue timer
          visitStartTime[v.id??0] = preservedStartTimes[v.id];
          // Restore preserved elapsed time
          visitElapsed[v.id??0] = preservedElapsed[v.id] ?? Duration.zero;
        } else {
          // New visit being started - set start time to now
          final now = DateTime.now();

          if (v.elapsedTime != null && v.elapsedTime!.isNotEmpty) {
            final elapsed = parseElapsedTime(v.elapsedTime!);

            visitStartTime[v.id ?? 0] = now.subtract(elapsed);
            visitElapsed[v.id ?? 0] = elapsed;
          } else {
            visitStartTime[v.id ?? 0] = now;
            visitElapsed[v.id ?? 0] = Duration.zero;
          }
        }
      } else {
        visitActive.putIfAbsent(v.id??0, () => false);
        visitElapsed.putIfAbsent(v.id??0, () => Duration.zero);
        visitStartTime.putIfAbsent(v.id??0, () => null);
      }
    }
  }

  /// Check location permission status
  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Show permission denied dialog
  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: TextWidget(
            "Location Permission Required".tr(),
            textSize: 18,
            fontWeight: FontWeight.bold,
            textColor: AppColors.fontColor,
          ),
          content: TextWidget(
            "Location permission is required to start a visit. Please enable location permission in settings."
                .tr(),
            textSize: 14,
            textColor: AppColors.typography500,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: TextWidget(
                "Cancel".tr(),
                textSize: 14,
                textColor: AppColors.typography500,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                foregroundColor: Colors.white,
              ),
              child: TextWidget(
                "Go to Settings".tr(),
                textSize: 14,
                fontWeight: FontWeight.w600,
                textColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  /// -------------------- START VISIT --------------------
  Future<void> startVisit(BuildContext context, int visitId) async {
    final hasPermission = await checkLocationPermission();

    if (!hasPermission) {
      _showPermissionDeniedDialog(context);
      return;
    }

    LoadingWidget.show();

    try {
      EmpData userData = await UserCache.getEmpData();
      Position position = await MainUtilities.getPosition();

      final body = {
        "rep_id": userData.empcode,
        "daily_visit_id": visitId,
        "lat": position.latitude,
        "long": position.longitude
      };

      final val = await GetDailyVisitsRepo().startVisit(body);

      LoadingWidget.hide();

      /// 🔥 هون الحل
      if (val.status != 1) {

        ToastService.showError(val.msg);

        return;
      }

      /// ✅ فقط إذا نجح
      visitActive[visitId] = true;
      visitStartTime[visitId] = DateTime.now();
      visitElapsed[visitId] = Duration.zero;

      notesControllerFor(visitId);
      _ensureTimerRunning();
      notifyListeners();

    } catch (e) {
      LoadingWidget.hide();

      if (e.toString().contains('denied')) {
        _showPermissionDeniedDialog(context);
      } else {
        ToastService.showError("Unexpected error");
      }
    }
  }
  /// -------------------- END VISIT --------------------
  Future<void> endVisit(BuildContext context, int visitId) async {
    LoadingWidget.show();

    try {
      Position position = await MainUtilities.getPosition();

      final body = {
        "daily_visit_id": visitId,
        "lat": position.latitude,
        "long": position.longitude,
        "rate": visitRating[visitId] ?? 0,
        "feedback": visitNotes[visitId] ?? "",
      };


      final val = await GetDailyVisitsRepo().endVisit(body);

      LoadingWidget.hide();

      /// ❌ فشل من السيرفر
      if (val.status != 1) {
        ToastService.showError(val.msg ?? "Failed to end visit");
        return;
      }

      /// ✅ نجاح
      visitActive[visitId] = false;

      final start = visitStartTime[visitId];
      if (start != null) {
        visitElapsed[visitId] = DateTime.now().difference(start);
      }

      visitStartTime[visitId] = null;

      _moveToCompleted(visitId);
      _cleanupVisitState(visitId);

      _ensureTimerRunning();
      await getVisits();

      notifyListeners();

    } catch (e) {
      LoadingWidget.hide();

      if (e.toString().contains('denied')) {
        _showPermissionDeniedDialog(context);
      } else {
        ToastService.showError("Unexpected error");
      }
    }
  }

  /// Move visit to completed list
  void _moveToCompleted(int visitId) {
    final index = pendingVisits.indexWhere((v) => v.id == visitId);
    if (index != -1) {
      completedVisits.add(pendingVisits[index]);
      pendingVisits.removeAt(index);
    }
  }

  /// Remove local tracking state for completed visit
  void _cleanupVisitState(int visitId) {
    _notesControllers[visitId]?.dispose();
    _notesControllers.remove(visitId);

    visitNotes.remove(visitId);
    visitRating.remove(visitId);
    visitActive.remove(visitId);
    visitStartTime.remove(visitId);
    visitElapsed.remove(visitId);
  }

  /// -------------------- RATING --------------------
  void setRating(int visitId, int rating) {
    visitRating[visitId] = rating.clamp(0, 5);
    notifyListeners();
  }

  /// -------------------- NOTES --------------------
  void setNotes(int visitId, String text) {
    visitNotes[visitId] = text;
    if (_notesControllers.containsKey(visitId)) {
      if (_notesControllers[visitId]!.text != text) {
        _notesControllers[visitId]!.text = text;
      }
    }
    notifyListeners();
  }

  /// -------------------- TIMER MANAGEMENT --------------------
  void _ensureTimerRunning() {
    final anyActive = visitActive.values.any((v) => v == true);

    if (anyActive) {
      if (_tickTimer == null || !_tickTimer!.isActive) {
        _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          final now = DateTime.now();
          visitStartTime.forEach((id, start) {
            if (start != null && visitActive[id] == true) {
              visitElapsed[id] = now.difference(start);
            }
          });
          notifyListeners();
        });
      }
    } else {
      _tickTimer?.cancel();
      _tickTimer = null;
    }
  }
  Duration parseElapsedTime(String time) {
    final parts = time.split(':');

    if (parts.length != 3) return Duration.zero;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );
  }
  /// Clear all state (for logout)
  void clearAllState() {
    _tickTimer?.cancel();
    _tickTimer = null;
    for (var c in _notesControllers.values) {
      c.dispose();
    }
    _notesControllers.clear();
    allVisits.clear();
    pendingVisits.clear();
    completedVisits.clear();
    visitActive.clear();
    visitStartTime.clear();
    visitElapsed.clear();
    visitRating.clear();
    visitNotes.clear();
    notifyListeners();
  }

  /// Clean up
  @override
  void dispose() {
    _tickTimer?.cancel();
    for (var c in _notesControllers.values) {
      c.dispose();
    }
    _notesControllers.clear();
    super.dispose();
  }

}
