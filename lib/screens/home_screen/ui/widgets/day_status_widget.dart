import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';

import '../../providers/day_status_provider.dart';

class DayStatusWidget extends StatefulWidget {
  const DayStatusWidget({super.key});

  @override
  State<DayStatusWidget> createState() => _DayStatusWidgetState();
}

class _DayStatusWidgetState extends State<DayStatusWidget> {


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DayStatusProvider>(context);
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, MMM d').format(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.mainColor, // main blue background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Day Status",
                fontWeight: FontWeight.bold,
                textColor: AppColors.whiteColor,
                textSize: 16,
              ),
              TextWidget(
                formattedDate,
                textColor: AppColors.whiteColor,
                textSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// Start/End Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                "Start Time:",
              textSize: 14,
                style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.7), ),
              ),
              Text(
                provider.formattedStartTime,
                style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.7), fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "End Time:",
                style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.7), fontSize: 14),
              ),
              Text(
                provider.formattedEndTime,
                style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.7), fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Button
          GestureDetector(
            onTap: provider.handleDayAction,
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: !provider.isStart
                    ? AppColors.primary900
                    : AppColors.endDayButton,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 28,
                    width: 28,
                    decoration: BoxDecoration(
                      color: !provider.isStart
                          ? AppColors.primary700
                          : AppColors.endDayIcon,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      !provider.isStart
                          ? Icons.play_arrow_outlined
                          : Icons.stop_outlined,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    !provider.isStart  ? "Start Day" : "End Day",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
