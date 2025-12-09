import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rep_visit/base/ui/widgets/loading_widget.dart';
import 'package:rep_visit/core/cach/cach_manager.dart';
import 'package:rep_visit/screens/login_screen/models/login_model.dart';
import 'package:rep_visit/screens/tracking_screen/models/traking_model.dart';
import 'package:rep_visit/screens/tracking_screen/repo/get_daily_visits_repo.dart';
import '../../../core/utilities/main_utilities.dart';

class TrackingProvider extends ChangeNotifier {
  bool isLoading = false;

  List<ScheduleVisits> allVisits = [];
  List<ScheduleVisits> pendingVisits = [];
  List<ScheduleVisits> completedVisits = [];

  int selectedTab = 0;

  /// Visit client-side state
  final Map<int, bool> visitActive = {};          // visitId -> active or not
  final Map<int, DateTime?> visitStartTime = {};  // visitId -> start datetime
  final Map<int, Duration> visitElapsed = {};     // visitId -> elapsed duration
  final Map<int, int> visitRating = {};           // visitId -> stars
  final Map<int, String> visitNotes = {};         // visitId -> notes
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
    // notifyListeners();

    GetDailyVisitsRepo().getVisits().then((val) {
      isLoading = false;

      if (val.success == 1) {
        allVisits = val.data;

        pendingVisits = allVisits
            .where((v) => v.status == "Pending" || v.status == "Started")
            .toList();

        completedVisits =
            allVisits.where((v) => v.status == "Completed").toList();

        _initializeVisitStateFromBackend();

        _ensureTimerRunning();
      }

      notifyListeners();
    });
  }

  /// Initialize local state based on visits data from backend
  void _initializeVisitStateFromBackend() {
    /// First: clean orphaned visitIds from memory
    final pendingIds = pendingVisits.map((v) => v.id).toList();

    visitActive.removeWhere((id, _) => !pendingIds.contains(id));
    visitStartTime.removeWhere((id, _) => !pendingIds.contains(id));
    visitElapsed.removeWhere((id, _) => !pendingIds.contains(id));
    visitRating.removeWhere((id, _) => !pendingIds.contains(id));
    visitNotes.removeWhere((id, _) => !pendingIds.contains(id));

    for (var v in pendingVisits) {
      visitRating.putIfAbsent(v.id, () => 0);
      visitElapsed.putIfAbsent(v.id, () => Duration.zero);
      visitStartTime.putIfAbsent(v.id, () => null);

      // *** IMPORTANT ***
      // Auto-activate visits backend marked as "Started"
      if (v.status == "Started") {
        visitActive[v.id] = true;

        // Backend doesn't provide start time → we start now
        visitStartTime[v.id] = DateTime.now();
      } else {
        visitActive.putIfAbsent(v.id, () => false);
      }
    }
  }

  /// -------------------- START VISIT --------------------
  Future<void> startVisit(BuildContext context, int visitId) async {
    LoadingWidget.show();
    EmpData userData = await UserCache.getEmpData();
    Position position = await MainUtilities.getPosition();

    final body = {
      "rep_id": userData.empcode,
      "daily_visit_id": visitId,
      "lat": position.latitude,
      "long": position.longitude
    };



    GetDailyVisitsRepo().startVisit(body).then((val) {
      LoadingWidget.hide();

      visitActive[visitId] = true;
      visitStartTime[visitId] = DateTime.now();
      visitElapsed[visitId] = Duration.zero;

      notesControllerFor(visitId);
      _ensureTimerRunning();
      notifyListeners();
    });
  }

  /// -------------------- END VISIT --------------------
  Future<void> endVisit(BuildContext context, int visitId) async {
    LoadingWidget.show();

    Position position = await MainUtilities.getPosition();

    final body = {
      "visit_id": visitId,
      "lat": position.latitude,
      "long": position.longitude,
      "rate": visitRating[visitId] ?? 0,
      "feedback": visitNotes[visitId] ?? "",
    };


    GetDailyVisitsRepo().endVisit(body).then((val) {
      LoadingWidget.hide();

      if (val.status == 1) {
        visitActive[visitId] = false;

        final start = visitStartTime[visitId];
        if (start != null) {
          visitElapsed[visitId] = DateTime.now().difference(start);
        }

        visitStartTime[visitId] = null;

        _moveToCompleted(visitId);
        _cleanupVisitState(visitId);

        _ensureTimerRunning();
        getVisits();

        notifyListeners();
      }
    });
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
