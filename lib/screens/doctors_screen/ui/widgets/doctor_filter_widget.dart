import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rep_visit/base/ui/widgets/custom_drop_down.dart';
import 'package:rep_visit/screens/doctors_screen/providers/doctors_provider.dart';

class DoctorFilterWidget extends StatelessWidget {
  const DoctorFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DoctorsProvider>(context);

    // Build items list from API data with "All" option
    final categoryItems = [
      'All'.tr(),
      ...provider.categories.map((e) => e.label)
    ];
    final specialtyItems = [
      'All'.tr(),
      ...provider.specialities.map((e) => e.label)
    ];
    final areaItems = ['All'.tr(), ...provider.areas.map((e) => e.label)];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomDropdown(
                label: "Category".tr(),
                hint: 'All'.tr(),
                items: categoryItems,
                value: provider.getCategoryLabel(),
                onChanged: (v) {
                  provider.setCategory(v);
                },
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              child: CustomDropdown(
                label: "Specialties".tr(),
                hint: 'All'.tr(),
                items: specialtyItems,
                value: provider.getSpecialityLabel(),
                onChanged: (v) {
                  provider.setSpeciality(v);
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            Expanded(
              child: CustomDropdown(
                label: "Area".tr(),
                hint: 'All'.tr(),
                items: areaItems,
                value: provider.getAreaLabel(),
                onChanged: (v) {
                  provider.setArea(v);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
