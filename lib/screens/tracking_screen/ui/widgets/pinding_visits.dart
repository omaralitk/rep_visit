import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/asset_images.dart';
import 'package:rep_visit/base/ui/widgets/no_data_widget.dart';
import 'package:rep_visit/base/ui/widgets/text_widget.dart';
import 'package:rep_visit/screens/tracking_screen/provider/tracking_provider.dart';
import 'package:rep_visit/screens/tracking_screen/models/traking_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

// Helper to format Duration -> mm:ss or hh:mm:ss if long
String formatDurationSimple(Duration d) {
  if (d.inHours > 0) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  } else {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class PendingVisits extends StatefulWidget {
  const PendingVisits({super.key});

  @override
  State<PendingVisits> createState() => _PendingVisitsState();
}

class _PendingVisitsState extends State<PendingVisits> {
  @override
  void initState() {
    super.initState();
    // final prov = Provider.of<TrackingProvider>(context, listen: false);
    // prov.getVisits();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TrackingProvider>(
      builder: (context, provider, _) {
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey300)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(AssetImages.noData),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      "Pending Visits".tr(),
                      textSize: 16,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.fontColor,
                    ),
                    Row(
                      children: [
                        TextWidget(
                          "${provider.pendingVisits.length.toString()} ",
                          textSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.typography500,
                          textAlign: TextAlign.start,
                        ),
                        TextWidget(
                          "visits remaining today".tr(),
                          textSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.typography500,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            provider.pendingVisits.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.pendingVisits.length,
                    itemBuilder: (context, idx) {
                      final visit = provider.pendingVisits[idx];
                      return visitCard(provider, visit);
                    },
                  )
                : NoDataWidget(
                    title: "You don't have pending visits for today".tr())
          ],
        );
      },
    );
  }

  Widget visitCard(TrackingProvider provider, ScheduleVisits visit) {
    final isActive = provider.visitActive[visit.id] ?? false;
    final elapsed = provider.visitElapsed[visit.id] ?? Duration.zero;
    final rating = provider.visitRating[visit.id] ?? 0;
    final notesController = provider.notesControllerFor(visit.id??0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// -------- HEADER ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        visit.doctor?.name??"",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.fontColor),
                      ),
                      Text(
                        visit.doctor?.hospitalName??"",
                        style: TextStyle(
                            fontSize: 12, color: AppColors.typography500),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: AppColors.darkGrey,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      isActive
                          ? _formatDuration(elapsed)
                          : visit.visitTime??"",
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 15),

              /// ---------- ADDRESS ----------
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      visit.doctor?.address??"",
                      style: TextStyle(
                          fontSize: 12, color: AppColors.typography500),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 15),

              /// =============== IF VISIT IS NOT ACTIVE =============== ///
              if (!isActive) ...[
                // Start Visit Button
                GestureDetector(
                  onTap: () => provider.startVisit(
                    context,
                    visit.id??0,
                  ),
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary900,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          TextWidget(
                            "Start Visit".tr(),
                            textSize: 16,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.whiteColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Navigate and Call buttons
                Row(
                  children: [
                     Expanded(
                      child: InkWell(
                        onTap: () => _openGoogleMap(visit.doctor?.latitude??"", visit.doctor?.longitude??""),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.grey300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.send,
                                size: 18,
                                color: AppColors.fontColor,
                              ),
                              const SizedBox(width: 6),
                              TextWidget(
                                "Navigate".tr(),
                                textSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.fontColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    visit.doctor?.phone != ""? const SizedBox(width: 8):const SizedBox(),
                    visit.doctor?.phone != ""?Expanded(
                      child: InkWell(
                        onTap: () => _makePhoneCall(visit.doctor?.phone ?? ""),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.grey300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 18,
                                color: AppColors.fontColor,
                              ),
                              const SizedBox(width: 6),
                              TextWidget(
                                "Call".tr(),
                                textSize: 14,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.fontColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ):const SizedBox(),
                  ],
                ),
              ],

              /// =============== IF VISIT IS ACTIVE =============== ///
              if (isActive) ...[
                /// ---------- RATING ----------
                Row(
                  children: List.generate(5, (i) {
                    final starIndex = i + 1;
                    final filled = starIndex <= rating;
                    return GestureDetector(
                      onTap: () {
                        provider.setRating(visit.id??0, starIndex);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color:
                              filled ? AppColors.starColor : AppColors.grey100,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.grey200),
                        ),
                        child: Icon(
                          filled ? Icons.star : Icons.star_border,
                          size: 18,
                          color: filled
                              ? AppColors.whiteColor
                              : AppColors.typography500,
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 12),

                /// ---------- NOTES ----------
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextWidget("Visit Notes".tr(),
                      textSize: 14,
                      fontWeight: FontWeight.bold,
                      textColor: AppColors.fontColor),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: notesController,
                    maxLines: null,
                    onChanged: (v) => provider.setNotes(visit.id??0, v),
                    decoration: const InputDecoration.collapsed(
                        hintText: "Write notes..."),
                  ),
                ),

                const SizedBox(height: 12),

                /// ---------- END VISIT ----------
                GestureDetector(
                  onTap: () => provider.endVisit(context, visit.id??0),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.endDayButton,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.stop_outlined,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          TextWidget(
                            "End Visit".tr(),
                            textSize: 16,
                            textColor: AppColors.whiteColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Format timer
  String _formatDuration(Duration d) {
    if (d.inHours > 0) {
      final h = d.inHours;
      final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      return "$h:$m:$s";
    } else {
      final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
      final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
      return "$m:$s";
    }
  }
  /// Format visit time
  String _formatVisitTime(DateTime visitDate) {
    return DateFormat('h:mm a').format(visitDate);
  }

  /// Open Google Maps
  Future<void> _openGoogleMap(String latitude, String longitude) async {
    final Uri googleMapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open Google Maps.';
    }
  }

  /// Make phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not make the call.';
    }
  }
}
