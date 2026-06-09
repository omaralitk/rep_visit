import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/constants/app_colors.dart';
import 'package:rep_visit/base/constants/dimensions.dart';
import 'package:rep_visit/base/ui/widgets/cached_image.dart';
import 'package:rep_visit/base/ui/widgets/main_header.dart';
import 'package:rep_visit/screens/schedule_screen/provider/get_schedule_provider.dart';
import 'package:rep_visit/screens/schedule_screen/ui/widgets/add_schedule_widget.dart';
import 'package:rep_visit/screens/schedule_screen/ui/widgets/schedule_shimmer.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleProvider>(context, listen: false).getVisits(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var scheduleProvider =
        Provider.of<ScheduleProvider>(context, listen: false);
    final today = DateTime.now();
    final formatted = "${today.year}-${today.month}-${today.day}";
    return Scaffold(
      appBar: AppBar(
        title: MainHeader(
            title: "Schedule".tr(),
            subTitle: "Manage your visit schedule".tr()),
      ),
      body: Selector<ScheduleProvider, bool>(
        selector: (context, provider) => provider.isLoading,
        builder: (context, isLoading, _) {
          if (isLoading) {
            return const ScheduleShimmer();
          }
          return SizedBox(
            height: double.maxFinite,
            child: Stack(
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: AppColors.grey300)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          "Today's Schedule".tr(),
                                          textSize: 16,
                                          fontWeight: FontWeight.w700,
                                          textColor: AppColors.fontColor,
                                        ),
                                        TextWidget(
                                          // provider.date,
                                          formatted,
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
                                      child: InkWell(
                                        onTap: () {
                                          scheduleProvider.getVisits(true);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: AppColors.mainColor)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                    AssetImages.aiIcon),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                TextWidget(
                                                  "Let AI Schedule".tr(),
                                                  textSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  textColor:
                                                      AppColors.mainColor,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Tooltip(
                                      message:
                                          "AI will scheduling your \n appointments by destination."
                                              .tr(),
                                      textStyle:
                                          TextStyle(color: AppColors.black),
                                      textAlign: TextAlign.center,
                                      showDuration: const Duration(seconds: 4),
                                      triggerMode: TooltipTriggerMode.tap,
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                      ),
                                      enableTapToDismiss: true,
                                      child: SvgPicture.asset(
                                          AssetImages.infoIcon),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Selector<ScheduleProvider, bool>(
                                    builder: (context, provider, widget) {
                                      return provider
                                          ? const SizedBox.shrink()
                                          : scheduleProvider
                                                  .listOfVisits.isNotEmpty
                                              ? ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: scheduleProvider
                                                      .listOfVisits.length,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return doctorSection(index,
                                                        scheduleProvider);
                                                  })
                                              : Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 20.0),
                                                  child: Column(
                                                    children: [
                                                      SvgPicture.asset(
                                                          AssetImages.noData),
                                                      TextWidget(
                                                        "No schedule visits for today"
                                                            .tr(),
                                                        textSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        textColor:
                                                            AppColors.fontColor,
                                                      ),
                                                      TextWidget(
                                                        "Use the 'Add Visit' button to schedule visits"
                                                            .tr(),
                                                        textSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        textColor: AppColors
                                                            .typography700,
                                                      )
                                                    ],
                                                  ),
                                                );
                                    },
                                    selector: (context, selector) =>
                                        selector.doctorsLoading)
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
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
                          text: "Add Visit".tr(),
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
                                  return const AddScheduleWidget();
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
        },
      ),
    );
  }

  doctorSection(int index, ScheduleProvider provider) {
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
                    CachedImage(
                        url: provider.listOfVisits[index].doctor?.image ?? ""),
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
                              provider.listOfVisits[index].doctor?.doctorClass??"",
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
                          provider.listOfVisits[index].doctor?.rating ?? "",
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
                  provider.listOfVisits[index].doctor?.name??"",
                  textSize: 16,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.fontColor,
                ),
                TextWidget(
                  provider.listOfVisits[index].doctor?.speciality??"",
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
                          provider.listOfVisits[index].doctor?.hospitalName ??
                              "",
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
                            provider.listOfVisits[index].doctor?.address??"",
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  color: AppColors.whiteColor,
                                  size: 16,
                                ),
                                TextWidget(
                                  provider.listOfVisits[index].visitTime??"",
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget(
                                "Last visit:".tr(),
                                textSize: 12,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.typography500,
                              ),
                              Expanded(
                                child: TextWidget(
                                  " ${provider.listOfVisits[index].doctor?.lastVisit}",
                                  textSize: 12,
                                  fontWeight: FontWeight.w500,
                                  textColor: AppColors.typography500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
