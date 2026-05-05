import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:rep_visit/screens/doctors_screen/models/doctors_model.dart'
    as doctors_model;
import 'package:rep_visit/screens/doctors_screen/models/filters_model.dart';
import 'package:rep_visit/screens/doctors_screen/models/my_doctors_model.dart';
import 'package:rep_visit/screens/doctors_screen/repo/doctors_repo.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';

class DoctorsProvider extends ChangeNotifier {
  List<doctors_model.Datum> doctorsList = [];
  List<doctors_model.Datum> _allDoctorsList =
      []; // Store all doctors for local filtering
  bool isLoading = false;
  bool isSearching = false; // Separate loading state for search

  String? selectedCategory;
  String? selectedSpeciality;
  String? selectedArea;
  String searchQuery = '';

  Future<void> getDoctorsList() async {
    isLoading = true;
    notifyListeners();
    try {
      final val = await DoctorsRepo().getDoctors(
        category: selectedCategory,
        speciality: selectedSpeciality,
        area: selectedArea,
        search: null, // Don't send search to API, filter locally
      );
      isLoading = false;

      if (val.status == 1) {
        _allDoctorsList = val.data??[]; // Store all doctors
        _applyFilters(); // Apply local search and filters
      } else {
        _allDoctorsList.clear();
        doctorsList.clear();
      }
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Apply local filters (search, category, speciality, area)
  void _applyFilters() {
    List<doctors_model.Datum> filtered = List.from(_allDoctorsList);

    // Apply search filter (local) - from first character
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      filtered = filtered.where((doctor) {
        return (doctor.name?.toLowerCase().contains(query)??false) ||
            (doctor.speciality?.toLowerCase().contains(query)??false) ||
            ( doctor.hospitalName?.toLowerCase().contains(query)??false) ||
            (doctor.address?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply category filter
    if (selectedCategory != null &&
        selectedCategory!.isNotEmpty &&
        selectedCategory != 'All'.tr()) {
      filtered = filtered.where((doctor) {
        return doctor.datumClass == selectedCategory;
      }).toList();
    }

    // Apply speciality filter
    if (selectedSpeciality != null &&
        selectedSpeciality!.isNotEmpty &&
        selectedSpeciality != 'All'.tr()) {
      filtered = filtered.where((doctor) {
        return doctor.speciality == selectedSpeciality;
      }).toList();
    }

    // Apply area filter
    if (selectedArea != null &&
        selectedArea!.isNotEmpty &&
        selectedArea != 'All'.tr()) {
      filtered = filtered.where((doctor) {
        return doctor.address
                ?.toLowerCase()
                .contains(selectedArea!.toLowerCase()) ??
            false;
      }).toList();
    }

    doctorsList = filtered;
  }

  int selectedIndex = 0;

  setSelectedTap(int val) {
    selectedIndex = val;
    notifyListeners();
  }

  bool openFilter = false;

  setOpenFilter(bool val) {
    openFilter = val;
    notifyListeners();
  }

  void setCategory(String? value) {
    if (value == null || value == 'All'.tr()) {
      selectedCategory = null;
    } else {
      // Find the value from categories list
      try {
        final category = categories.firstWhere((e) => e.label == value);
        selectedCategory = category.value;
      } catch (_) {
        // If not found, set to null
        selectedCategory = null;
      }
    }
    // Apply filters locally instead of calling API
    _applyFilters();
    notifyListeners();
  }

  void setSpeciality(String? value) {
    if (value == null || value == 'All'.tr()) {
      selectedSpeciality = null;
    } else {
      // Find the value from specialities list
      try {
        final speciality = specialities.firstWhere((e) => e.label == value);
        selectedSpeciality = speciality.value;
      } catch (_) {
        // If not found, set to null
        selectedSpeciality = null;
      }
    }
    // Apply filters locally instead of calling API
    _applyFilters();
    notifyListeners();
  }

  void setArea(String? value) {
    if (value == null || value == 'All'.tr()) {
      selectedArea = null;
    } else {
      // Find the value from areas list
      try {
        final area = areas.firstWhere((e) => e.label == value);
        selectedArea = area.value;
      } catch (_) {
        // If not found, set to null
        selectedArea = null;
      }
    }
    // Apply filters locally instead of calling API
    _applyFilters();
    notifyListeners();
  }

  void setSearch(String value) {
    searchQuery = value;
    _applyFilters(); // Apply local filter immediately
    notifyListeners();
  }

  Future<void> searchDoctors() async {
    // Local filtering - no API call needed
    isSearching = true;
    notifyListeners();

    // Simulate slight delay for better UX
    await Future.delayed(const Duration(milliseconds: 200));

    _applyFilters(); // Apply local filters

    isSearching = false;
    notifyListeners();
  }

  Future<void> saveDoctorSchedule(Map<String, dynamic> body) async {
    isLoading = true;
    notifyListeners();
    try {
      final val = await DoctorsRepo().saveDoctorSchedule(body);
      isLoading = false;
      if (val.success == 1) {
        ToastService.showSuccess(val.msg);
      } else {
        ToastService.showError(val.msg);
      }
      notifyListeners();
    } catch (e) {
      isLoading = false;
      ToastService.showError("Error saving schedule".tr() + ": $e");
      notifyListeners();
    }
  }

  /// Save bulk schedule - validation and request building in provider
  Future<bool> saveBulkSchedule({
    required int doctorId,
    required List<String> selectedDays,
    required String time,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Validation
    if (selectedDays.isEmpty) {
      ToastService.showError('Please select at least one day'.tr());
      return false;
    }

    if (endDate.isBefore(startDate)) {
      ToastService.showError('End date must be after start date'.tr());
      return false;
    }

    // Prepare request body
    final requestBody = {
      "doctor_id": doctorId,
      "schedule_type": "bulk",
      "days": selectedDays,
      "time": time,
      "start_date": DateFormat('yyyy-MM-dd').format(startDate),
      "end_date": DateFormat('yyyy-MM-dd').format(endDate),
    };

    // Call API
    isLoading = true;
    notifyListeners();
    try {
      final val = await DoctorsRepo().saveDoctorSchedule(requestBody);
      isLoading = false;
      if (val.success == 1) {
        ToastService.showSuccess(val.msg);
        notifyListeners();
        return true;
      } else {
        ToastService.showError(val.msg);
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      ToastService.showError("Error saving schedule".tr() + ": $e");
      notifyListeners();
      return false;
    }
  }

  /// Save individual schedule - validation and request building in provider
  Future<bool> saveIndividualSchedule({
    required int doctorId,
    required Map<int, String> dayTimes,   // index -> time
    required Map<int, String> dayDates,   // index -> date (NEW)
  }) async {

    // Validation
    if (dayTimes.isEmpty || dayDates.isEmpty) {
      ToastService.showError('Please select at least one day with time'.tr());
      return false;
    }

    // Prepare schedules array
    final List<Map<String, String>> schedules = [];
    final sortedKeys = dayTimes.keys.toList()..sort();

    for (final index in sortedKeys) {
      final time = dayTimes[index];
      final date = dayDates[index];

      if (time == null || date == null) continue;

      schedules.add({
        "day": date,   // 👈 بدل day name صار date
        "time": time,
      });
    }

    // Request body (ما تغير)
    final requestBody = {
      "doctor_id": doctorId,
      "schedule_type": "individual",
      "schedules": schedules,
    };
    isLoading = true;
    notifyListeners();

    try {
      final val = await DoctorsRepo().saveIndividualSchedule(requestBody);

      isLoading = false;

      if (val.success == 1) {
        ToastService.showSuccess(val.msg);
        await getDoctorsList();
        notifyListeners();
        return true;
      } else {
        ToastService.showError(val.msg);
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      ToastService.showError("Error saving schedule".tr() + ": $e");
      notifyListeners();
      return false;
    }
  }

  List<Area> categories = [];
  List<Area> specialities = [];
  List<Area> areas = [];

  // Helper methods to get label from value
  String? getCategoryLabel() {
    if (selectedCategory == null) return 'All'.tr();
    try {
      return categories.firstWhere((e) => e.value == selectedCategory).label;
    } catch (_) {
      return 'All'.tr();
    }
  }

  String? getSpecialityLabel() {
    if (selectedSpeciality == null) return 'All'.tr();
    try {
      return specialities
          .firstWhere((e) => e.value == selectedSpeciality)
          .label;
    } catch (_) {
      return 'All'.tr();
    }
  }

  String? getAreaLabel() {
    if (selectedArea == null) return 'All'.tr();
    try {
      return areas.firstWhere((e) => e.value == selectedArea).label;
    } catch (_) {
      return 'All'.tr();
    }
  }

  Future<void> getFilters() async {
    isLoading = true;
    notifyListeners();
    try {
      final val = await DoctorsRepo().getFilters();
      isLoading = false;
      if (val.status == 1) {
        categories = val.data?.categories ?? [];
        specialities = val.data?.specialties ?? [];
        areas = val.data?.areas ?? [];
      } else {
        categories.clear();
        specialities.clear();
        areas.clear();
      }
      notifyListeners();
    } catch (e) {
      isLoading = false;
      ToastService.showError("Error getting filters".tr() + ": $e");
      notifyListeners();
    }
  }

  /// My Doctors
  bool isMyDoctorsLoading = false;
  List<Datum> myDoctorsList = [];

  Future<void> getMyDoctors() async {
    isMyDoctorsLoading = true;
    notifyListeners();
    try {
      final response = await DoctorsRepo().getMyDoctors();
      isMyDoctorsLoading = false;
      if (response.status == 1) {
        myDoctorsList = response.data;
      } else {
        myDoctorsList.clear();
      }
      notifyListeners();
    } catch (e) {
      isMyDoctorsLoading = false;
      ToastService.showError("Error getting my doctors".tr() + ": $e");
      notifyListeners();
    }
  }

  /// Select doctor page
  TextEditingController searchDoctorController = TextEditingController();

  /// Selected doctor IDs for "Add to my list" (multiple selection)
  List<int> selectedDoctorIds = [];

  void toggleSelectedDoctor(int doctorId) {
    if (selectedDoctorIds.contains(doctorId)) {
      selectedDoctorIds.remove(doctorId);
    } else {
      selectedDoctorIds.add(doctorId);
    }
    notifyListeners();
  }

  void clearSelectedDoctors() {
    selectedDoctorIds.clear();
    notifyListeners();
  }

  bool isDoctorSelected(int doctorId) {
    return selectedDoctorIds.contains(doctorId);
  }

  /// Add doctor request from selected doctors (From List page)
  Future<void> addDoctorRequest() async {
    if (selectedDoctorIds.isEmpty) {
      ToastService.showError("Please select at least one doctor".tr());
      return;
    }

    // Process each selected doctor
    for (final doctorId in selectedDoctorIds) {
      // Find the selected doctor from myDoctorsList
      final selectedDoctor = myDoctorsList.firstWhere(
        (doctor) => doctor.id != null && doctor.id == doctorId,
        orElse: () => throw Exception("Selected doctor not found".tr()),
      );

      // Use the form-based method with selected doctor data
      await addDoctorRequestFromForm(
        name: selectedDoctor.name ?? "",
        hospitalName: selectedDoctor.hospitalName ?? "",
        address: selectedDoctor.address ?? "",
        specialty: selectedDoctor.speciality ?? "",
        category: selectedDoctor.datumClass ?? "",
        area: selectedDoctor.address ?? "",
        phone: selectedDoctor.phone?.toString() ?? "",
        email: selectedDoctor.email?.toString() ?? "",
      );
    }

    // Clear selection after successful request
    clearSelectedDoctors();
  }

  /// Add selected doctors to my list (From List page)
  Future<void> addToMyList() async {
    if (selectedDoctorIds.isEmpty) {
      ToastService.showError("Please select at least one doctor".tr());
      return;
    }

    isLoading = true;
    notifyListeners();
    // Create request body with doctor_id array
    final requestBody = {
      "doctor_id": selectedDoctorIds,
    };
    try {
      final response = await DoctorsRepo().addToMyList(requestBody);
      isLoading = false;

      if (response.status == 1) {
        // Check if all doctors are already in the list
        final msg = response.msg.toLowerCase();
        if (msg.contains("already in your list") ||
            msg.contains("already in") ||
            (response.data == null && response.msg.isNotEmpty)) {
          // Show info message instead of success
          ToastService.showInfo(response.msg.isNotEmpty
              ? response.msg
              : "All doctors are already in your list".tr());
        } else {
          // Successfully added doctors
          ToastService.showSuccess(response.msg.isNotEmpty
              ? response.msg
              : "Doctors added successfully".tr());
          // Refresh my doctors list
          await getMyDoctors();
        }
        // Clear selection in both cases
        clearSelectedDoctors();
        notifyListeners();
      } else {
        ToastService.showError(response.msg.isNotEmpty
            ? response.msg
            : "Failed to add doctors".tr());
      }
      notifyListeners();
    } catch (e) {
      isLoading = false;
      ToastService.showError("Error adding doctors to list".tr() + ": $e");
      notifyListeners();
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
bool successAdd=false;
  /// Add doctor request from form data (Add New Doctor page)
  Future<void> addDoctorRequestFromForm({
    required String name,
    required String hospitalName,
    required String address,
    required String specialty,
    required String category,
    required String area,
    required String phone,
    required String email,
  }) async {



    // Get the value for specialty, category and area from their labels
    String? specialtyValue;
    String? categoryValue;
    String? areaValue;

    try {
      if (specialty.isNotEmpty && specialty != 'Select specialty'.tr()) {
        final specialtyItem =
            specialities.firstWhere((e) => e.label == specialty);
        specialtyValue = specialtyItem.value;
      }
    } catch (_) {
      specialtyValue = specialty; // Fallback to label if not found
    }

    try {
      if (category.isNotEmpty && category != 'Select category'.tr()) {
        final categoryItem = categories.firstWhere((e) => e.label == category);
        categoryValue = categoryItem.value;
      }
    } catch (_) {
      categoryValue = category; // Fallback to label if not found
    }



    // Build request body according to the API specification
    final requestBody = {
      "name": name,
      "email": email,
      "phone": phone,
      "specialty": specialtyValue ?? specialty,
      "hospital_name": hospitalName,
      "area": areaValue ?? area,
      "class": categoryValue ?? category,
      "location": address,
    };

    isLoading = true;
    notifyListeners();

    try {
      final response = await DoctorsRepo().addDoctorRequest(requestBody);

      isLoading = false;

      if (response.status == 1) {
        ToastService.showSuccess(response.msg.isNotEmpty
            ? response.msg
            : "Doctor request added successfully".tr());
        successAdd=true;
        notifyListeners();
      } else {
        ToastService.showError(response.msg.isNotEmpty
            ? response.msg
            : "Failed to add doctor request".tr());
      }

      notifyListeners();
    } catch (e) {
      isLoading = false;
      ToastService.showError("Error adding doctor request".tr() + ": $e");
      notifyListeners();
    }
  }
}
