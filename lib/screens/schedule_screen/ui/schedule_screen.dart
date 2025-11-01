import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/ui/widgets/main_header.dart';

import '../../../base/constants/asset_images.dart';
import '../../../base/ui/widgets/text_widget.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SchedulePage();
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MainHeader(
            title: "Schedule", subTitle: "Manage your visit schedule"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.grey100,
                    border: Border.all(color: AppColors.grey200),
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                  child: Column(
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
                              child: SvgPicture.asset(AssetImages.scheduleIcon),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                "Today's Schedule",
                                textSize: 16,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.fontColor,
                              ),
                              TextWidget(
                                // provider.date,
                                "1-1-2023",
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
                        height: 15,
                      ),

                      /// AI Section
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: AppColors.mainColor)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AssetImages.aiIcon),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    TextWidget(
                                      "Let AI Schedule".tr(),
                                      textSize: 12,
                                      fontWeight: FontWeight.w700,
                                      textColor: AppColors.mainColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          SvgPicture.asset(AssetImages.infoIcon)
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return doctorSection(index);
                          })
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  doctorSection(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(color: AppColors.grey200),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header widget
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary100)),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 33,
                        height: 33,
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: TextWidget(
                            "A",
                            textSize: 12,
                            fontWeight: FontWeight.w700,
                            textColor: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 33,
                        decoration: BoxDecoration(
                            color: AppColors.success50,
                            border: Border.all(color: AppColors.success200),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                            child: TextWidget(
                              "Available",
                              textSize: 12,
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.success200,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.star,
                        color: AppColors.starColor,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget(
                        "4.5",
                        textSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.typography500,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),

              /// Name of doctor
              TextWidget(
                "Dr Ahmad Rosan",
                textSize: 16,
                fontWeight: FontWeight.w700,
                textColor: AppColors.fontColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
