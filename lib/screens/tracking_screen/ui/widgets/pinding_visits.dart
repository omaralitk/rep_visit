import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/screens/schedule_screen/provider/getScheduleProvider.dart';
import 'package:rep_visit/screens/tracking_screen/provider/tracking_provider.dart';

import '../../../../base/constants/app_colors.dart';
import '../../../../base/constants/asset_images.dart';
import '../../../../base/ui/widgets/text_widget.dart';

class PendingVisits extends StatefulWidget {
  const PendingVisits({super.key});

  @override
  State<PendingVisits> createState() => _PendingVisitsState();
}

class _PendingVisitsState extends State<PendingVisits> {
  @override
  Widget build(BuildContext context) {
    var pendingProvider =Provider.of<TrackingProvider>(context,listen: false);
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
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  "Pending Visits",
                  textSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.fontColor,
                ),
                TextWidget(
                  "${pendingProvider.pendingVisits.length.toString()} visits remaining today",
                  textSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.typography500,
                  textAlign: TextAlign.start,
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pendingProvider.pendingVisits.length,
            itemBuilder: (context, index) {
              return visitSection(pendingProvider,index);
            })
      ],
    );
  }

  visitSection(TrackingProvider provider,int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey200)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        provider.pendingVisits[index].doctor.name,
                        textSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.fontColor,
                      ),
                      TextWidget(
                        provider.pendingVisits[index].doctor.hospitalName,
                        textSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.typography500,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkGrey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: TextWidget(
                        provider.pendingVisits[index].visitTime,
                        textSize: 12,
                        textColor: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SvgPicture.asset(AssetImages.locationIcon),
                  const SizedBox(
                    width: 5,
                  ),
                  TextWidget(
                    provider.pendingVisits[index].doctor.address,
                    textSize: 12,
                    fontWeight: FontWeight.w300,
                    textColor: AppColors.typography500,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              // Button
              GestureDetector(
                // onTap: provider.handleDayAction,
                child: Container(
                  height: 48,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: true == true
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
                          color: true == true
                              ? AppColors.primary700
                              : AppColors.endDayIcon,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          true == true
                              ? Icons.play_arrow_outlined
                              : Icons.stop_outlined,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        true == true ? "Start Visit" : "End Visit",
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
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){

                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.grey200)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AssetImages.navigateIcon),
                                SizedBox(
                                  width: 5,
                                ),
                                TextWidget(
                                  "Navigate",
                                  textSize: 12,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.fontColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.grey200)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AssetImages.callIcon),
                              SizedBox(
                                width: 5,
                              ),
                              TextWidget(
                                "Call",
                                textSize: 12,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.fontColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
