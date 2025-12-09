import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/ui/widgets/button_widget.dart';
import 'package:rep_visit/base/ui/widgets/cached_image.dart';
import 'package:rep_visit/base/ui/widgets/custom_toast.dart';
import 'package:rep_visit/base/ui/widgets/shared_text_form_field.dart';
import 'package:rep_visit/screens/schedule_screen/provider/get_schedule_provider.dart';

import '../../../../base/constants/app_colors.dart';
import '../../../../base/constants/asset_images.dart';
import '../../../../base/constants/dimensions.dart';
import '../../../../base/ui/widgets/text_widget.dart';

class AddScheduleWidget extends StatefulWidget {
  const AddScheduleWidget({super.key});

  @override
  State<AddScheduleWidget> createState() => _AddScheduleWidgetState();
}

class _AddScheduleWidgetState extends State<AddScheduleWidget> {
  late ScheduleProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((val) async {
      Provider.of<ScheduleProvider>(context, listen: false).getDoctorsList();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<ScheduleProvider>(context, listen: false);
  }

  @override
  void dispose() {
    provider.listOfAddedSchedule.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scheduleProvider =
        Provider.of<ScheduleProvider>(context, listen: false);

    return Container(
      width: Dimensions.fullWidth(context),
      height: Dimensions.fullHeight(context) * 0.9,
      color: AppColors.whiteColor,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Selector<ScheduleProvider, bool>(
                  builder: (context, provider, widget) {
                    return provider
                        ? SizedBox(
                            height: Dimensions.fullHeight(context) * 0.9,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              TextWidget(
                                "Schedule new visit",
                                textSize: 20,
                                textColor: AppColors.fontColor,
                                fontWeight: FontWeight.w700,
                              ),
                              TextWidget(
                                "Add a visit with one of your assigned doctors",
                                textSize: 12,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.typography700,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary500,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: const Color(0xffD7D9F2)),
                                ),
                                child: Row(
                                  children: [
                                    _tabItem("This Day", 0, scheduleProvider),
                                    _tabItem("Tomorrow", 1, scheduleProvider),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SharedTextFormField(
                                  label: "",
                                  hint: "Search doctors...",
                                  controller:
                                      scheduleProvider.searchController),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      scheduleProvider.doctorsList.length,
                                  itemBuilder: (context, index) {
                                    return doctorSection(
                                        index, scheduleProvider);
                                  }),
                              const SizedBox(
                                height: 70,
                              ),
                            ],
                          );
                  },
                  selector: (context, selector) => selector.doctorsLoading),
            ),
          ),
          Selector<ScheduleProvider, bool>(
              builder: (context, checkSave, widget) {
                return checkSave
                    ? Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ButtonWidget(
                            text: "Save",
                            onTap: () {
                              scheduleProvider.saveScheduleVisits(context);
                            },
                            textColor: AppColors.whiteColor,
                            fontWeight: FontWeight.w700,
                            textSize: 16,
                          ),
                        ))
                    : const SizedBox();
              },
              selector: (context, selector) =>
                  selector.listOfAddedSchedule.isNotEmpty)
        ],
      ),
    );
  }

  Widget _tabItem(String title, int index, ScheduleProvider provider) {
    return Selector<ScheduleProvider, int>(
        builder: (context, indexProvider, widget) {
          bool isSelected = indexProvider == index;
          return Expanded(
            child: InkWell(
              onTap: () {
                provider.setSelectedTap(index);
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
                    textColor: isSelected
                        ? AppColors.mainColor
                        : AppColors.typography700,
                  ),
                ),
              ),
            ),
          );
        },
        selector: (context, selector) => selector.selectedIndex);
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
                    url: provider.doctorsList[index].image ?? "",
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
                            provider.doctorsList[index].datumClass ?? "",
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
                        provider.doctorsList[index].rating ?? "",
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
                provider.doctorsList[index].name ?? "",
                textSize: 16,
                fontWeight: FontWeight.w700,
                textColor: AppColors.fontColor,
              ),
              TextWidget(
                provider.doctorsList[index].speciality ?? "",
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
                        provider.doctorsList[index].hospitalName ?? "",
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
                          provider.doctorsList[index].address ?? "",
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
                                provider.doctorsList[index].availableTime ?? "",
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
                          "Last visit: ${provider.doctorsList[index].lastVisit}",
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
              Selector<ScheduleProvider, bool>(
                selector: (context, provider) => provider.listOfAddedSchedule
                    .any((item) =>
                        item["doctor_id"] == provider.doctorsList[index].id),
                builder: (context, isAdded, _) {
                  return ButtonWidget(
                    text: isAdded ? "Added" : "Add to schedule visits",
                    onTap: () {
                      provider.toggleScheduleVisit(
                        provider.doctorsList[index].id ?? 0,
                        provider.doctorsList[index].availableTime ?? "09:30:00",
                      );
                    },
                    textColor: AppColors.mainColor,
                    borderColor: AppColors.mainColor,
                    backgroundColor:
                        isAdded ? AppColors.whiteColor : AppColors.whiteColor,
                    icon: isAdded
                        ? null
                        : Icon(Icons.add, size: 24, color: AppColors.mainColor),
                    fontWeight: FontWeight.w700,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
