import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/ui/widgets/cached_image.dart';
import 'package:rep_visit/base/ui/widgets/main_header.dart';
import 'package:rep_visit/base/ui/widgets/shared_text_form_field.dart';
import 'package:rep_visit/screens/doctors_screen/providers/doctors_provider.dart';
import 'package:rep_visit/screens/doctors_screen/ui/widgets/doctor_filter_widget.dart';
import 'package:rep_visit/screens/doctors_screen/ui/widgets/doctors_shimmer.dart';
import 'package:rep_visit/screens/doctors_screen/ui/widgets/select_doctor.dart';
import 'package:rep_visit/screens/doctors_screen/ui/widgets/doctor_schedule_bottom_sheet.dart';

import '../../../base/constants/app_colors.dart';
import '../../../base/constants/asset_images.dart';
import '../../../base/constants/dimensions.dart';
import '../../../base/ui/widgets/button_widget.dart';
import '../../../base/ui/widgets/text_widget.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DoctorsPage();
  }
}

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var doctorsProvider =
          Provider.of<DoctorsProvider>(context, listen: false);
      // Load filters and doctors list
      await doctorsProvider.getFilters();
      await doctorsProvider.getDoctorsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    var provider = Provider.of<DoctorsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: MainHeader(
            title: "My Doctors".tr(),
            subTitle:
                "Manage your doctor assignments and generate reports".tr()),
      ),
      body: Selector<DoctorsProvider, bool>(
          builder: (context, doctorProvider, widget) {
            if (doctorProvider) {
              return const DoctorCardShimmer();
            }
            return SizedBox.expand(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      await provider.getFilters();
                      await provider.getDoctorsList();
                    },
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SharedTextFormField(
                                    label: "",
                                    hint: "Search".tr(),
                                    controller: searchController,
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    onSubmitted: (_) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    provider
                                        .setOpenFilter(!provider.openFilter);
                                  },
                                  child: Container(
                                    height: 56,
                                    width: 85,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: AppColors.grey300)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: AppColors.grey300),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: SvgPicture.asset(
                                                  AssetImages.filterIcon),
                                            )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: AppColors.grey500,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Selector<DoctorsProvider, bool>(
                                builder: (context, provider, widget) {
                                  return provider
                                      ? const DoctorFilterWidget()
                                      : const SizedBox();
                                },
                                selector: (context, selector) =>
                                    selector.openFilter),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.doctorsList.length,
                              itemBuilder: (context, index) {
                                return doctorSection(index, provider);
                              },
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
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
                            text: "Add Doctor".tr(),
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
                                    return const SelectDoctor();
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
          selector: (context, selector) => selector.isLoading),
    );
  }

  doctorSection(int index, DoctorsProvider provider) {
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
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                            color: _getCategoryColor(
                                provider.doctorsList[index].datumClass ?? ""),
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: TextWidget(
                            provider.doctorsList[index].datumClass ?? "",
                            textSize: 12,
                            fontWeight: FontWeight.w700,
                            textColor: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Available status button

                      Icon(
                        Icons.star,
                        color: AppColors.starColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      TextWidget(
                        provider.doctorsList[index].rating?.toString() ?? "0",
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
                provider.doctorsList[index].name,
                textSize: 16,
                fontWeight: FontWeight.w700,
                textColor: AppColors.fontColor,
              ),
              TextWidget(
                provider.doctorsList[index].speciality,
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
                        provider.doctorsList[index].hospitalName,
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
                          provider.doctorsList[index].address,
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
              // Weekly Schedule Section
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.grey300),
                    color: AppColors.grey50),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            "Weekly Schedule".tr(),
                            textSize: 14,
                            fontWeight: FontWeight.w700,
                            textColor: AppColors.fontColor,
                          ),
                          InkWell(
                            onTap: () {
                              final doctorId = provider.doctorsList[index].id;
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return DoctorScheduleBottomSheet(
                                    doctorId: doctorId,
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.grey100)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 6.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      provider.doctorsList[index].weeklySchedule
                                              .isNotEmpty
                                          ? Icons.edit
                                          : Icons.add,
                                      size: 14,
                                      color: AppColors.fontColor,
                                    ),
                                    const SizedBox(width: 4),
                                    TextWidget(
                                      provider.doctorsList[index].weeklySchedule
                                              .isNotEmpty
                                          ? "Edit".tr()
                                          : "Add".tr(),
                                      textSize: 12,
                                      fontWeight: FontWeight.w600,
                                      textColor: AppColors.fontColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // Show schedule items if available
                      if (provider
                          .doctorsList[index].weeklySchedule.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: provider.doctorsList[index].weeklySchedule
                              .map((schedule) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.grey200),
                              ),
                              child: TextWidget(
                                "${schedule.dayShort??""} \n${schedule.time??""}",
                                textSize: 12,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w500,
                                textColor: AppColors.fontColor,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
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

  // Helper method to get category color
  Color _getCategoryColor(String category) {
    if (category.isEmpty) return AppColors.mainColor;
    switch (category.toUpperCase()) {
      case 'A':
        return AppColors.red;
      case 'B':
        return Colors.orange;
      case 'C':
        return AppColors.success;
      default:
        return AppColors.mainColor;
    }
  }
}
