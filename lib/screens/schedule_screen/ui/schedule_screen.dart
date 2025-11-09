import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/main_header.dart';

import '../../../base/constants/asset_images.dart';
import '../../../base/ui/widgets/button_widget.dart';
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
      body: Stack(
        children: [
          Padding(
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 20),
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
                                    border:
                                        Border.all(color: AppColors.grey300)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                      AssetImages.scheduleIcon),
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
                                      border: Border.all(
                                          color: AppColors.mainColor)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              width: Dimensions.fullWidth(context),
              height: 80,
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  border: Border.all(color: AppColors.grey100)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ButtonWidget(
                    text: "Add Visit",
                    icon: Icon(
                      Icons.add,
                      color: AppColors.whiteColor,
                      size: 20,
                    ),
                    onTap: () {

                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return Container(
                              width: Dimensions.fullWidth(context),
                              height: Dimensions.fullHeight(context) * 0.9,
                              color: AppColors.whiteColor,
                              // child: SingleChildScrollView(
                              //   child:,
                              // ),
                            );
                          });
                    },
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          )
        ],
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
              ),
              TextWidget(
                "Cardiology",
                textSize: 12,
                fontWeight: FontWeight.w500,
                textColor: AppColors.typography500,
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AssetImages.hospitalIcon),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget(
                        "City Hospital",
                        textSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.typography500,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AssetImages.mapPin),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: Dimensions.fullWidth(context) * 0.3,
                        child: TextWidget(
                          "123 Medical Plaza,Suite 201",
                          textSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.typography500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SvgPicture.asset(AssetImages.timerIcon),
                      Icon(
                        Icons.access_time_rounded,
                        color: AppColors.mainColor,
                        size: 22,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: AppColors.whiteColor,
                                size: 16,
                              ),
                              TextWidget(
                                "9:00 AM",
                                textSize: 12,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.whiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AssetImages.scheduleIcon),
                      const SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: Dimensions.fullWidth(context) * 0.3,
                        child: TextWidget(
                          "Last visit: 08-01-2025",
                          textSize: 12,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.typography500,
                        ),
                      ),
                    ],
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
