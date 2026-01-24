import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/core/cach/cach_manager.dart';
import 'package:rep_visit/screens/base_screen/providers/base_provider.dart';
import 'package:rep_visit/screens/doctors_screen/providers/doctors_provider.dart';
import 'package:rep_visit/screens/forget_password_screen/providers/forget_provider.dart';
import 'package:rep_visit/screens/home_screen/providers/home_provider.dart';
import 'package:rep_visit/screens/login_screen/providers/login_provider.dart';
import 'package:rep_visit/screens/profile_screen/provider/profile_provider.dart';
import 'package:rep_visit/screens/reports/provider/reports_provider.dart';
import 'package:rep_visit/screens/schedule_screen/provider/get_schedule_provider.dart';
import 'package:rep_visit/screens/tracking_screen/provider/tracking_provider.dart';

/// Utility class to handle logout operations
/// Disposes all controllers and clears all caches (except onboarding)
class LogoutUtility {
  /// Clear all caches except onboarding
  /// Note: UserCache.clearAll() already preserves onboarding
  static Future<void> clearAllCaches() async {
    await UserCache.clearAll();
  }

  /// Clear image cache
  static Future<void> clearImageCache() async {
    try {
      await CachedNetworkImage.evictFromCache('');
      // Clear all cached images
      final imageCache = PaintingBinding.instance.imageCache;
      imageCache.clear();
      imageCache.clearLiveImages();
    } catch (e) {
      // Ignore errors if cache clearing fails
    }
  }

  /// Clear all controllers and reset provider states
  static void disposeAllControllers(BuildContext context) {
    try {
      // ProfileProvider controllers
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.fullNameController.clear();
      profileProvider.phoneController.clear();
      profileProvider.currentPassController.clear();
      profileProvider.newPassController.clear();
      profileProvider.confirmPassController.clear();
      profileProvider.pickedImageFile = null;
      profileProvider.base64Image = null;
      profileProvider.user = null;
      profileProvider.fieldsInitialized = false;
      profileProvider.isEdit = false;
      profileProvider.isChangePassword = false;
      profileProvider.selectedTab = 0;
      profileProvider.filesList.clear();

      // LoginProvider controllers
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      loginProvider.empCodeController.clear();
      loginProvider.passController.clear();
      loginProvider.empFocus.unfocus();
      loginProvider.passFocus.unfocus();
      loginProvider.setIsRememberMe(false);

      // ForgetProvider controllers
      final forgetProvider =
          Provider.of<ForgetProvider>(context, listen: false);
      forgetProvider.emailController.clear();

      // DoctorsProvider controllers
      final doctorsProvider =
          Provider.of<DoctorsProvider>(context, listen: false);
      doctorsProvider.searchDoctorController.clear();
      doctorsProvider.doctorsList.clear();
      doctorsProvider.selectedDoctorIds.clear();
      doctorsProvider.searchQuery = '';
      doctorsProvider.selectedCategory = null;
      doctorsProvider.selectedSpeciality = null;
      doctorsProvider.selectedArea = null;
      doctorsProvider.openFilter = false;

      // ScheduleProvider controllers
      final scheduleProvider =
          Provider.of<ScheduleProvider>(context, listen: false);
      scheduleProvider.searchController.clear();
      scheduleProvider.listOfVisits.clear();
      scheduleProvider.listOfAddedSchedule.clear();
      scheduleProvider.doctorsList.clear();
      scheduleProvider.filteredDoctorsList.clear();
      scheduleProvider.selectedIndex = 0;

      // ReportsProvider controllers
      final reportsProvider =
          Provider.of<ReportsProvider>(context, listen: false);
      reportsProvider.noteController.clear();
      reportsProvider.date = '';
      reportsProvider.visits = 0;
      reportsProvider.duration = '';
      reportsProvider.distance = '';

      // TrackingProvider controllers and timers
      final trackingProvider =
          Provider.of<TrackingProvider>(context, listen: false);
      trackingProvider.clearAllState();

      // HomeProvider state
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.clearAllState();

      // BaseProvider state
      final baseProvider = Provider.of<BaseProvider>(context, listen: false);
      baseProvider.clearAllState();
    } catch (e) {
      // Ignore errors if provider is not available
    }
  }

  /// Complete logout process
  /// Disposes all controllers, clears caches (except onboarding), and clears image cache
  static Future<void> performLogout(BuildContext context) async {
    // Dispose all controllers
    disposeAllControllers(context);

    // Clear all caches (except onboarding)
    await clearAllCaches();

    // Clear image cache
    await clearImageCache();
  }
}
