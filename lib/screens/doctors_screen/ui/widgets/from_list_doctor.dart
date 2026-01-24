import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/ui/widgets/button_widget.dart';
import 'package:rep_visit/base/ui/widgets/shared_text_form_field.dart';
import 'package:rep_visit/screens/doctors_screen/models/my_doctors_model.dart';
import 'package:rep_visit/screens/doctors_screen/providers/doctors_provider.dart';

import '../../../../base/constants/app_colors.dart';
import '../../../../base/ui/widgets/cached_image.dart';
import '../../../../base/ui/widgets/custom_check_box.dart';
import '../../../../base/ui/widgets/text_widget.dart';

class FromListDoctor extends StatefulWidget {
  const FromListDoctor({super.key});

  @override
  State<FromListDoctor> createState() => _SelectDoctorState();
}

class _SelectDoctorState extends State<FromListDoctor> {
  @override
  void initState() {
    super.initState();
    // Load my doctors when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<DoctorsProvider>(context, listen: false);
      // Clear previous selections
      provider.clearSelectedDoctors();
      await provider.getMyDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorsProvider>(
      builder: (context, doctorProvider, _) {
        // Filter doctors based on search query
        final searchQuery =
            doctorProvider.searchDoctorController.text.toLowerCase();
        final filteredDoctors = searchQuery.isEmpty
            ? doctorProvider.myDoctorsList
            : doctorProvider.myDoctorsList.where((doctor) {
                return doctor.name?.toLowerCase().contains(searchQuery) ??
                    false ||
                        doctor.hospitalName!
                            .toLowerCase()
                            .contains(searchQuery) ||
                        doctor.speciality!.toLowerCase().contains(searchQuery);
              }).toList();

        return Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    SharedTextFormField(
                      label: "",
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.grey300,
                      ),
                      hint: "Type doctor name, hospital, or specialty...".tr(),
                      controller: doctorProvider.searchDoctorController,
                      onChanged: (_) => setState(() {}), // Rebuild on search
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TextWidget(
                              "Available Doctors".tr(),
                              textSize: 14,
                              fontWeight: FontWeight.w500,
                              textColor: AppColors.fontColor,
                            ),
                            TextWidget(
                              " (${filteredDoctors.length})",
                              textSize: 14,
                              fontWeight: FontWeight.w500,
                              textColor: AppColors.fontColor,
                            ),
                          ],
                        ),
                        if (doctorProvider.selectedDoctorIds.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mainColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextWidget(
                              "${doctorProvider.selectedDoctorIds.length} ${"Selected".tr()}",
                              textSize: 12,
                              fontWeight: FontWeight.w600,
                              textColor: AppColors.whiteColor,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (doctorProvider.isMyDoctorsLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (filteredDoctors.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextWidget(
                            "No doctors found".tr(),
                            textSize: 14,
                            textColor: AppColors.typography500,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredDoctors.length,
                        itemBuilder: (context, index) {
                          return doctorSection(
                              index, doctorProvider, filteredDoctors[index]);
                        },
                      ),
                    const SizedBox(height: 80), // Space for fixed buttons
                  ],
                ),
              ),
            ),
            // Fixed bottom buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      text: "Cancel".tr(),
                      textColor: AppColors.fontColor,
                      backgroundColor: AppColors.whiteColor,
                      borderColor: AppColors.grey300,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ButtonWidget(
                      text: "Add to my List".tr(),
                      textColor: AppColors.whiteColor,
                      backgroundColor:
                          doctorProvider.selectedDoctorIds.isNotEmpty
                              ? AppColors.mainColor
                              : AppColors.grey300,
                      icon: Icon(
                        Icons.add,
                        color: AppColors.whiteColor,
                        size: 18,
                      ),
                      onTap: doctorProvider.selectedDoctorIds.isNotEmpty
                          ? () async {
                              await doctorProvider.addToMyList();
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          : () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  doctorSection(int index, DoctorsProvider provider, Datum doctor) {
    // Determine category button color based on category letter
    Color getCategoryColor(String? category) {
      if (category == null || category.isEmpty) return AppColors.mainColor;
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



    // Check if this doctor is selected
    final doctorId = doctor.id;
    if (doctorId == null) return const SizedBox.shrink();

    final isSelected = provider.isDoctorSelected(doctorId);

    return InkWell(
      onTap: () {
        provider.toggleSelectedDoctor(doctorId);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            border: Border.all(
              color: isSelected ? AppColors.mainColor : AppColors.grey200,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Checkbox
                CustomCheckBox(
                  isChecked: isSelected,
                  checkboxCallback: (value) {
                    provider.toggleSelectedDoctor(doctorId);
                  },
                ),
                const SizedBox(width: 12),
                // Profile picture
                CachedImage(url: doctor.image?.toString() ?? ""),
                const SizedBox(width: 12),
                // Doctor info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor name
                      TextWidget(
                        doctor.name ?? "",
                        textSize: 16,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.fontColor,
                      ),
                      const SizedBox(height: 4),
                      // Specialty
                      TextWidget(
                        doctor.speciality ?? "",
                        textSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.typography500,
                      ),
                      const SizedBox(height: 8),
                      // Category, Availability, and Rating row
                      Row(
                        children: [
                          // Category button
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: getCategoryColor(doctor.datumClass),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: TextWidget(
                                doctor.datumClass ?? "",
                                textSize: 12,
                                fontWeight: FontWeight.w700,
                                textColor: AppColors.whiteColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          const Spacer(),
                          // Star rating
                          Icon(
                            Icons.star,
                            color: AppColors.starColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          TextWidget(
                            doctor.rating?.toString() ?? "0",
                            textSize: 12,
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.typography500,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ), // Row
          ), // Padding (inner)
        ), // Container
      ), // Padding (outer)
    ); // InkWell
  }
}
