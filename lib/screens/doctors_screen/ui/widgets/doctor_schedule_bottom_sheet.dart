import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/ui/widgets/loading_widget.dart';

import '../../../../base/constants/app_colors.dart';
import '../../../../base/constants/dimensions.dart';
import '../../../../base/ui/widgets/button_widget.dart';
import '../../../../base/ui/widgets/custom_check_box.dart';
import '../../../../base/ui/widgets/text_widget.dart';
import '../../providers/doctors_provider.dart';

class DoctorScheduleBottomSheet extends StatefulWidget {
  final int doctorId;

  const DoctorScheduleBottomSheet({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorScheduleBottomSheet> createState() =>
      _DoctorScheduleBottomSheetState();
}

class _DoctorScheduleBottomSheetState extends State<DoctorScheduleBottomSheet> {
  int selectedTab = 0; // 0 = Bulk, 1 = Individual

  final List<String> _days = const [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  late List<bool> _selectedDays;

  /// Bulk schedule time (one time for all selected days)
  String _selectedTime = '10:00 AM';

  /// Individual schedule: day index -> time string
  final Map<int, String> _individualDayTimes = {};

  /// Individual schedule: day index -> date
  final Map<int, DateTime> _individualDayDates = {};

  /// Date fields for bulk schedule
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedDays = List<bool>.filled(_days.length, false);
    // Set default dates (start: today, end: one month from today)
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.fullWidth(context),
      height: Dimensions.fullHeight(context) * 0.8,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xffD7D9F2)),
              ),
              child: Row(
                children: [
                  _tabItem('Bulk Schedule'.tr(), 0),
                  _tabItem('Individual Schedule'.tr(), 1),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      selectedTab == 0
                          ? 'Select Day(s)'.tr()
                          : 'Add Days (each with specific time)'.tr(),
                      textSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.fontColor,
                    ),
                    const SizedBox(height: 12),
                    _buildDaysGrid(),
                    const SizedBox(height: 20),
                    if (selectedTab == 0) ...[
                      TextWidget(
                        'Time (applies to all selected day(s))'.tr(),
                        textSize: 14,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.fontColor,
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final TimeOfDay initialTime =
                              _parseTimeOfDay(_selectedTime);
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: initialTime,
                          );
                          if (picked != null) {
                            final String formatted =
                                MaterialLocalizations.of(context)
                                    .formatTimeOfDay(
                              picked,
                              alwaysUse24HourFormat: false,
                            );
                            setState(() {
                              _selectedTime = formatted;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.grey300),
                            color: AppColors.grey50,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                _selectedTime,
                                textSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.typography700,
                              ),
                              const Icon(
                                Icons.access_time,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ] else ...[
                      _buildIndividualSchedules(),
                    ],
                    const SizedBox(height: 16),
                    TextWidget(
                      'Preview:'.tr(),
                      textSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.fontColor,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey200),
                        color: AppColors.grey50,
                      ),
                      child: TextWidget(
                        _previewText,
                        textSize: 12,
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.typography500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: 'Cancel'.tr(),
                    backgroundColor: AppColors.whiteColor,
                    textColor: AppColors.typography700,
                    borderColor: AppColors.grey300,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ButtonWidget(
                    text: 'Save Schedule'.tr(),
                    onTap: () {
                      _handleSaveSchedule();
                    },
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final bool isSelected = selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            // Clear selections when switching tabs
            if (selectedTab != index) {
              // Clear selected days
              _selectedDays = List<bool>.filled(_days.length, false);

              // Clear individual schedule data when switching to bulk
              if (index == 0) {
                _individualDayTimes.clear();
                _individualDayDates.clear();
              }
            }
            selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? AppColors.whiteColor : Colors.transparent,
          ),
          child: Center(
            child: TextWidget(
              title,
              textSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              textColor:
                  isSelected ? AppColors.mainColor : AppColors.typography700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaysGrid() {
    return Wrap(
      runSpacing: 8,
      spacing: 16,
      children: List.generate(_days.length, (index) {
        return SizedBox(
          width: (Dimensions.fullWidth(context) - 16 * 3) / 2,
          child: Row(
            children: [
              CustomCheckBox(
                isChecked: _selectedDays[index],
                checkboxCallback: (value) {
                  setState(() {
                    final bool checked = value ?? false;
                    _selectedDays[index] = checked;
                    if (selectedTab == 1) {
                      if (checked) {
                        // Add with default time if not present
                        _individualDayTimes[index] =
                            _individualDayTimes[index] ?? _selectedTime;
                        // Add default date (today) if not present
                        _individualDayDates[index] =
                            _individualDayDates[index] ?? DateTime.now();
                      } else {
                        _individualDayTimes.remove(index);
                        _individualDayDates.remove(index);
                      }
                    }
                  });
                },
              ),
              const SizedBox(width: 8),
              TextWidget(
                _days[index].tr(),
                textSize: 14,
                fontWeight: FontWeight.w500,
                textColor: AppColors.typography700,
              ),
            ],
          ),
        );
      }),
    );
  }

  String get _previewText {
    if (selectedTab == 0) {
      final selected = <String>[];
      for (int i = 0; i < _days.length; i++) {
        if (_selectedDays[i]) {
          selected.add(_days[i].tr());
        }
      }
      if (selected.isEmpty) {
        return 'No days selected'.tr();
      }
      return '${selected.join(', ')} • $_selectedTime';
    } else {
      if (_individualDayTimes.isEmpty || _individualDayDates.isEmpty) {
        return 'No days selected'.tr();
      }
      final buffer = <String>[];
      final sortedKeys = _individualDayTimes.keys.toList()..sort();
      for (final index in sortedKeys) {
        final date = _individualDayDates[index];
        final dateStr = date != null
            ? DateFormat('yyyy-MM-dd').format(date)
            : 'No date'.tr();
        buffer.add(
            '${_days[index].tr()} • $dateStr • ${_individualDayTimes[index]}');
      }
      return buffer.join('\n');
    }
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    try {
      final localizations = MaterialLocalizations.of(context);
      // This will handle localized formats if possible; if it fails, fall back.
      final now = TimeOfDay.now();
      final format = localizations.formatTimeOfDay(now);
      if (format.contains('AM') || format.contains('PM')) {
        // Expecting something like "10:00 AM"
        final parts = timeString.split(' ');
        final hm = parts.first.split(':');
        int hour = int.parse(hm[0]);
        final int minute = int.parse(hm[1]);
        final bool isPm = parts.length > 1 && parts[1].toUpperCase() == 'PM';
        if (isPm && hour < 12) hour += 12;
        if (!isPm && hour == 12) hour = 0;
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (_) {
      // ignore parse errors and fall back
    }
    return const TimeOfDay(hour: 10, minute: 0);
  }

  Widget _buildIndividualSchedules() {
    if (_individualDayTimes.isEmpty) {
      return Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.grey50,
        ),
        child: TextWidget(
          'No days selected'.tr(),
          textSize: 12,
          fontWeight: FontWeight.w400,
          textColor: AppColors.typography500,
        ),
      );
    }

    final sortedKeys = _individualDayTimes.keys.toList()..sort();

    final List<Widget> children = [
      const SizedBox(height: 8),
    ];

    for (final index in sortedKeys) {
      final String dayName = _days[index];
      final String time = _individualDayTimes[index] ?? _selectedTime;
      final DateTime date = _individualDayDates[index] ?? DateTime.now();

      children.add(
        Container(
          width: double.maxFinite,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.grey50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextWidget(
                      dayName.tr(),
                      textSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.fontColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _individualDayTimes.remove(index);
                        _individualDayDates.remove(index);
                        _selectedDays[index] = false;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: AppColors.red,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Date picker
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() {
                            _individualDayDates[index] = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.grey300),
                          color: AppColors.whiteColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: TextWidget(
                                DateFormat('yyyy-MM-dd').format(date),
                                textSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.typography700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Time picker
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final TimeOfDay initial = _parseTimeOfDay(time);
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: initial,
                        );
                        if (picked != null) {
                          final String formatted =
                              MaterialLocalizations.of(context).formatTimeOfDay(
                            picked,
                            alwaysUse24HourFormat: false,
                          );
                          setState(() {
                            _individualDayTimes[index] = formatted;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.grey300),
                          color: AppColors.whiteColor,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: TextWidget(
                                time,
                                textSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.typography700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.access_time,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: children);
  }

  Future<void> _handleSaveSchedule() async {

    final provider = Provider.of<DoctorsProvider>(context, listen: false);
    bool success = false;

    if (selectedTab == 0) {
      // Bulk schedule
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select start and end dates'.tr()),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }

      final selectedDaysList = <String>[];
      for (int i = 0; i < _days.length; i++) {
        if (_selectedDays[i]) {
          selectedDaysList.add(_days[i]);
        }
      }
      LoadingWidget.show();
      success = await provider.saveBulkSchedule(

        doctorId: widget.doctorId,
        selectedDays: selectedDaysList,
        time: _selectedTime,
        startDate: _startDate!,
        endDate: _endDate!,
      );
      LoadingWidget.hide();
    } else {
      // Individual schedule
      LoadingWidget.show();

      success = await provider.saveIndividualSchedule(
        doctorId: widget.doctorId,
        dayTimes: _individualDayTimes,
        days: _days,
      );
      LoadingWidget.hide();

    }

    if (success && mounted) {
      Navigator.of(context).pop();
    }
    if(success && mounted){
      await provider.getDoctorsList();
    }

  }
}
